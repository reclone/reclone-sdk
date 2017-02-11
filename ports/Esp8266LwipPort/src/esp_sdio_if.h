/*! \file   esp_sdio_if.h
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


#ifndef __ESP_SDIO_IF_H
#define __ESP_SDIO_IF_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdbool.h>
#include "stm32f4xx.h"
#include "esp_sdio_struct.h"


void ESP_SDIO_InitHardware(void);
bool ESP_SDIO_ResetToCmdState(void);
bool ESP_SDIO_GetCCCR(CCCR_Registers_T * cccr_reg);


#ifdef __cplusplus
} //extern "C"
#endif

#endif

