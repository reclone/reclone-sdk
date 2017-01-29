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


#include "esp_sdio_if.h"
#include "FreeRTOS.h"
#include "task.h"

#define SDIO_DMA_STREAM       DMA2_Stream3
#define SDIO_DMA_CHANNEL      DMA_Channel_4
#define SDIO_DMA_FLAG_FEIF    DMA_FLAG_FEIF3
#define SDIO_DMA_FLAG_DMEIF   DMA_FLAG_DMEIF3
#define SDIO_DMA_FLAG_TEIF    DMA_FLAG_TEIF3
#define SDIO_DMA_FLAG_HTIF    DMA_FLAG_HTIF3
#define SDIO_DMA_FLAG_TCIF    DMA_FLAG_TCIF3
#define SDIO_DMA_IRQn         DMA2_Stream3_IRQn
#define SDIO_DMA_IRQHANDLER   DMA2_Stream3_IRQHandler


static const uint32_t CMD_TIMEOUT_LOOPS = 0x10000;
static GPIO_TypeDef * const RESET_PORT = GPIOB;
static const uint16_t RESET_PIN = GPIO_PIN_0;

static const uint32_t SDIO_STATIC_FLAGS =
      SDIO_FLAG_CCRCFAIL | SDIO_FLAG_DCRCFAIL | SDIO_FLAG_CTIMEOUT |
      SDIO_FLAG_DTIMEOUT | SDIO_FLAG_TXUNDERR | SDIO_FLAG_RXOVERR  |
      SDIO_FLAG_CMDREND  | SDIO_FLAG_CMDSENT  | SDIO_FLAG_DATAEND  |
      SDIO_FLAG_DBCKEND;

static SD_HandleTypeDef SDIO_Handle;
static DMA_HandleTypeDef DMA_Rx_Handle;
static DMA_HandleTypeDef DMA_Tx_Handle;

static uint16_t Relative_Card_Address;

static uint32_t Card_Common_Control_Registers[0x14 / 4];

