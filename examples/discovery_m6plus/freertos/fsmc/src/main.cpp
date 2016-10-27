
#include <stdio.h>
#include "diag/Trace.h"
#include "stm32f4xx_hal.h"
#include "CFreeRTOS.h"
//#include "BlinkyTask.h"
#include "FsmcTask.h"

int main(int argc, char* argv[])
{
   // Send a greeting to the trace device (skipped on Release).
   trace_puts("Hello ARM World!");

   // At this stage the system clock should have already been configured
   // at high speed.
   trace_printf("System clock: %uHz\n", SystemCoreClock);

//   BlinkyTask * greenBlinky = new BlinkyTask(3, 12, 500);
//   BlinkyTask * blueBlinky = new BlinkyTask(3, 15, 250);
//   BlinkyTask * orangeBlinky = new BlinkyTask(3, 13, 125);
//   BlinkyTask * redBlinky = new BlinkyTask(3, 14, 1000);
//   BlinkyTask * testBlinky = new BlinkyTask(1, 7, 333);
   FsmcTask * testFsmc = new FsmcTask();
//
//   greenBlinky->Create("GreenBlinky", configMINIMAL_STACK_SIZE, 2);
//   blueBlinky->Create("BlueBlinky", configMINIMAL_STACK_SIZE, 2);
//   orangeBlinky->Create("OrangeBlinky", configMINIMAL_STACK_SIZE, 2);
//   redBlinky->Create("RedBlinky", configMINIMAL_STACK_SIZE, 2);
//   testBlinky->Create("TestBlinky", configMINIMAL_STACK_SIZE, 2);
   testFsmc->Create("TestFSMC", configMINIMAL_STACK_SIZE, 2);

   CFreeRTOS::InitHardwareForManagedTasks();

   CFreeRTOS::StartScheduler();

   // Infinite loop
   while (true)
   {
   }

   // If that stops, well then... I guess we're screwed
   return 0;
}

