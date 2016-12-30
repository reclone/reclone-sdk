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

};


#endif
