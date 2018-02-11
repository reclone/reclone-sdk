
#include "BlinkyTask.h"

#define BLINK_GPIOx(_N)                 ((GPIO_TypeDef *)(GPIOA_BASE + (GPIOB_BASE-GPIOA_BASE)*(_N)))
#define BLINK_PIN_MASK(_N)              (1 << (_N))
#define BLINK_RCC_MASKx(_N)             (RCC_AHB1ENR_GPIOAEN << (_N))

BlinkyTask::BlinkyTask(uint16_t port, uint16_t pin, portTickType flash_rate)
{
   LEDPort = port;
   LEDPin = pin;
   ToggleRate = flash_rate;
   LEDOnState = false;
}

void BlinkyTask::Run()
{
   portTickType last_wake;
   last_wake = GetTickCount();

   while (true)
   {
      LEDOnState = !LEDOnState;
      HAL_GPIO_WritePin(BLINK_GPIOx(LEDPort), BLINK_PIN_MASK(LEDPin), LEDOnState ? GPIO_PIN_SET : GPIO_PIN_RESET);
      DelayUntil(&last_wake, ToggleRate);
   }

}


bool BlinkyTask::HardwareInit()
{
   GPIO_InitTypeDef init;

   // Enable GPIO Peripheral clock
   RCC->AHB1ENR |= BLINK_RCC_MASKx(LEDPort);

   init.Pin = BLINK_PIN_MASK(LEDPin);
   init.Mode = GPIO_MODE_OUTPUT_PP;
   init.Pull = GPIO_PULLUP;
   init.Speed = GPIO_SPEED_FAST;

   HAL_GPIO_Init(BLINK_GPIOx(LEDPort), &init);

   return true;
}
