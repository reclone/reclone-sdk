
#include "FsmcTask.h"
#include "diag/Trace.h"
#include "stm32f4xx_hal.h"

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
   FSMC_NORSRAM_InitTypeDef   fsmc_init;
   FSMC_NORSRAM_TimingTypeDef fsmc_timing;

   GPIO_InitTypeDef gpio_init;

   // Enable GPIO and peripheral clocks
   __HAL_RCC_GPIOB_CLK_ENABLE();
   __HAL_RCC_GPIOD_CLK_ENABLE();
   __HAL_RCC_GPIOE_CLK_ENABLE();
   __HAL_RCC_FSMC_CLK_ENABLE();

   // Set the following pins for high speed, alternate function push/pull, FSMC
   gpio_init.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
   gpio_init.Pull = GPIO_NOPULL;
   gpio_init.Alternate = GPIO_AF12_FSMC;
   gpio_init.Mode = GPIO_MODE_AF_PP;

   // GPIOB
   gpio_init.Pin = GPIO_PIN_7;
   HAL_GPIO_Init(GPIOB, &gpio_init);

   // GPIOD
   gpio_init.Pin = GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_4 | GPIO_PIN_5 |
                   GPIO_PIN_6 | GPIO_PIN_7 | GPIO_PIN_8 | GPIO_PIN_9 |
                   GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12 | GPIO_PIN_13 |
                   GPIO_PIN_14 | GPIO_PIN_15;
   HAL_GPIO_Init(GPIOD, &gpio_init);

   // GPIOE
   gpio_init.Pin = GPIO_PIN_3 | GPIO_PIN_4 | GPIO_PIN_5 | GPIO_PIN_6 |
                   GPIO_PIN_7 | GPIO_PIN_8 | GPIO_PIN_9 | GPIO_PIN_10 |
                   GPIO_PIN_11 | GPIO_PIN_12 | GPIO_PIN_13 | GPIO_PIN_14 |
                   GPIO_PIN_15;
   HAL_GPIO_Init(GPIOE, &gpio_init);

   // Flexible Static Memory Controller configuration
   fsmc_init.AsynchronousWait = FSMC_ASYNCHRONOUS_WAIT_DISABLE;
   fsmc_init.BurstAccessMode = FSMC_BURST_ACCESS_MODE_DISABLE;
   fsmc_init.DataAddressMux = FSMC_DATA_ADDRESS_MUX_ENABLE;
   fsmc_init.ExtendedMode = FSMC_EXTENDED_MODE_DISABLE;
   fsmc_init.MemoryDataWidth = FSMC_NORSRAM_MEM_BUS_WIDTH_16;
   fsmc_init.MemoryType = FSMC_MEMORY_TYPE_PSRAM;
   fsmc_init.NSBank = FSMC_NORSRAM_BANK1;
   fsmc_init.WaitSignal = FSMC_WAIT_SIGNAL_DISABLE;
   fsmc_init.WaitSignalActive = FSMC_WAIT_TIMING_DURING_WS;
   fsmc_init.WaitSignalPolarity = FSMC_WAIT_SIGNAL_POLARITY_LOW;
   fsmc_init.WrapMode = FSMC_WRAP_MODE_DISABLE;
   fsmc_init.WriteBurst = FSMC_WRITE_BURST_DISABLE;
   fsmc_init.WriteOperation = FSMC_WRITE_OPERATION_ENABLE;
   FSMC_NORSRAM_Init(FSMC_NORSRAM_DEVICE, &fsmc_init);

   // Flexible Static Memory Controller timing parameters
   fsmc_timing.AccessMode = FSMC_ACCESS_MODE_A; // don't care
   fsmc_timing.AddressHoldTime = 8;
   fsmc_timing.AddressSetupTime = 8;
   fsmc_timing.BusTurnAroundDuration = 0;
   fsmc_timing.CLKDivision = 2; // don't care
   fsmc_timing.DataLatency = 0; // don't care
   FSMC_NORSRAM_Timing_Init(FSMC_NORSRAM_DEVICE, &fsmc_timing, 0);

   return true;
}
