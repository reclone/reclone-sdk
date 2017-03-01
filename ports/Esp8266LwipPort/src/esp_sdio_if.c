/*! \file   esp_sdio_if.c
 *
 *  \brief  SDIO interface for connecting STM32F4 with ESP8089/ESP8266
 *
 *  Contains functions for initializing the STM32F4 SDIO peripheral
 *  via STM32F4Cube, sending SDIO commands, and interpreting the results.
 *
 *  \copyright Copyright 2017 Reclone Labs.  All rights reserved.
 *             This file is open source under the BSD 2-Clause license:
 *             https://opensource.org/licenses/BSD-2-Clause
 */

#include <string.h>
#include "esp_sdio_if.h"
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"


#define ROUND_UP(N, S) ((((N) + (S) - 1) / (S)) * (S))

#define SDIO_DMA_STREAM       DMA2_Stream3
#define SDIO_DMA_CHANNEL      DMA_CHANNEL_4
#define SDIO_DMA_FLAG_FEIF    DMA_FLAG_FEIF3
#define SDIO_DMA_FLAG_DMEIF   DMA_FLAG_DMEIF3
#define SDIO_DMA_FLAG_TEIF    DMA_FLAG_TEIF3
#define SDIO_DMA_FLAG_HTIF    DMA_FLAG_HTIF3
#define SDIO_DMA_FLAG_TCIF    DMA_FLAG_TCIF3
#define SDIO_DMA_IRQn         DMA2_Stream3_IRQn
#define SDIO_DMA_IRQHANDLER   DMA2_Stream3_IRQHandler

// A somewhat low clock speed in case long crappy dongle wires are used
#define SDIO_DONGLE_CLK_DIV ((uint8_t)0x4)

#define SIP_BOOT_BUF_SIZE 256

enum ESP_SIP_Command_E
{
   SIP_CMD_GET_VER = 0,
   SIP_CMD_WRITE_MEMORY,
   SIP_CMD_READ_MEMORY,
   SIP_CMD_WRITE_REG,   // ROM code
   SIP_CMD_READ_REG,
   SIP_CMD_BOOTUP,      // ROM code
   SIP_CMD_COPYBACK,
   SIP_CMD_INIT,
   SIP_CMD_SCAN,
   SIP_CMD_SETKEY,
   SIP_CMD_CONFIG,
   SIP_CMD_BSS_INFO_UPDATE,
   SIP_CMD_LOOPBACK,    // ROM code
   SIP_CMD_SET_WMM_PARAM,
   SIP_CMD_AMPDU_ACTION,
   SIP_CMD_HB_REQ,
   SIP_CMD_RESET_MAC,
   SIP_CMD_PRE_DOWN,
   SIP_CMD_SLEEP,
   SIP_CMD_WAKEUP,
   SIP_CMD_DEBUG,
   SIP_CMD_GET_FW_VER,
   SIP_CMD_SETVIF,
   SIP_CMD_SETSTA,
   SIP_CMD_PS,
   SIP_CMD_ATE,
   SIP_CMD_SUSPEND,
   SIP_CMD_RECALC_CREDIT,
   SIP_CMD_MAX
};

enum ESP_SIP_Pkt_Type_E
{
   SIP_CTRL = 0,
   SIP_DATA,
   SIP_DATA_AMPDU
};


static const uint32_t CMD_TIMEOUT_LOOPS = 0x10000;
static GPIO_TypeDef * const RESET_PORT = GPIOB;
static const uint16_t RESET_PIN = GPIO_PIN_0;

static const uint32_t SDIO_DATA_BLOCK_SIZE = 512;
static const uint32_t SDIO_DATA_TIMEOUT = 0xFFFFFFFF;

static const uint32_t SDIO_STATIC_FLAGS =
      SDIO_FLAG_CCRCFAIL | SDIO_FLAG_DCRCFAIL | SDIO_FLAG_CTIMEOUT |
      SDIO_FLAG_DTIMEOUT | SDIO_FLAG_TXUNDERR | SDIO_FLAG_RXOVERR  |
      SDIO_FLAG_CMDREND  | SDIO_FLAG_CMDSENT  | SDIO_FLAG_DATAEND  |
      SDIO_FLAG_DBCKEND;



#define u8 const uint8_t
#include "eagle_fw1.h"
#include "eagle_fw2.h"
#undef u8


static SD_HandleTypeDef SDIO_Handle;
static DMA_HandleTypeDef DMA_Handle;
static SemaphoreHandle_t Xfer_Complete_Semaphore;

struct ESP_SIP_Control_Pkt_S SIP_Ctrl;
static uint32_t Tx_Seq;


