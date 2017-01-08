
/*
 *
 *    esp_sdio_init - called when module starts
 *    sdio_register_driver - registers device list with functions as an SDIO driver:
 *       esp_sdio_devices, esp_sdio_probe, esp_sdio_remove, esp_sdio_suspend, esp_sdio_resume
 *    esp_sdio_probe - found a device matching esp_sdio_devices
 *    esp_pub_init_all
 *    esp_download_fw
 *
 *
 * ESP8089 driver contains a state machine for the SIP (Serial Interconnector Protocol)
 * which has states:
 *    SIP_INIT
 *       Initial state, returned to if sip_detach() is called
 *    SIP_PREPARE_BOOT
 *       Entered when sip_attach() is successful, or esp_pub_init_all() is successful after initial init
 *    SIP_BOOT
 *       Entered when sif_enable_irq() is successful (SDIO IRQ is installed)
 *    SIP_SEND_INIT
 *       Entered when received control packet with event SIP_EVT_TARGET_ON
 *       sip_send_chip_init() is callws which
 *    SIP_WAIT_BOOTUP
 *       Entered after chip init data is sent with sip_send_chip_init()
 *    SIP_RUN
 *       Entered when bootup is complete as detected by sip_poll_bootup_event()
 *    SIP_SUSPEND
 *    SIP_STOP
 *
 * Operations that this task needs to perform:
 *
 * 1. Reset SDIO card
 *
 *    Toggles the CH_PD/EN pin LOW for 200ms.
 *
 * 2. Send init data
 *
 *    ESP_INIT_DATA is the defaults.  This needs to be modified with up to MAX_FIX_ATTR_NUM
 *    items, which are configuration attributes that modify bytes in ESP_INIT_DATA.
 *    Send SDIO command CMD_INIT with data ESP_INIT_DATA.
 *
 *
 *
 *
 *
 */



#include "SdioWifiTask.h"
#include "diag/Trace.h"



SdioWifiTask::SdioWifiTask()
{

}

void SdioWifiTask::Run()
{
   SDIO_CmdInitTypeDef cmd;
   HAL_SD_ErrorTypedef sdio_err;

   // Reset the WiFi card by sending a low enable pulse for 500ms
   HAL_GPIO_WritePin(GPIOB, GPIO_PIN_15, GPIO_PIN_RESET);
   Delay(200);
   HAL_GPIO_WritePin(GPIOB, GPIO_PIN_15, GPIO_PIN_SET);
   Delay(200);

   cmd.Argument = 0;
   cmd.CmdIndex = SD_CMD_GO_IDLE_STATE;
   cmd.Response = SDIO_RESPONSE_NO;
   cmd.WaitForInterrupt = SDIO_WAIT_NO;
   cmd.CPSM = SDIO_CPSM_ENABLE;
   SDIO_SendCommand(SDIO, &cmd);
   sdio_err = Cmd0Error();
   if (sdio_err != SD_OK)
   {
      trace_puts("SD_CMD_GO_IDLE_STATE timeout!");
   }
   else
   {
      trace_puts("SD_CMD_GO_IDLE_STATE sent!");

      // Send CMD5 with argument 0 to get IO OCR
      cmd.Argument = 0;
      cmd.CmdIndex = SD_CMD_SDIO_SEN_OP_COND;
      cmd.Response = SDIO_RESPONSE_SHORT;
      cmd.WaitForInterrupt = SDIO_WAIT_NO;
      cmd.CPSM = SDIO_CPSM_ENABLE;
      SDIO_SendCommand(SDIO, &cmd);
      sdio_err = Cmd5Resp4Error();
      if (sdio_err != SD_OK)
      {
         trace_puts("SD_CMD_SDIO_SEN_OP_COND failed!");
      }
      else
      {
         uint32_t resp4 = SDIO_GetResponse(SDIO_RESP1);
         trace_printf("SD_CMD_SDIO_SEN_OP_COND succeeded! Response: %8x, NumIO: %u, Mem: %u\n", resp4, (resp4 >> 28) & 7, (resp4 >> 27) & 1);

         // Send CMD5 with argument 0x10000 to say that we support 3.2V-3.3V
         cmd.Argument = 0x10000;
         cmd.CmdIndex = SD_CMD_SDIO_SEN_OP_COND;
         cmd.Response = SDIO_RESPONSE_SHORT;
         cmd.WaitForInterrupt = SDIO_WAIT_NO;
         cmd.CPSM = SDIO_CPSM_ENABLE;
         SDIO_SendCommand(SDIO, &cmd);
         sdio_err = Cmd5Resp4Error();

         if (sdio_err != SD_OK)
         {
            trace_puts("SD_CMD_SDIO_SEN_OP_COND failed!");
         }
         else
         {
            resp4 = SDIO_GetResponse(SDIO_RESP1);
            trace_printf("SD_CMD_SDIO_SEN_OP_COND succeeded for 3.2-3.3V! Response: %8x, Ready: \n", resp4);


         }
      }
   }

   while (true)
   {
      Delay(100);
   }

}


