
#ifndef _FSMCTASK_H
#define _FSMCTASK_H

#include "AManagedTask.h"
#include "stm32f4xx.h"

class FsmcTask : public AManagedTask
{
public:
   FsmcTask();
   void Run();
   bool HardwareInit();
   virtual ~FsmcTask() = default;

private:
   unsigned int counter = 0;

};


#endif