HAL_SD_ErrorTypedef ESP_SDIO_GoIdleState(void);
HAL_SD_ErrorTypedef ESP_SDIO_IoSendOpCond(uint32_t arg, bool * out_iordy);
HAL_SD_ErrorTypedef ESP_SDIO_SendRelativeAddress(uint32_t * new_rca);
HAL_SD_ErrorTypedef ESP_SDIO_SelectCard(uint32_t rca);
HAL_SD_ErrorTypedef ESP_SDIO_ReadWriteDirect(
      bool write, uint32_t func, bool raw, uint32_t address, uint8_t * data);


void SDIO_DMA_IRQHANDLER()
{
   static BaseType_t xHigherPriorityTaskWoken = false;

   HAL_DMA_IRQHandler(&DMA_Handle);

   if (HAL_DMA_STATE_READY_MEM0 == DMA_Handle.State || HAL_DMA_STATE_ERROR == DMA_Handle.State)
   {
      if (HAL_DMA_STATE_ERROR == DMA_Handle.State)
      {
         SDIO_Handle.SdTransferErr = SD_ERROR;
      }

      // "Give" to the semaphore to indicate the transfer is complete
      xSemaphoreGiveFromISR(Xfer_Complete_Semaphore, &xHigherPriorityTaskWoken);
   }

   // If a higher priority task has been awoken for this semaphore, then yield
   portYIELD_FROM_ISR( xHigherPriorityTaskWoken );
}

void SDIO_IRQHandler(void)
{
   if (__SDIO_GET_IT(SDIO, SDIO_IT_DCRCFAIL))
   {
      SDIO_Handle.SdTransferErr = SD_DATA_CRC_FAIL;
      __SDIO_CLEAR_IT(SDIO, SDIO_IT_DCRCFAIL);
   }
   else if (__SDIO_GET_IT(SDIO, SDIO_IT_DTIMEOUT))
   {
      SDIO_Handle.SdTransferErr = SD_DATA_TIMEOUT;
      __SDIO_CLEAR_IT(SDIO, SDIO_IT_DTIMEOUT);
   }
   else if (__SDIO_GET_IT(SDIO, SDIO_IT_RXOVERR))
   {
      SDIO_Handle.SdTransferErr = SD_RX_OVERRUN;
      __SDIO_CLEAR_IT(SDIO, SDIO_IT_RXOVERR);
   }
   else if (__SDIO_GET_IT(SDIO, SDIO_IT_TXUNDERR))
   {
      SDIO_Handle.SdTransferErr = SD_TX_UNDERRUN;
      __SDIO_CLEAR_IT(SDIO, SDIO_IT_TXUNDERR);
   }
   else if (__SDIO_GET_IT(SDIO, SDIO_IT_STBITERR))
   {
      SDIO_Handle.SdTransferErr = SD_START_BIT_ERR;
      __SDIO_CLEAR_IT(SDIO, SDIO_IT_STBITERR);
   }
   else if (__SDIO_GET_IT(SDIO, SDIO_IT_DATAEND))
   {
      SDIO_Handle.SdTransferErr = SD_OK;
      __SDIO_CLEAR_IT(SDIO, SDIO_IT_DATAEND);
   }

   __SDIO_DISABLE_IT(SDIO,
         SDIO_IT_DCRCFAIL | SDIO_IT_DTIMEOUT | SDIO_IT_DATAEND | SDIO_IT_TXFIFOHE |
         SDIO_IT_RXFIFOHF | SDIO_IT_TXUNDERR | SDIO_IT_RXOVERR | SDIO_IT_STBITERR);
}

