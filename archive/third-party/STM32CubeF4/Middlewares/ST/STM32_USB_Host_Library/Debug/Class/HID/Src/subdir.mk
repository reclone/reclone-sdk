################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Class/HID/Src/usbh_hid.c \
../Class/HID/Src/usbh_hid_keybd.c \
../Class/HID/Src/usbh_hid_mouse.c \
../Class/HID/Src/usbh_hid_parser.c 

OBJS += \
./Class/HID/Src/usbh_hid.o \
./Class/HID/Src/usbh_hid_keybd.o \
./Class/HID/Src/usbh_hid_mouse.o \
./Class/HID/Src/usbh_hid_parser.o 

C_DEPS += \
./Class/HID/Src/usbh_hid.d \
./Class/HID/Src/usbh_hid_keybd.d \
./Class/HID/Src/usbh_hid_mouse.d \
./Class/HID/Src/usbh_hid_parser.d 


# Each subdirectory must supply rules for building sources it contributes
Class/HID/Src/%.o: ../Class/HID/Src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Device\ST\STM32F4xx\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Core\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Core\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\AUDIO\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\CDC\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\HID\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\MSC\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\MTP\Inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


