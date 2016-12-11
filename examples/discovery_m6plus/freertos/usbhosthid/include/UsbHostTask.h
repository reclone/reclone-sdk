
#ifndef _USBHOSTTASK_H
#define _USBHOSTTASK_H

#include "AManagedTask.h"
#include "stm32f4xx.h"
#include "usbh_core.h"

class UsbHostTask : public AManagedTask
{
public:
   UsbHostTask();
   void Run();
   bool HardwareInit();
   virtual ~UsbHostTask() = default;

private:
   USBH_HandleTypeDef hUSB_Host; /* USB Host handle */

};


#endif