void ESP_SDIO_InitHardware(void)
{
   GPIO_InitTypeDef gpio_init;

   // Enable GPIO clocks
   __HAL_RCC_GPIOB_CLK_ENABLE();
   __HAL_RCC_GPIOC_CLK_ENABLE();
   __HAL_RCC_GPIOD_CLK_ENABLE();

   // CH_PD pin that gets toggled to reset the chip
   gpio_init.Speed = GPIO_SPEED_FREQ_LOW;
   gpio_init.Pull = GPIO_PULLUP;
   gpio_init.Mode = GPIO_MODE_OUTPUT_PP;
   gpio_init.Pin = RESET_PIN;
   HAL_GPIO_Init(RESET_PORT, &gpio_init);

   // Set the following pins for high speed, pull up, alternate function push/pull, SDIO
   gpio_init.Speed = GPIO_SPEED_FREQ_HIGH;
   gpio_init.Pull = GPIO_PULLUP;
   gpio_init.Alternate = GPIO_AF12_SDIO;
   gpio_init.Mode = GPIO_MODE_AF_PP;

   // SDIO Data 0-3 and SDIO Clock pins
   gpio_init.Pin = GPIO_PIN_8 | GPIO_PIN_9 | GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12;
   HAL_GPIO_Init(GPIOC, &gpio_init);

   // SDIO Command pin
   gpio_init.Pin = GPIO_PIN_2;
   HAL_GPIO_Init(GPIOD, &gpio_init);

   // SDIO peripheral
   SDIO_Handle.Instance = SDIO;
   SDIO_Handle.Init.BusWide = SDIO_BUS_WIDE_1B;
   SDIO_Handle.Init.ClockBypass = SDIO_CLOCK_BYPASS_DISABLE;
   SDIO_Handle.Init.ClockDiv = SDIO_INIT_CLK_DIV;
   SDIO_Handle.Init.ClockEdge = SDIO_CLOCK_EDGE_RISING;
   SDIO_Handle.Init.ClockPowerSave = SDIO_CLOCK_POWER_SAVE_DISABLE;
   SDIO_Handle.Init.HardwareFlowControl = SDIO_HARDWARE_FLOW_CONTROL_DISABLE;
   SDIO_Handle.hdmarx = &DMA_Handle;
   SDIO_Handle.hdmatx = &DMA_Handle;
   SDIO_Init(SDIO, SDIO_Handle.Init);

   // Enable SDIO I/O card mode
   SDIO->DCTRL |= SDIO_DCTRL_SDIOEN;

   __HAL_RCC_SDIO_CLK_ENABLE();

   // Turn on SDIO
   SDIO_PowerState_ON(SDIO);

   // Enable SDIO clock
   __SDIO_ENABLE();

   // Enable DMA2 clock
   __HAL_RCC_DMA2_CLK_ENABLE();

   // Init DMA state variables
   DMA_Handle.State = HAL_DMA_STATE_RESET;
   DMA_Handle.ErrorCode = HAL_DMA_ERROR_NONE;
   DMA_Handle.Lock = HAL_UNLOCKED;

   // Init interrupts for DMA and SDIO
   HAL_NVIC_SetPriority(SDIO_DMA_IRQn, configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY, 0);
   HAL_NVIC_EnableIRQ(SDIO_DMA_IRQn);
   HAL_NVIC_SetPriority(SDIO_IRQn, configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY+1, 0);
   HAL_NVIC_EnableIRQ(SDIO_IRQn);

   // Binary semaphore used to notify of DMA completion
   Xfer_Complete_Semaphore = xSemaphoreCreateBinary();

   // Transmit sequence number
   Tx_Seq = 0;
}

void ESP_SDIO_ToggleReset(void)
{
   // Reset the WiFi module by sending a low enable pulse
   HAL_GPIO_WritePin(RESET_PORT, RESET_PIN, GPIO_PIN_RESET);
   vTaskDelay(200);
   HAL_GPIO_WritePin(RESET_PORT, RESET_PIN, GPIO_PIN_SET);
   vTaskDelay(200);
}

bool ESP_SDIO_ResetToCmdState(void)
{
   const uint32_t CMD5_VOLTAGE_ARG = 0x10000; //3.2-3.3v
   const uint32_t MAX_CMD5_RETRIES = 100;
   const uint32_t MAX_CMD3_RETRIES = 100;
   bool reset_result = false;
   uint32_t retries;
   uint16_t rca = 0;

   if (SD_OK == ESP_SDIO_GoIdleState())
   {
      // In Idle state
      bool iordy = false;
      vTaskDelay(1);
      if (SD_OK == ESP_SDIO_IoSendOpCond(0, &iordy))
      {
         vTaskDelay(1);
         HAL_SD_ErrorTypedef retry_result = SD_OK;

         iordy = false;
         retries = 0;
         while (SD_OK == retry_result && !iordy && retries < MAX_CMD5_RETRIES)
         {
            retry_result = ESP_SDIO_IoSendOpCond(CMD5_VOLTAGE_ARG, &iordy);
            ++retries;
            vTaskDelay(1);
         }

         if (retry_result == SD_OK && iordy && retries < MAX_CMD5_RETRIES)
         {
            SDIO_Handle.RCA = 0;
            retries = 0;
            retry_result = SD_OK;
            while (SD_OK == retry_result && 0 == SDIO_Handle.RCA && retries < MAX_CMD3_RETRIES)
            {
               retry_result = ESP_SDIO_SendRelativeAddress(&(SDIO_Handle.RCA));
               ++retries;
               vTaskDelay(1);
            }

            if (SD_OK == retry_result && 0 != SDIO_Handle.RCA && retries < MAX_CMD3_RETRIES)
            {
               vTaskDelay(1);
               // In Standby state with a valid relative card address
               if (SD_OK == ESP_SDIO_SelectCard(SDIO_Handle.RCA))
               {
                  vTaskDelay(1);
                  // Enable 4-bit bus and 24 MHz clock speed
                  uint8_t bus_interface_control = 0x02;
                  if (SD_OK == ESP_SDIO_ReadWriteDirect(true, 0, false, 0x07, &bus_interface_control))
                  {
                     SDIO_Handle.Instance = SDIO;
                     SDIO_Handle.Init.BusWide = SDIO_BUS_WIDE_4B;
                     SDIO_Handle.Init.ClockBypass = SDIO_CLOCK_BYPASS_DISABLE;
                     SDIO_Handle.Init.ClockDiv = SDIO_DONGLE_CLK_DIV;
                     SDIO_Handle.Init.ClockEdge = SDIO_CLOCK_EDGE_RISING;
                     SDIO_Handle.Init.ClockPowerSave = SDIO_CLOCK_POWER_SAVE_DISABLE;
                     SDIO_Handle.Init.HardwareFlowControl = SDIO_HARDWARE_FLOW_CONTROL_DISABLE;
                     SDIO_Init(SDIO, SDIO_Handle.Init);
                     vTaskDelay(1);

                     // Enable high speed in High Speed register
//                     uint8_t high_speed = 2;
//                     if (SD_OK == ESP_SDIO_ReadWriteDirect(true, 0, true, 0x13, &high_speed) && (high_speed & 3) == 3)
//                     {
//                        SDIO_Handle.Init.ClockBypass = SDIO_CLOCK_BYPASS_ENABLE;
//                        SDIO_Init(SDIO, SDIO_Handle.Init);
//                        vTaskDelay(1);
//                     }

                     uint8_t power_control = 2;
                     // Enable high current in Power Control register
                     if (SD_OK == ESP_SDIO_ReadWriteDirect(true, 0, true, 0x12, &power_control) && (power_control & 3) == 3)
                     {
                        vTaskDelay(1);
                        // Enable function 1
                        uint8_t io_enable = 2;
                        if (SD_OK == ESP_SDIO_ReadWriteDirect(true, 0, true, 0x02, &io_enable) && (io_enable & 2) == 2)
                        {
                           reset_result = true;
                        }
                     }

                  }
               }

            }
         }
      }
   }

   return reset_result;
}

