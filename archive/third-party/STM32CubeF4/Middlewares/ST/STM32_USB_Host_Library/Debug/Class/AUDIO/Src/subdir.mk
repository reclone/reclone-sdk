################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Class/AUDIO/Src/usbh_audio.c 

OBJS += \
./Class/AUDIO/Src/usbh_audio.o 

C_DEPS += \
./Class/AUDIO/Src/usbh_audio.d 


# Each subdirectory must supply rules for building sources it contributes
Class/AUDIO/Src/%.o: ../Class/AUDIO/Src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Device\ST\STM32F4xx\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Core\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Core\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\AUDIO\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\CDC\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\HID\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\MSC\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Middlewares\ST\STM32_USB_Host_Library\Class\MTP\Inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