void ESP_SDIO_ToggleReset(void);
HAL_SD_ErrorTypedef ESP_SDIO_GoIdleState(void);
HAL_SD_ErrorTypedef ESP_SDIO_IoSendOpCond(uint32_t arg, bool * out_iordy);
HAL_SD_ErrorTypedef ESP_SDIO_SendRelativeAddress(uint16_t * new_rca);
HAL_SD_ErrorTypedef ESP_SDIO_SelectCard(uint16_t rca);


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
   gpio_init.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
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
   SDIO_Handle.hdmarx = &DMA_Rx_Handle;
   SDIO_Handle.hdmatx = &DMA_Tx_Handle;
   SDIO_Init(SDIO, SDIO_Handle.Init);

   __HAL_RCC_SDIO_CLK_ENABLE();

   // Turn on SDIO
   SDIO_PowerState_ON(SDIO);

   // Enable SDIO clock
   __SDIO_ENABLE();

   // Enable DMA2 clock
   __HAL_RCC_DMA2_CLK_ENABLE();

   DMA_Rx_Handle.Instance = SDIO_DMA_STREAM;
   DMA_Rx_Handle.Init.Channel = SDIO_DMA_CHANNEL;
   DMA_Rx_Handle.Init.Direction = DMA_PERIPH_TO_MEMORY;
   DMA_Rx_Handle.Init.FIFOMode = DMA_FIFOMODE_ENABLE;
   DMA_Rx_Handle.Init.FIFOThreshold = DMA_FIFO_THRESHOLD_FULL;
   DMA_Rx_Handle.Init.MemBurst = DMA_MBURST_INC4;
   DMA_Rx_Handle.Init.MemDataAlignment = DMA_MDATAALIGN_WORD;
   DMA_Rx_Handle.Init.MemInc = DMA_MINC_ENABLE;
   DMA_Rx_Handle.Init.Mode = DMA_NORMAL;
   DMA_Rx_Handle.Init.PeriphBurst = DMA_PBURST_INC4;
   DMA_Rx_Handle.Init.PeriphDataAlignment = DMA_PDATAALIGN_WORD;
   DMA_Rx_Handle.Init.PeriphInc = DMA_PINC_DISABLE;
   DMA_Rx_Handle.Init.Priority = DMA_PRIORITY_VERY_HIGH;
   DMA_Rx_Handle.Parent = SDIO_Handle;
   DMA_Rx_Handle.State = HAL_DMA_STATE_RESET;
   DMA_Rx_Handle.ErrorCode = 0;
   DMA_Rx_Handle.Lock = HAL_UNLOCKED;

   DMA_Tx_Handle.Instance = SDIO_DMA_STREAM;
   DMA_Tx_Handle.Init.Channel = SDIO_DMA_CHANNEL;
   DMA_Tx_Handle.Init.Direction = DMA_MEMORY_TO_PERIPH;
   DMA_Tx_Handle.Init.FIFOMode = DMA_FIFOMODE_ENABLE;
   DMA_Tx_Handle.Init.FIFOThreshold = DMA_FIFO_THRESHOLD_FULL;
   DMA_Tx_Handle.Init.MemBurst = DMA_MBURST_INC4;
   DMA_Tx_Handle.Init.MemDataAlignment = DMA_MDATAALIGN_WORD;
   DMA_Tx_Handle.Init.MemInc = DMA_MINC_ENABLE;
   DMA_Tx_Handle.Init.Mode = DMA_NORMAL;
   DMA_Tx_Handle.Init.PeriphBurst = DMA_PBURST_INC4;
   DMA_Tx_Handle.Init.PeriphDataAlignment = DMA_PDATAALIGN_WORD;
   DMA_Tx_Handle.Init.PeriphInc = DMA_PINC_DISABLE;
   DMA_Tx_Handle.Init.Priority = DMA_PRIORITY_VERY_HIGH;
   DMA_Tx_Handle.Parent = SDIO_Handle;
   DMA_Tx_Handle.State = HAL_DMA_STATE_RESET;
   DMA_Tx_Handle.ErrorCode = 0;
   DMA_Tx_Handle.Lock = HAL_UNLOCKED;

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

   ESP_SDIO_ToggleReset();
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
            Relative_Card_Address = 0;
            retries = 0;
            retry_result = SD_OK;
            while (SD_OK == retry_result && 0 == Relative_Card_Address && retries < MAX_CMD3_RETRIES)
            {
               retry_result = ESP_SDIO_SendRelativeAddress(&(SDIO_Handle.RCA));
               ++retries;
               vTaskDelay(1);
            }

            if (SD_OK == retry_result && 0 != SDIO_Handle.RCA && retries < MAX_CMD3_RETRIES)
            {
               // In Standby state with a valid relative card address
               if (SD_OK == ESP_SDIO_SelectCard(SDIO_Handle.RCA))
               {
                  reset_result = true;
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

void ESP_SDIO_DMA_RxConfig(uint32_t * destBuffer, uint32_t bufferSize)
{
   __SDIO_ENABLE_IT(SDIO, SDIO_IT_DCRCFAIL | SDIO_IT_DTIMEOUT | SDIO_IT_DATAEND | SDIO_IT_RXOVERR | SDIO_IT_STBITERR);
   __SDIO_DMA_ENABLE();

   // Set DMA parameters
   DMA_Rx_Handle.Instance = SDIO_DMA_STREAM;
   DMA_Rx_Handle.Init.Channel = SDIO_DMA_CHANNEL;
   DMA_Rx_Handle.Init.Direction = DMA_PERIPH_TO_MEMORY;
   DMA_Rx_Handle.Init.FIFOMode = DMA_FIFOMODE_ENABLE;
   DMA_Rx_Handle.Init.FIFOThreshold = DMA_FIFO_THRESHOLD_FULL;
   DMA_Rx_Handle.Init.MemBurst = DMA_MBURST_INC4;
   DMA_Rx_Handle.Init.MemDataAlignment = DMA_MDATAALIGN_WORD;
   DMA_Rx_Handle.Init.MemInc = DMA_MINC_ENABLE;
   DMA_Rx_Handle.Init.Mode = DMA_NORMAL;
   DMA_Rx_Handle.Init.PeriphBurst = DMA_PBURST_INC4;
   DMA_Rx_Handle.Init.PeriphDataAlignment = DMA_PDATAALIGN_WORD;
   DMA_Rx_Handle.Init.PeriphInc = DMA_PINC_DISABLE;
   DMA_Rx_Handle.Init.Priority = DMA_PRIORITY_VERY_HIGH;
   DMA_Rx_Handle.Parent = SDIO_Handle;


   //DMA_Rx_Handle.Init. TODO

   HAL_DMA_DeInit(&DMA_Rx_Handle);
   HAL_DMA_Init(&DMA_Rx_Handle);


   HAL_DMA_Start_IT(&DMA_Rx_Handle, (uint32_t)&SDIO->FIFO, (uint32_t)destBuffer, bufferSize/4);



   /* From SD card example
    * DMA_ClearFlag(SD_SDIO_DMA_STREAM, SD_SDIO_DMA_FLAG_FEIF | SD_SDIO_DMA_FLAG_DMEIF | SD_SDIO_DMA_FLAG_TEIF | SD_SDIO_DMA_FLAG_HTIF | SD_SDIO_DMA_FLAG_TCIF);


   DMA_Cmd(SD_SDIO_DMA_STREAM, DISABLE);


   DMA_DeInit(SD_SDIO_DMA_STREAM);

   SDDMA_InitStructure.DMA_Channel = SD_SDIO_DMA_CHANNEL;
   SDDMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t) SDIO_FIFO_ADDRESS;
   SDDMA_InitStructure.DMA_Memory0BaseAddr = (uint32_t) BufferDST;
   SDDMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralToMemory;
   SDDMA_InitStructure.DMA_BufferSize = 1;
   SDDMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
   SDDMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
   SDDMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Word;
   SDDMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Word;
   SDDMA_InitStructure.DMA_Mode = DMA_Mode_Normal;
   SDDMA_InitStructure.DMA_Priority = DMA_Priority_VeryHigh;
   SDDMA_InitStructure.DMA_FIFOMode = DMA_FIFOMode_Enable;
   SDDMA_InitStructure.DMA_FIFOThreshold = DMA_FIFOThreshold_Full;
   SDDMA_InitStructure.DMA_MemoryBurst = DMA_MemoryBurst_INC4;
   SDDMA_InitStructure.DMA_PeripheralBurst = DMA_PeripheralBurst_INC4; */
   //DMA_Init (SD_SDIO_DMA_STREAM, &SDDMA_InitStructure);
   /*DMA_ITConfig (SD_SDIO_DMA_STREAM, DMA_IT_TC, ENABLE);
   DMA_FlowControllerConfig (SD_SDIO_DMA_STREAM, DMA_FlowCtrl_Peripheral);


   DMA_Cmd(SD_SDIO_DMA_STREAM, ENABLE); */

}

HAL_SD_ErrorTypedef ESP_SDIO_ReadBytes(uint32_t * destBuffer, uint32_t numBytes, uint32_t address)
{
   HAL_SD_ErrorTypedef sdio_err = SD_OK;

   // Set up DMA
   ESP_SDIO_DMA_RxConfig(destBuffer, numBytes);

   // Send command

   // taskYIELD() or vTaskDelay()

   // Wait for DMA to complete

   // Check SD status

   return sdio_err;
}

bool ESP_SDIO_GetCCCR(void)
{
   return (SD_OK == ESP_SDIO_ReadBytes(
         Card_Common_Control_Registers, sizeof(Card_Common_Control_Registers), 0));
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

HAL_SD_ErrorTypedef ESP_SDIO_SendRelativeAddress(uint16_t * new_rca)
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

HAL_SD_ErrorTypedef ESP_SDIO_SelectCard(uint16_t rca)
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
