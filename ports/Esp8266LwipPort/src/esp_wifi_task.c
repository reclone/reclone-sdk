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

static void ESP_WiFi_Task(void *);

void ESP_WiFi_Init(const uint16_t usStackDepth, UBaseType_t uxPriority)
{
   BaseType_t xReturned;
   TaskHandle_t xHandle = NULL;

   // Create the task
   (void)xTaskCreate(ESP_WiFi_Task, "ESP_WiFi_Task", usStackDepth, NULL, uxPriority, &xHandle);

   (void)xReturned;  //Unused
   (void)xHandle;    //Unused
}

static void ESP_WiFi_Task(void * pvParameters)
{
   (void)pvParameters;  //Unused

   while (1)
   {
      vTaskDelay(1000);
   }
}
