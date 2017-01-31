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

#include "stm32f4xx.h"
#include <stdbool.h>

   typedef union CCCR_Registers_U
   {
      uint32_t Word[0x14 / 4];
      struct Reg_S
      {
         uint32_t CCCR_Rev : 4;
         uint32_t SDIO_Rev : 4;
         uint32_t SD_Rev : 4;
         uint32_t rfu1 : 4;
         bool rfu2 : 1;
         bool IOE1 : 1;
         bool IOE2 : 1;
         bool IOE3 : 1;
         bool IOE4 : 1;
         bool IOE5 : 1;
         bool IOE6 : 1;
         bool IOE7 : 1;
         bool rfu3 : 1;
         bool IOR1 : 1;
         bool IOR2 : 1;
         bool IOR3 : 1;
         bool IOR4 : 1;
         bool IOR5 : 1;
         bool IOR6 : 1;
         bool IOR7 : 1;
         bool rfu4 : 1;
         bool IEN1 : 1;
         bool IEN2 : 1;
         bool IEN3 : 1;
         bool IEN4 : 1;
         bool IEN5 : 1;
         bool IEN6 : 1;
         bool IEN7 : 1;
         bool rfu5 : 1;
         bool INT1 : 1;
         bool INT2 : 1;
         bool INT3 : 1;
         bool INT4 : 1;
         bool INT5 : 1;
         bool INT6 : 1;
         bool INT7 : 1;
         bool AS0 : 1;
         bool AS1 : 1;
         bool AS2 : 1;
         bool RES : 1;
         uint32_t rfu6 : 4;
         uint32_t Bus_Width : 2;
         uint32_t rfu7 : 3;
         bool ESCI : 1;
         bool SCSI : 1;
         bool CD_Disable : 1;
         bool SDC : 1;
         bool SMB : 1;
         bool SRW : 1;
         bool SBS : 1;
         bool S4MI : 1;
         bool E4MI : 1;
         bool LSC : 1;
         bool FourBLS : 1;
         uint32_t CIS_Pointer : 24;
      } Reg;
   } CCCR_Registers_T;


void ESP_SDIO_InitHardware(void);
bool ESP_SDIO_ResetToCmdState(void);
bool ESP_SDIO_GetCCCR(CCCR_Registers_T * cccr_reg);




#ifdef __cplusplus
} //extern "C"
#endif

#endif

