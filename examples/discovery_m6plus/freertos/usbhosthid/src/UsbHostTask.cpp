
#include "UsbHostTask.h"
#include "usbh_hid.h"


static void USBH_UserProcess(USBH_HandleTypeDef *phost, uint8_t id);

UsbHostTask::UsbHostTask()
{

}

void UsbHostTask::Run()
{
   USBH_Init(&hUSB_Host, USBH_UserProcess, 0);
   USBH_RegisterClass(&hUSB_Host, USBH_HID_CLASS);
   USBH_Start(&hUSB_Host);

   while (true)
   {
      /* USB Host Background task */
      USBH_Process(&hUSB_Host);

      Delay(10);
   }

}


bool UsbHostTask::HardwareInit()
{


   return true;
}

static void USBH_UserProcess(USBH_HandleTypeDef *phost, uint8_t id)
{
  switch(id)
  {
  case HOST_USER_SELECT_CONFIGURATION:
    break;

  case HOST_USER_DISCONNECTION:
//    Appli_state = APPLICATION_IDLE;
//    BSP_LED_Off(LED4);
//    BSP_LED_Off(LED5);
//    f_mount(NULL, (TCHAR const*)"", 0);
    break;

  case HOST_USER_CLASS_ACTIVE:
//    Appli_state = APPLICATION_START;
    break;

  default:
    break;
  }
}
