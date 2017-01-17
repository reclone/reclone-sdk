/*! \file   esp_wifi_task.h
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

#ifndef __ESP_WIFI_TASK_H
#define __ESP_WIFI_TASK_H

#ifdef __cplusplus
extern "C" {
#endif

#include "FreeRTOS.h"

void ESP_WiFi_Init(const uint16_t usStackDepth, UBaseType_t uxPriority);


#ifdef __cplusplus
} //extern "C"
#endif

#endif