HAL_SD_ErrorTypedef ESP_SDIO_SendCommand(uint32_t cmdIndex, uint32_t arg, uint32_t respType, bool expectCrcFail)
{
   SDIO_CmdInitTypeDef cmd;
   HAL_SD_ErrorTypedef sdio_err = SD_OK;
   uint32_t timer = 0;
   bool expectNoResp = (respType == SDIO_RESPONSE_NO);

   cmd.Argument = arg;
   cmd.CmdIndex = cmdIndex;
   cmd.Response = respType;
   cmd.WaitForInterrupt = SDIO_WAIT_NO;
   cmd.CPSM = SDIO_CPSM_ENABLE;
   SDIO_SendCommand(SDIO, &cmd);

   if (expectNoResp)
   {
      // We don't expect a response.  Just busy-loop until the command is sent.
      while ((timer < CMD_TIMEOUT_LOOPS) && (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDSENT) == RESET))
      {
         __NOP();
         ++timer;
      }
   }
   else
   {
      // We do expect a response.  Busy-loop until a timeout, CRC failure, or response received.
      while ((timer < CMD_TIMEOUT_LOOPS) &&
         (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CCRCFAIL) == RESET) &&
         (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDREND) == RESET) &&
         (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == RESET))
      {
         __NOP();
         ++timer;
      }
   }

   if (timer >= CMD_TIMEOUT_LOOPS || (!expectNoResp && __SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == SET))
   {
      sdio_err = SD_CMD_RSP_TIMEOUT;
   }
   else if (!expectNoResp && !expectCrcFail && __SDIO_GET_FLAG(SDIO, SDIO_FLAG_CCRCFAIL) == SET)
   {
      sdio_err = SD_CMD_CRC_FAIL;
   }
   else
   {
      // Reset SDIO flags
      __SDIO_CLEAR_FLAG(SDIO, SDIO_STATIC_FLAGS);

      // Command completed successfully.  We can now parse the response from SDIO_GetResponse().
   }

   return sdio_err;
}

