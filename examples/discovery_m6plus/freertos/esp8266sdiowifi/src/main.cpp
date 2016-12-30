
#include <stdio.h>
#include "diag/Trace.h"
#include "stm32f4xx_hal.h"
#include "CFreeRTOS.h"
#include "BlinkyTask.h"
#include "SdioWifiTask.h"

int main(int argc, char* argv[])
{
  // Send a greeting to the trace device (skipped on Release).
  trace_puts("Hello ARM World!");

  // At this stage the system clock should have already been configured
  // at high speed.
  trace_printf("System clock: %uHz\n", SystemCoreClock);


  BlinkyTask * blinky = new BlinkyTask(3, 12, 500);
  blinky->Create("Blinky", configMINIMAL_STACK_SIZE, 2);
  SdioWifiTask * wifi = new SdioWifiTask();
  wifi->Create("SdioWifi", 2000, 3);


  CFreeRTOS::InitHardwareForManagedTasks();

  CFreeRTOS::StartScheduler();

  // Infinite loop
  while (1) { }

  // If that stops, well then... I guess we're screwed
  return 0;
}

