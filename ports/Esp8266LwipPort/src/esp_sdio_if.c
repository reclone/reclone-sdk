/*! \file   esp_sdio_if.c
 *
 *  \brief  SDIO interface for connecting STM32F4 with ESP8089/ESP8266
 *
 *  Contains functions for initializing the STM32F4 SDIO peripheral
 *  via STM32F4Cube, sending SDIO commands, and interpreting the results.
 *
 *  \copyright Copyright 2017 Reclone Labs.  All rights reserved.
 *             This file is released under the BSD 2-Clause license:
 *             https://opensource.org/licenses/BSD-2-Clause
 */


#include "esp_sdio_if.h"
#include "FreeRTOS.h"
#include "task.h"

static const uint32_t CMD_TIMEOUT_LOOPS = 0x10000;
static GPIO_TypeDef * const RESET_PORT = GPIOB;
static const uint16_t RESET_PIN = GPIO_PIN_0;

static const uint32_t SDIO_STATIC_FLAGS =
      SDIO_FLAG_CCRCFAIL | SDIO_FLAG_DCRCFAIL | SDIO_FLAG_CTIMEOUT |
      SDIO_FLAG_DTIMEOUT | SDIO_FLAG_TXUNDERR | SDIO_FLAG_RXOVERR  |
      SDIO_FLAG_CMDREND  | SDIO_FLAG_CMDSENT  | SDIO_FLAG_DATAEND  |
      SDIO_FLAG_DBCKEND;


static uint16_t Relative_Card_Address;

void ESP_SDIO_ToggleReset(void);
HAL_SD_ErrorTypedef ESP_SDIO_GoIdleState(void);
HAL_SD_ErrorTypedef ESP_SDIO_IoSendOpCond(uint32_t arg, bool * out_iordy);
HAL_SD_ErrorTypedef ESP_SDIO_SendRelativeAddress(uint16_t * new_rca);
HAL_SD_ErrorTypedef ESP_SDIO_SelectCard(uint16_t rca);


void ESP_SDIO_InitHardware(void)
{
   GPIO_InitTypeDef gpio_init;
   SDIO_InitTypeDef sdio_init;

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
   sdio_init.BusWide = SDIO_BUS_WIDE_1B;
   sdio_init.ClockBypass = SDIO_CLOCK_BYPASS_DISABLE;
   sdio_init.ClockDiv = SDIO_INIT_CLK_DIV;
   sdio_init.ClockEdge = SDIO_CLOCK_EDGE_RISING;
   sdio_init.ClockPowerSave = SDIO_CLOCK_POWER_SAVE_DISABLE;
   sdio_init.HardwareFlowControl = SDIO_HARDWARE_FLOW_CONTROL_DISABLE;
   SDIO_Init(SDIO, sdio_init);

   __HAL_RCC_SDIO_CLK_ENABLE();

   // Turn on SDIO
   SDIO_PowerState_ON(SDIO);

   // Enable SDIO clock
   __SDIO_ENABLE();
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
               retry_result = ESP_SDIO_SendRelativeAddress(&Relative_Card_Address);
               ++retries;
               vTaskDelay(1);
            }

            if (SD_OK == retry_result && 0 != Relative_Card_Address && retries < MAX_CMD3_RETRIES)
            {
               // In Standby state with a valid relative card address
               if (SD_OK == ESP_SDIO_SelectCard(Relative_Card_Address))
               {
                  reset_result = true;
               }

            }
         }
      }
   }

   return reset_result;
}



