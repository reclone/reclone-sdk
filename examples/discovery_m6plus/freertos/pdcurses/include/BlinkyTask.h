
#ifndef _BLINKYTASK_H
#define _BLINKYTASK_H

#include "AManagedTask.h"
#include "stm32f4xx.h"

class BlinkyTask : public AManagedTask
{
public:
   BlinkyTask(uint16_t port, uint16_t pin, portTickType nFlashRate);
   void Run();
   bool HardwareInit();
   virtual ~BlinkyTask() = default;
   bool IsOn() { return LEDOnState; }

private:

   uint16_t          LEDPort;
   uint16_t          LEDPin;
   portTickType      ToggleRate;
   bool              LEDOnState;

};


#endif

