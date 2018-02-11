
#include <stdio.h>
#include "diag/Trace.h"
#include "stm32f4xx_hal.h"
#include "CFreeRTOS.h"
#include "UsbHostTask.h"

int main(int, char*)
{
  // Send a greeting to the trace device (skipped on Release).
  trace_puts("Hello ARM World!");

  // At this stage the system clock should have already been configured
  // at high speed.
  trace_printf("System clock: %uHz\n", SystemCoreClock);


  UsbHostTask * usbhost = new UsbHostTask();
  usbhost->Create("UsbHost", 2000, 2);

  CFreeRTOS::InitHardwareForManagedTasks();

  CFreeRTOS::StartScheduler();

  // Infinite loop
  while (1) { }

  // If that stops, well then... I guess we're screwed
  return 0;
}