bool ESP_SDIO_DMA_RxConfig(uint32_t * destBuffer, uint32_t bufferSize)
{
   bool success = false;

   __SDIO_ENABLE_IT(SDIO, SDIO_IT_DCRCFAIL | SDIO_IT_DTIMEOUT | SDIO_IT_DATAEND | SDIO_IT_RXOVERR | SDIO_IT_STBITERR);
   __SDIO_DMA_ENABLE();

   // Set DMA parameters
   DMA_Handle.Instance = SDIO_DMA_STREAM;
   DMA_Handle.Init.Channel = SDIO_DMA_CHANNEL;
   DMA_Handle.Init.Direction = DMA_PERIPH_TO_MEMORY;
   DMA_Handle.Init.FIFOMode = DMA_FIFOMODE_ENABLE;
   DMA_Handle.Init.FIFOThreshold = DMA_FIFO_THRESHOLD_FULL;
   DMA_Handle.Init.MemBurst = DMA_MBURST_INC4;
   DMA_Handle.Init.MemDataAlignment = DMA_MDATAALIGN_WORD;
   DMA_Handle.Init.MemInc = DMA_MINC_ENABLE;
   DMA_Handle.Init.Mode = DMA_SxCR_PFCTRL;
   DMA_Handle.Init.PeriphBurst = DMA_PBURST_INC4;
   DMA_Handle.Init.PeriphDataAlignment = DMA_PDATAALIGN_WORD;
   DMA_Handle.Init.PeriphInc = DMA_PINC_DISABLE;
   DMA_Handle.Init.Priority = DMA_PRIORITY_VERY_HIGH;
   DMA_Handle.Parent = (void *)&SDIO_Handle;
   DMA_Handle.XferCpltCallback = NULL;
   DMA_Handle.XferErrorCallback = NULL;
   DMA_Handle.XferHalfCpltCallback = NULL;
   DMA_Handle.XferM1CpltCallback = NULL;

   if (HAL_OK == HAL_DMA_Init(&DMA_Handle))
   {
      if (HAL_OK == HAL_DMA_Start_IT(&DMA_Handle, (uint32_t)&SDIO->FIFO, (uint32_t)destBuffer, bufferSize/4))
      {
         success = true;
      }
   }

   return success;
}

bool ESP_SDIO_DMA_TxConfig(uint32_t const * srcBuffer, uint32_t bufferSize)
{
   bool success = false;

   __SDIO_ENABLE_IT(SDIO, SDIO_IT_DCRCFAIL | SDIO_IT_DTIMEOUT | SDIO_IT_DATAEND | SDIO_IT_TXUNDERR | SDIO_IT_STBITERR);
   __SDIO_DMA_ENABLE();

   // Set DMA parameters
   DMA_Handle.Instance = SDIO_DMA_STREAM;
   DMA_Handle.Init.Channel = SDIO_DMA_CHANNEL;
   DMA_Handle.Init.Direction = DMA_MEMORY_TO_PERIPH;
   DMA_Handle.Init.FIFOMode = DMA_FIFOMODE_ENABLE;
   DMA_Handle.Init.FIFOThreshold = DMA_FIFO_THRESHOLD_HALFFULL;
   DMA_Handle.Init.MemBurst = DMA_MBURST_SINGLE;
   DMA_Handle.Init.MemDataAlignment = DMA_MDATAALIGN_BYTE;
   DMA_Handle.Init.MemInc = DMA_MINC_ENABLE;
   DMA_Handle.Init.Mode = DMA_SxCR_PFCTRL;
   DMA_Handle.Init.PeriphBurst = DMA_PBURST_INC4;
   DMA_Handle.Init.PeriphDataAlignment = DMA_PDATAALIGN_WORD;
   DMA_Handle.Init.PeriphInc = DMA_PINC_DISABLE;
   DMA_Handle.Init.Priority = DMA_PRIORITY_VERY_HIGH;
   DMA_Handle.Parent = (void *)&SDIO_Handle;
   DMA_Handle.XferCpltCallback = NULL;
   DMA_Handle.XferErrorCallback = NULL;
   DMA_Handle.XferHalfCpltCallback = NULL;
   DMA_Handle.XferM1CpltCallback = NULL;

   if (HAL_OK == HAL_DMA_Init(&DMA_Handle))
   {
      if (HAL_OK == HAL_DMA_Start_IT(&DMA_Handle, (uint32_t)srcBuffer, (uint32_t)&SDIO->FIFO, bufferSize/4))
      {
         success = true;
      }
   }

   return success;
}

