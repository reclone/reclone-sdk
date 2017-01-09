#ifndef _SDIOWIFITASK_H
#define _SDIOWIFITASK_H

#include "AManagedTask.h"
#include "stm32f4xx.h"

class SdioWifiTask : public AManagedTask
{
public:
   SdioWifiTask();
   void Run();
   bool HardwareInit();
   virtual ~SdioWifiTask() = default;

private:
   static const uint32_t SDIO_CMD0TIMEOUT = 0x10000;
   static const uint32_t SDIO_STATIC_FLAGS =
         ((uint32_t)(SDIO_FLAG_CCRCFAIL | SDIO_FLAG_DCRCFAIL | SDIO_FLAG_CTIMEOUT |\
         SDIO_FLAG_DTIMEOUT | SDIO_FLAG_TXUNDERR | SDIO_FLAG_RXOVERR  |\
         SDIO_FLAG_CMDREND  | SDIO_FLAG_CMDSENT  | SDIO_FLAG_DATAEND  |\
         SDIO_FLAG_DBCKEND));

   HAL_SD_ErrorTypedef Cmd0Error();
   HAL_SD_ErrorTypedef Cmd5Resp4Error();
   HAL_SD_ErrorTypedef Cmd3Resp6Error(uint16_t & rca);
   HAL_SD_ErrorTypedef Cmd7Resp1bError();
};


#endif
