
#include "FsmcTask.h"
#include "diag/Trace.h"

FsmcTask::FsmcTask()
{

}

void FsmcTask::Run()
{
   while (true)
   {
      trace_printf("Read number: %u\n", counter++);
      Delay(1000);
   }

}


bool FsmcTask::HardwareInit()
{


   return true;
}
