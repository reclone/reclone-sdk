
#include <stdio.h>
#include "diag/Trace.h"
#include "stm32f4xx_hal.h"
#include "CFreeRTOS.h"
#include "BlinkyTask.h"

int main(int argc, char* argv[])
{
  // Send a greeting to the trace device (skipped on Release).
  trace_puts("Hello ARM World!");

  // At this stage the system clock should have already been configured
  // at high speed.
  trace_printf("System clock: %uHz\n", SystemCoreClock);


  BlinkyTask * blinky = new BlinkyTask(3, 12, 500);
  blinky->Create("Blinky", configMINIMAL_STACK_SIZE, 2);

  CFreeRTOS::InitHardwareForManagedTasks();

  CFreeRTOS::StartScheduler();

  // Infinite loop
  while (1) { }

  // If that stops, well then... I guess we're screwed
  return 0;
}

extern "C" void vApplicationMallocFailedHook( void )
{
   /* vApplicationMallocFailedHook() will only be called if
   configUSE_MALLOC_FAILED_HOOK is set to 1 in FreeRTOSConfig.h.  It is a hook
   function that will get called if a call to pvPortMalloc() fails.
   pvPortMalloc() is called internally by the kernel whenever a task, queue,
   timer or semaphore is created.  It is also called by various parts of the
   demo application.  If heap_1.c or heap_2.c are used, then the size of the
   heap available to pvPortMalloc() is defined by configTOTAL_HEAP_SIZE in
   FreeRTOSConfig.h, and the xPortGetFreeHeapSize() API function can be used
   to query the size of free heap space that remains (although it does not
   provide information on how the remaining heap might be fragmented). */
   taskDISABLE_INTERRUPTS();
   for( ;; );
}

extern "C" void vApplicationStackOverflowHook( xTaskHandle pxTask, signed char *pcTaskName )
{
   ( void ) pcTaskName;
   ( void ) pxTask;

   /* Run time stack overflow checking is performed if
   configCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
   function is called if a stack overflow is detected. */
   taskDISABLE_INTERRUPTS();
   for( ;; );
}

extern "C" void vApplicationTickHook()
{

}

extern "C" void vApplicationIdleHook()
{

}
