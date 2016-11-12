
#include "FsmcTask.h"
#include "diag/Trace.h"
#include "stm32f4xx_hal.h"

typedef uint16_t memtest_t;

FsmcTask::FsmcTask()
{

}

void FsmcTask::Run()
{
   volatile uint16_t * short_addr = (volatile uint16_t *)0x60000000;
   volatile uint32_t * word_addr = (volatile uint32_t *)0x60000003;

   while (true)
   {
      //short_addr[0] = 0;
      //short_addr[0] = 0xDEAD; //(uint16_t)counter;
      //short_addr[1] = 0xBEEF;
      //short_addr[4] = (uint16_t)counter;
      //short_addr[6] = 0xB00B;
      //word_addr[0] = word_addr[0] ^ 0xDEADBEEF;
      //volatile uint16_t short0 = short_addr[4];

      //if (chr_data != (memtest_t)counter)
      {
         trace_printf("Fault number %u: %04x %04x %04x %04x %04x %04x %04x %04x %08x\n", counter,
               short_addr[7], short_addr[6], short_addr[5], short_addr[4],
               short_addr[3], short_addr[2], short_addr[1], short_addr[0],
               *word_addr);
//         trace_printf("Fault number %u: %04x %04x %04x %04x %08x\n", counter,
//               short_addr[4], short_addr[5], short_addr[6], short_addr[7],
//               *word_addr);
//         trace_printf("Fault number %u: %04x\n", counter, short_addr[6]);
      }
      //short_addr[2] = static_cast<uint16_t>(counter);
      counter++;
      //chr_addr++;
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
   gpio_init.Pull = GPIO_PULLUP;
   gpio_init.Alternate = GPIO_AF12_FSMC;
   gpio_init.Mode = GPIO_MODE_AF_PP;

   // GPIOB
   gpio_init.Pin = GPIO_PIN_7;
   HAL_GPIO_Init(GPIOB, &gpio_init);

   // GPIOD
   gpio_init.Pin = GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_3 | GPIO_PIN_4 |
                   GPIO_PIN_5 | GPIO_PIN_6 | GPIO_PIN_7 | GPIO_PIN_8 |
                   GPIO_PIN_9 | GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12 |
                   GPIO_PIN_13 | GPIO_PIN_14 | GPIO_PIN_15;
   HAL_GPIO_Init(GPIOD, &gpio_init);

   // GPIOE
   gpio_init.Pin = GPIO_PIN_0 | GPIO_PIN_1 | GPIO_PIN_3 | GPIO_PIN_4 |
                   GPIO_PIN_5 | GPIO_PIN_6 | GPIO_PIN_7 | GPIO_PIN_8 |
                   GPIO_PIN_9 | GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12 |
                   GPIO_PIN_13 | GPIO_PIN_14 | GPIO_PIN_15;
   HAL_GPIO_Init(GPIOE, &gpio_init);

   // Flexible Static Memory Controller configuration
   fsmc_init.AsynchronousWait = FSMC_ASYNCHRONOUS_WAIT_ENABLE;
   fsmc_init.BurstAccessMode = FSMC_BURST_ACCESS_MODE_DISABLE;
   fsmc_init.DataAddressMux = FSMC_DATA_ADDRESS_MUX_ENABLE;
   fsmc_init.ExtendedMode = FSMC_EXTENDED_MODE_DISABLE;
   fsmc_init.MemoryDataWidth = FSMC_NORSRAM_MEM_BUS_WIDTH_16;
   fsmc_init.MemoryType = FSMC_MEMORY_TYPE_NOR;
   fsmc_init.NSBank = FSMC_NORSRAM_BANK1;
   fsmc_init.WaitSignal = FSMC_WAIT_SIGNAL_DISABLE;
   fsmc_init.WaitSignalActive = FSMC_WAIT_TIMING_DURING_WS;
   fsmc_init.WaitSignalPolarity = FSMC_WAIT_SIGNAL_POLARITY_LOW;
   fsmc_init.WrapMode = FSMC_WRAP_MODE_DISABLE;
   fsmc_init.WriteBurst = FSMC_WRITE_BURST_DISABLE;
   fsmc_init.WriteOperation = FSMC_WRITE_OPERATION_ENABLE;
   FSMC_NORSRAM_DeInit(FSMC_NORSRAM_DEVICE, FSMC_NORSRAM_EXTENDED_DEVICE, FSMC_NORSRAM_BANK1);
   FSMC_NORSRAM_Init(FSMC_NORSRAM_DEVICE, &fsmc_init);

   // Flexible Static Memory Controller timing parameters
   fsmc_timing.AccessMode = FSMC_ACCESS_MODE_D;
   fsmc_timing.AddressHoldTime = 15;
   fsmc_timing.AddressSetupTime = 15;
   fsmc_timing.BusTurnAroundDuration = 1;
   fsmc_timing.CLKDivision = 3;
   fsmc_timing.DataLatency = 2; // 2 for synchronous PSRAM
   fsmc_timing.DataSetupTime = 15;

   FSMC_NORSRAM_Timing_Init(FSMC_NORSRAM_DEVICE, &fsmc_timing, FSMC_NORSRAM_BANK1);
   FSMC_NORSRAM_Extended_Timing_Init(FSMC_NORSRAM_EXTENDED_DEVICE, &fsmc_timing, FSMC_NORSRAM_BANK1, FSMC_EXTENDED_MODE_DISABLE);
   FSMC_NORSRAM_WriteOperation_Enable(FSMC_NORSRAM_DEVICE, FSMC_NORSRAM_BANK1);
   __FSMC_NORSRAM_ENABLE(FSMC_NORSRAM_DEVICE, FSMC_NORSRAM_BANK1);

   return true;
}