HAL_SD_ErrorTypedef ESP_SDIO_ReadExtended(
      uint32_t func, bool blockMode, bool incrAddr, uint32_t address, uint32_t count)
{
   uint32_t arg = ((func & 7) << 28) | (blockMode ? 0x8000000 : 0) |
                  (incrAddr ? 0x4000000 : 0) | ((address & 0x1FFFF) << 9) | (count & 0x1FF);
   SDIO_DataInitTypeDef data_init;

   data_init.DPSM = SDIO_DPSM_ENABLE;
   data_init.DataBlockSize = SDIO_DATA_BLOCK_SIZE;
   if (blockMode)
   {
      data_init.DataLength = SDIO_DATA_BLOCK_SIZE * count;
   }
   else
   {
      data_init.DataLength = count;
   }
   data_init.DataTimeOut = SDIO_DATA_TIMEOUT;
   data_init.TransferDir = SDIO_TRANSFER_DIR_TO_SDIO;
   data_init.TransferMode = blockMode ? SDIO_TRANSFER_MODE_BLOCK : SDIO_TRANSFER_MODE_STREAM;
   SDIO_DataConfig(SDIO, &data_init);

   HAL_SD_ErrorTypedef sdio_err =
         ESP_SDIO_SendCommand(SD_CMD_SDIO_RW_EXTENDED, arg, SDIO_RESPONSE_SHORT, false);

   if (SD_OK == sdio_err)
   {
      uint32_t resp = SDIO_GetResponse(SDIO_RESP1);
      uint32_t errFlags = (SDIO_GetResponse(SDIO_RESP1) >> 8) & 0xCF;
      if (errFlags != 0)
      {
         sdio_err = SD_ERROR;
      }
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_WriteExtended(
      uint32_t func, bool blockMode, bool incrAddr, uint32_t address, uint32_t count)
{
   uint32_t arg = 0x80000000/*write*/ | ((func & 7) << 28) | (blockMode ? 0x8000000 : 0) |
                  (incrAddr ? 0x4000000 : 0) | ((address & 0x1FFFF) << 9) | (count & 0x1FF);
   SDIO_DataInitTypeDef data_init;

   HAL_SD_ErrorTypedef sdio_err =
         ESP_SDIO_SendCommand(SD_CMD_SDIO_RW_EXTENDED, arg, SDIO_RESPONSE_SHORT, false);

   if (SD_OK == sdio_err)
   {
      uint32_t resp = SDIO_GetResponse(SDIO_RESP1);
      uint32_t errFlags = (SDIO_GetResponse(SDIO_RESP1) >> 8) & 0xCF;
      if (errFlags != 0)
      {
         sdio_err = SD_ERROR;
      }
      else
      {
         data_init.DPSM = SDIO_DPSM_ENABLE;
         data_init.DataBlockSize = SDIO_DATA_BLOCK_SIZE;
         if (blockMode)
         {
            data_init.DataLength = SDIO_DATA_BLOCK_SIZE * count;
         }
         else
         {
            data_init.DataLength = count;
         }
         data_init.DataTimeOut = SDIO_DATA_TIMEOUT;
         data_init.TransferDir = SDIO_TRANSFER_DIR_TO_CARD;
         data_init.TransferMode = blockMode ? SDIO_TRANSFER_MODE_BLOCK : SDIO_TRANSFER_MODE_STREAM;
         SDIO_DataConfig(SDIO, &data_init);
      }
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_ReadWriteDirect(
      bool write, uint32_t func, bool raw, uint32_t address, uint8_t * data)
{
   uint32_t arg = (write ? 0x80000000 : 0) | ((func & 7) << 28) | (raw ? 0x8000000 : 0) |
                  ((address & 0x1FFFF) << 9) | (*data & 0xFF);
   HAL_SD_ErrorTypedef sdio_err =
         ESP_SDIO_SendCommand(SD_CMD_SDIO_RW_DIRECT, arg, SDIO_RESPONSE_SHORT, false);

   if (SD_OK == sdio_err)
   {
      uint32_t resp = SDIO_GetResponse(SDIO_RESP1);
      uint32_t errFlags = (resp >> 8) & 0xCF;
      if (errFlags != 0)
      {
         sdio_err = SD_ERROR;
      }
      else if (!write || raw)
      {
         *data = (uint8_t)(resp & 0xFF);
      }
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_ReadWriteShort(
      bool write, uint32_t func, bool raw, uint32_t address, uint16_t * data)
{
   HAL_SD_ErrorTypedef status;
   uint8_t byte0 = *data & 0xFF;
   uint8_t byte1 = (*data >> 8) & 0xFF;

   status = ESP_SDIO_ReadWriteDirect(write, func, raw, address, &byte0);
   if (SD_OK == status)
   {
      status = ESP_SDIO_ReadWriteDirect(write, func, raw, address + 1, &byte1);
      if (SD_OK == status)
      {
         *data = (uint16_t)byte0 + ((uint16_t)byte1 << 8);
      }
   }

   return status;
}

HAL_SD_ErrorTypedef ESP_SDIO_ReadWriteWord(
      bool write, uint32_t func, bool raw, uint32_t address, uint32_t * data)
{
   HAL_SD_ErrorTypedef status;
   uint8_t byte0 = (uint8_t)(*data & 0xFF);
   uint8_t byte1 = (uint8_t)((*data >> 8) & 0xFF);
   uint8_t byte2 = (uint8_t)((*data >> 16) & 0xFF);
   uint8_t byte3 = (uint8_t)((*data >> 24) & 0xFF);

   status = ESP_SDIO_ReadWriteDirect(write, func, raw, address, &byte0);
   if (SD_OK == status)
   {
      status = ESP_SDIO_ReadWriteDirect(write, func, raw, address + 1, &byte1);
      if (SD_OK == status)
      {
         status = ESP_SDIO_ReadWriteDirect(write, func, raw, address + 2, &byte2);
         if (SD_OK == status)
         {
            status = ESP_SDIO_ReadWriteDirect(write, func, raw, address + 3, &byte3);
            if (SD_OK == status)
            {
               *data = (uint32_t)byte0 + ((uint32_t)byte1 << 8) + ((uint32_t)byte2 << 16) + ((uint32_t)byte3 << 24);
            }
         }
      }
   }

   return status;
}

HAL_SD_ErrorTypedef ESP_SDIO_ReadBytes(uint32_t * destBuffer, uint32_t numBytes, uint32_t address, uint32_t func)
{
   HAL_SD_ErrorTypedef sdio_err = SD_OK;

   // Set up DMA
   // TODO: support block transfer for sizes >= 512
   if (numBytes < SDIO_DATA_BLOCK_SIZE && ESP_SDIO_DMA_RxConfig(destBuffer, numBytes))
   {
      // Send command
      sdio_err = ESP_SDIO_ReadExtended(func, false, true, address, numBytes);
      if (SD_OK == sdio_err)
      {
         // Wait for DMA to complete (indefinitely)
         xSemaphoreTake(Xfer_Complete_Semaphore, portMAX_DELAY);

         // Cleanly close/abort/disable the DMA transfer
         HAL_DMA_Abort(&DMA_Handle);

         // Check SD status
         sdio_err = SDIO_Handle.SdTransferErr;
      }
      else
      {
         sdio_err = SD_ERROR;
      }
   }
   else
   {
      sdio_err = SD_INVALID_PARAMETER;
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_WriteBytes(uint32_t const * srcBuffer, uint32_t numBytes, uint32_t address, uint32_t func)
{
   HAL_SD_ErrorTypedef sdio_err = SD_OK;

   // TODO: support block transfer for sizes >= 512
   if (numBytes < SDIO_DATA_BLOCK_SIZE)
   {
      // Send command
      sdio_err = ESP_SDIO_WriteExtended(func, false, true, address, numBytes);
      if (SD_OK == sdio_err)
      {
         if (ESP_SDIO_DMA_TxConfig(srcBuffer, numBytes))
         {
            // Wait for DMA to complete (indefinitely)
            xSemaphoreTake(Xfer_Complete_Semaphore, portMAX_DELAY);

            // Cleanly close/abort/disable the DMA transfer
            HAL_DMA_Abort(&DMA_Handle);

            // Check SD status
            sdio_err = SDIO_Handle.SdTransferErr;
         }
         else
         {
            sdio_err = SD_ERROR;
         }
      }
      else
      {
         sdio_err = SD_ERROR;
      }
   }
   else
   {
      sdio_err = SD_INVALID_PARAMETER;
   }

   return sdio_err;
}

bool ESP_SDIO_GetCCCR(CCCR_Registers_T * cccr_reg)
{
   return (SD_OK == ESP_SDIO_ReadBytes(
         cccr_reg->Word, sizeof(CCCR_Registers_T), 0, 0));
}

bool ESP_SDIO_GetFBR(FBR_Registers_T * fbr_reg, uint32_t func)
{
   bool retval = false;

   if (func >= 1 && func <= 7)
   {
      retval = (SD_OK == ESP_SDIO_ReadBytes(
            fbr_reg->Word, sizeof(FBR_Registers_T), 0x100 * func, 0));
   }

   return retval;
}

HAL_SD_ErrorTypedef ESP_SDIO_GoIdleState(void)
{
   return ESP_SDIO_SendCommand(SD_CMD_GO_IDLE_STATE, 0, SDIO_RESPONSE_NO, false);
}

HAL_SD_ErrorTypedef ESP_SDIO_IoSendOpCond(uint32_t arg, bool * out_iordy)
{
   // We expect CRC to fail on CMD5
   HAL_SD_ErrorTypedef sdio_err = ESP_SDIO_SendCommand(SD_CMD_SDIO_SEN_OP_COND, arg, SDIO_RESPONSE_SHORT, true);

   if (SD_OK == sdio_err)
   {
      *out_iordy = (((SDIO_GetResponse(SDIO_RESP1) >> 31) & 1) != 0);
   }
   else
   {
      *out_iordy = false;
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_SendRelativeAddress(uint32_t * new_rca)
{
   HAL_SD_ErrorTypedef sdio_err = ESP_SDIO_SendCommand(SD_CMD_SET_REL_ADDR, 0, SDIO_RESPONSE_SHORT, false);

   if (SD_OK == sdio_err)
   {
      *new_rca = (SDIO_GetResponse(SDIO_RESP1) >> 16) & 0xFFFF;
   }
   else
   {
      *new_rca = 0;
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_SelectCard(uint32_t rca)
{
   HAL_SD_ErrorTypedef sdio_err = ESP_SDIO_SendCommand(SD_CMD_SEL_DESEL_CARD, ((uint32_t)rca) << 16, SDIO_RESPONSE_SHORT, false);

   if (SD_OK == sdio_err)
   {
      uint32_t card_status = SDIO_GetResponse(SDIO_RESP1);
      // SDIO cards will always reply with CURRENT_STATE==0xF (bits 12:9)
      if (card_status != 0x00001e00)
      {
         // Error flags occurred; I'm lazy so let's call this a nondescript error
         sdio_err = SD_ERROR;
      }
   }

   return sdio_err;
}

bool ESP_SDIO_VerifyTargetID(void)
{
   uint16_t target_id;
   // Get Target ID.  ESP-12F should have target_id=0x600; hard-code to expect that for now
   return (SD_OK == ESP_SDIO_ReadWriteShort(false, 1, false, 0x7C, &target_id) && 0x600 == target_id);
}

bool ESP_SDIO_SIP_SendCommand(void const * command_data, uint32_t length)
{
   const uint32_t SLC_WINDOW_END_ADDRESS = 0x20000 - 0x800;
   uint32_t addr = SLC_WINDOW_END_ADDRESS - length;

   return (SD_OK == ESP_SDIO_WriteBytes((uint32_t const *)command_data, length, addr, 1));
}

bool ESP_SDIO_SIP_WriteMemory(uint32_t address, uint8_t const * buffer, uint32_t length)
{
   bool success = true;
   uint32_t remain_bytes = length;

   while (success && remain_bytes > 0)
   {
      const uint8_t * fw_cur_pos = &buffer[length - remain_bytes];
      uint32_t load_addr = address + (length - remain_bytes);
      const uint32_t hdr_size = sizeof(struct ESP_SIP_Header_S) +
            sizeof(struct ESP_SIP_WriteMemory_S);
      uint32_t buf_size;
      struct ESP_SIP_WriteMemory_S * cmd;

      if (remain_bytes < (SIP_BOOT_BUF_SIZE - hdr_size))
      {
         buf_size = ROUND_UP(remain_bytes, 4);
         memset(SIP_Ctrl.CmdBuf, 0, sizeof(SIP_Ctrl.CmdBuf));
         remain_bytes = 0;
      }
      else
      {
         buf_size = SIP_BOOT_BUF_SIZE - hdr_size;
         remain_bytes -= buf_size;
      }

      SIP_Ctrl.Header.Fc[0] = SIP_CTRL;
      SIP_Ctrl.Header.Fc[1] = 0;
      SIP_Ctrl.Header.Length = buf_size + hdr_size;
      SIP_Ctrl.Header.Param.CmdId = SIP_CMD_WRITE_MEMORY;
      SIP_Ctrl.Header.Sequence = Tx_Seq++;
      cmd = (struct ESP_SIP_WriteMemory_S *)SIP_Ctrl.CmdBuf;
      cmd->Address = load_addr;
      cmd->Length = buf_size;
      memcpy(SIP_Ctrl.CmdBuf + sizeof(struct ESP_SIP_WriteMemory_S), fw_cur_pos, buf_size);
      success = ESP_SDIO_SIP_SendCommand(&SIP_Ctrl, SIP_Ctrl.Header.Length);
   }

   return success;
}

bool ESP_SDIO_SIP_BootUp(uint32_t address)
{

}

bool ESP_SDIO_BootFirmwareBlob(uint8_t const * blob)
{
   bool success = true;
   struct ESP_Firmware_Header_S * fw_hdr = (struct ESP_Firmware_Header_S *)blob;
   struct ESP_Block_Header_S * blk_hdr;
   uint32_t offset = sizeof(struct ESP_Firmware_Header_S);

   // Program each firmware block
   for (uint32_t blocknum = 0; blocknum < fw_hdr->Blocks; ++blocknum)
   {
      blk_hdr = (struct ESP_Block_Header_S *)&(blob[offset]);
      offset += sizeof(struct ESP_Block_Header_S);
      success = ESP_SDIO_SIP_WriteMemory(blk_hdr->LoadAddr, &(blob[offset]), blk_hdr->DataLength);
      if (!success)
      {
         break;
      }
      offset += blk_hdr->DataLength;
   }

   if (success)
   {
      success = ESP_SDIO_SIP_BootUp(fw_hdr->EntryAddr);
   }

   return success;
}

bool ESP_SDIO_ProgramFirmware(void)
{
   bool success = false;
   CCCR_Registers_T cccr;

   // We assume that ESP_SDIO_ResetToCmdState() was already called once
   // Check CCCR for readiness - 4 bit bus and function 1 enabled
   if (ESP_SDIO_GetCCCR(&cccr) && cccr.Reg.IOR1 && cccr.Reg.IOE1 && 2 == cccr.Reg.BusWidth)
   {
      if (ESP_SDIO_VerifyTargetID() &&
          ESP_SDIO_BootFirmwareBlob(eagle_fw1) //&&
          //ESP_SDIO_ResetToCmdState() &&
          //ESP_SDIO_VerifyTargetID() &&
          //ESP_SDIO_BootFirmwareBlob(eagle_fw2) &&
          //ESP_SDIO_ResetToCmdState()
          )
      {
         success = true;
      }
   }

   return success;
}
