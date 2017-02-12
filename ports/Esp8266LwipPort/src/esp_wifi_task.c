/*! \file   esp_wifi_task.c
 *
 *  \brief  RTOS task enabling SDIO WiFi communication with ESP8266.
 *
 *  The ESP_WiFi_Task is a FreeRTOS task that handles initialization and
 *  periodic processing required to support SDIO WiFi communication
 *  between an STM32F4 and an ESP8266 ESP-12E/F module.
 *
 *  \copyright Copyright 2017 Reclone Labs.  All rights reserved.
 *             This file is released under the BSD 2-Clause license:
 *             https://opensource.org/licenses/BSD-2-Clause
 */

#include "FreeRTOS.h"
#include "task.h"
#include "esp_wifi_task.h"
#include "esp_sdio_if.h"

static TaskHandle_t ESP_WiFi_Task_Handle = NULL;
static CCCR_Registers_T CCCR;
static FBR_Registers_T FBR1;


static void ESP_WiFi_Task(void *);

void ESP_WiFi_Init(const uint16_t usStackDepth, UBaseType_t uxPriority)
{
   // Initialize SDIO peripheral
   ESP_SDIO_InitHardware();

   // Create the RTOS task
   (void)xTaskCreate(ESP_WiFi_Task, "ESP_WiFi_Task", usStackDepth, NULL, uxPriority, &ESP_WiFi_Task_Handle);

}

static void ESP_WiFi_Task(void * pvParameters)
{
   (void)pvParameters;  //Unused

   if (ESP_SDIO_ResetToCmdState())
   {
      vTaskDelay(1);
      if (ESP_SDIO_GetCCCR(&CCCR))
      {
         vTaskDelay(1);
         if (ESP_SDIO_GetFBR(&FBR1, 1))
         {
            // GOOD
            vTaskDelay(1);
         }
         else
         {
            //FAIL
            vTaskDelay(1);
         }
      }
      else
      {
         //FAIL
         vTaskDelay(1);
      }

   }

   while (1)
   {
      vTaskDelay(1000);
   }
}