bool SdioWifiTask::HardwareInit()
{
   GPIO_InitTypeDef gpio_init;
   SDIO_InitTypeDef sdio_init;

   // Enable GPIO clocks
   __HAL_RCC_GPIOB_CLK_ENABLE();
   __HAL_RCC_GPIOC_CLK_ENABLE();
   __HAL_RCC_GPIOD_CLK_ENABLE();

   // CH_PD pin that gets toggled to reset the chip
   gpio_init.Speed = GPIO_SPEED_FREQ_LOW;
   gpio_init.Pull = GPIO_PULLUP;
   gpio_init.Mode = GPIO_MODE_OUTPUT_PP;
   gpio_init.Pin = GPIO_PIN_15;
   HAL_GPIO_Init(GPIOB, &gpio_init);

   // Set the following pins for high speed, pull up, alternate function push/pull, SDIO
   gpio_init.Speed = GPIO_SPEED_FREQ_VERY_HIGH;
   gpio_init.Pull = GPIO_PULLUP;
   gpio_init.Alternate = GPIO_AF12_SDIO;
   gpio_init.Mode = GPIO_MODE_AF_PP;

   // SDIO Data 0-3 and SDIO Clock pins
   gpio_init.Pin = GPIO_PIN_8 | GPIO_PIN_9 | GPIO_PIN_10 | GPIO_PIN_11 | GPIO_PIN_12;
   HAL_GPIO_Init(GPIOC, &gpio_init);

   // SDIO Command pin
   gpio_init.Pin = GPIO_PIN_2;
   HAL_GPIO_Init(GPIOD, &gpio_init);

   // SDIO peripheral
   sdio_init.BusWide = SDIO_BUS_WIDE_1B;
   sdio_init.ClockBypass = SDIO_CLOCK_BYPASS_DISABLE;
   sdio_init.ClockDiv = SDIO_INIT_CLK_DIV;
   sdio_init.ClockEdge = SDIO_CLOCK_EDGE_RISING;
   sdio_init.ClockPowerSave = SDIO_CLOCK_POWER_SAVE_DISABLE;
   sdio_init.HardwareFlowControl = SDIO_HARDWARE_FLOW_CONTROL_DISABLE;
   SDIO_Init(SDIO, sdio_init);

   __HAL_RCC_SDIO_CLK_ENABLE();

   // Turn on SDIO
   SDIO_PowerState_ON(SDIO);

   // Enable SDIO clock
   __SDIO_ENABLE();

   return true;
}

HAL_SD_ErrorTypedef SdioWifiTask::Cmd0Error()
{
   HAL_SD_ErrorTypedef sdio_err = SD_OK;
   uint32_t timer = 0;

   while ((timer < SDIO_CMD0TIMEOUT) && (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDSENT) == RESET))
   {
      __NOP();
      ++timer;
   }

   if (timer >= SDIO_CMD0TIMEOUT)
   {
      sdio_err = SD_CMD_RSP_TIMEOUT;
   }
   else
   {
      __SDIO_CLEAR_FLAG(SDIO, SDIO_STATIC_FLAGS);
   }

   return sdio_err;
}

HAL_SD_ErrorTypedef SdioWifiTask::Cmd5Resp4Error()
{
   HAL_SD_ErrorTypedef sdio_err = SD_OK;
   uint32_t timer = 0;

   while ((timer < SDIO_CMD0TIMEOUT) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CCRCFAIL) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CMDREND) == RESET) &&
            (__SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == RESET))
   {
      __NOP();
      ++timer;
   }

   if (timer >= SDIO_CMD0TIMEOUT || __SDIO_GET_FLAG(SDIO, SDIO_FLAG_CTIMEOUT) == SET)
   {
      sdio_err = SD_CMD_RSP_TIMEOUT;
   }
   else
   {
      __SDIO_CLEAR_FLAG(SDIO, SDIO_STATIC_FLAGS);
   }

   return sdio_err;
}