HAL_SD_ErrorTypedef ESP_SDIO_GoIdleState(void)
{
   SDIO_CmdInitTypeDef cmd;
   HAL_SD_ErrorTypedef sdio_err = SD_OK;
   uint32_t timer = 0;

   cmd.Argument = 0;
   cmd.CmdIndex = SD_CMD_GO_IDLE_STATE;
   cmd.Response = SDIO_RESPONSE_NO;
   cmd.WaitForInterrupt = SDIO_WAIT_NO;
   cmd.CPSM = SDIO_CPSM_ENABLE;
   SDIO_SendCommand(SDIO, &cmd);

   while ((timer < CMD_TIMEOUT_LOOPS) && (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDSENT) == RESET))
   {
      __NOP();
      ++timer;
   }

   if (timer >= CMD_TIMEOUT_LOOPS)
   {
      sdio_err = SD_CMD_RSP_TIMEOUT;
   }
   else
   {
      __SDIO_CLEAR_FLAG(SDIO, SDIO_STATIC_FLAGS);
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_IoSendOpCond(uint32_t arg, bool * out_iordy)
{
   SDIO_CmdInitTypeDef cmd;
   HAL_SD_ErrorTypedef sdio_err = SD_OK;
   uint32_t timer = 0;

   cmd.Argument = arg;
   cmd.CmdIndex = SD_CMD_SDIO_SEN_OP_COND;
   cmd.Response = SDIO_RESPONSE_SHORT;
   cmd.WaitForInterrupt = SDIO_WAIT_NO;
   cmd.CPSM = SDIO_CPSM_ENABLE;
   SDIO_SendCommand(SDIO, &cmd);

   while ((timer < CMD_TIMEOUT_LOOPS) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CCRCFAIL) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDREND) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == RESET))
   {
      __NOP();
      ++timer;
   }

   if (timer >= CMD_TIMEOUT_LOOPS || __SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == SET)
   {
      sdio_err = SD_CMD_RSP_TIMEOUT;
   }
   else
   {
      __SDIO_CLEAR_FLAG(SDIO, SDIO_STATIC_FLAGS);

      *out_iordy = (((SDIO_GetResponse(SDIO_RESP1) >> 31) & 1) != 0);
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_SendRelativeAddress(uint16_t * new_rca)
{
   SDIO_CmdInitTypeDef cmd;
   HAL_SD_ErrorTypedef sdio_err = SD_OK;
   uint32_t timer = 0;

   cmd.Argument = 0;
   cmd.CmdIndex = SD_CMD_SET_REL_ADDR;
   cmd.Response = SDIO_RESPONSE_SHORT;
   cmd.WaitForInterrupt = SDIO_WAIT_NO;
   cmd.CPSM = SDIO_CPSM_ENABLE;
   SDIO_SendCommand(SDIO, &cmd);

   while ((timer < CMD_TIMEOUT_LOOPS) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CCRCFAIL) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDREND) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == RESET))
   {
      __NOP();
      ++timer;
   }

   if (timer >= CMD_TIMEOUT_LOOPS || __SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == SET)
   {
      sdio_err = SD_CMD_RSP_TIMEOUT;
   }
   else
   {
      __SDIO_CLEAR_FLAG(SDIO, SDIO_STATIC_FLAGS);
      *new_rca = (SDIO_GetResponse(SDIO_RESP1) >> 16) & 0xFFFF;
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef ESP_SDIO_SelectCard(uint16_t rca)
{
   SDIO_CmdInitTypeDef cmd;
   HAL_SD_ErrorTypedef sdio_err = SD_OK;
   uint32_t timer = 0;

   cmd.Argument = ((uint32_t)rca) << 16;
   cmd.CmdIndex = SD_CMD_SEL_DESEL_CARD;
   cmd.Response = SDIO_RESPONSE_SHORT;
   cmd.WaitForInterrupt = SDIO_WAIT_NO;
   cmd.CPSM = SDIO_CPSM_ENABLE;
   SDIO_SendCommand(SDIO, &cmd);

   while ((timer < CMD_TIMEOUT_LOOPS) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CCRCFAIL) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDREND) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == RESET))
   {
      __NOP();
      ++timer;
   }

   if (timer >= CMD_TIMEOUT_LOOPS || __SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == SET)
   {
      sdio_err = SD_CMD_RSP_TIMEOUT;
   }
   else
   {
      __SDIO_CLEAR_FLAG(SDIO, SDIO_STATIC_FLAGS);

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
