
#include "FsmcTask.h"

FsmcTask::FsmcTask()
{

}

void FsmcTask::Run()
{
   while (true)
   {
      Delay(1000);
   }

}


bool FsmcTask::HardwareInit()
{


   return true;
}
