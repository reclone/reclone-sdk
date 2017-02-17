/*! \file   esp_sdio_struct.h
 *
 *  \brief  SDIO structs for accessing registers
 *
 *  \copyright Copyright 2017 Reclone Labs.  All rights reserved.
 *             This file is open source under the BSD 2-Clause license:
 *             https://opensource.org/licenses/BSD-2-Clause
 */


#ifndef __ESP_SDIO_STRUCT_H
#define __ESP_SDIO_STRUCT_H

typedef union CCCR_Registers_U
{
   uint32_t Word[0x14 / 4];
   struct
   {
      uint32_t CccrRev : 4;
      uint32_t SdioRev : 4;
      uint32_t SdRev : 4;
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
      uint32_t BusWidth : 2;
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
      uint32_t CisPointer : 24;
      bool BS : 1;
      bool BR : 1;
      uint32_t rfu8 : 6;
      uint32_t FS : 4;
      uint32_t rfu9 : 3;
      bool DF : 1;
      bool EXM : 1;
      bool EX1 : 1;
      bool EX2 : 1;
      bool EX3 : 1;
      bool EX4 : 1;
      bool EX5 : 1;
      bool EX6 : 1;
      bool EX7 : 1;
      bool RXM : 1;
      bool RX1 : 1;
      bool RX2 : 1;
      bool RX3 : 1;
      bool RX4 : 1;
      bool RX5 : 1;
      bool RX6 : 1;
      bool RX7 : 1;
      uint32_t Fn0BlockSize : 16;
      bool SMPC : 1;
      bool EMPC : 1;
      uint32_t rfu10 : 6;
      bool SHS : 1;
      bool EHS : 1;
      uint32_t rfu11 : 6;
   } Reg;
} CCCR_Registers_T;

typedef union FBR_Registers_U
{
   uint32_t Word[0x14 / 4];
   struct
   {
      uint32_t StdIfaceCode : 4;
      uint32_t rfu1 : 2;
      bool SupportsCSA : 1;
      bool EnableCSA : 1;
      uint32_t ExtStdIfaceCode : 8;
      bool SPS : 1;
      bool EPS : 1;
      uint32_t rfu2 : 22;
      uint32_t rfu3 : 32;
      uint32_t PointerCIS : 24;
      uint32_t PointerCSA : 24;
      uint32_t DataAccessWindowCSA : 8;
      uint32_t IOBlockSize : 16;
   } Reg;
} FBR_Registers_T;
#endif
