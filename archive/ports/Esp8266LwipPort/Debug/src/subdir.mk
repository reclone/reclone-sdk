################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/esp_lwip_if.c \
../src/esp_sdio_if.c \
../src/esp_wifi_ctrl.c \
../src/esp_wifi_task.c 

OBJS += \
./src/esp_lwip_if.o \
./src/esp_sdio_if.o \
./src/esp_wifi_ctrl.o \
./src/esp_wifi_task.o 

C_DEPS += \
./src/esp_lwip_if.d \
./src/esp_sdio_if.d \
./src/esp_wifi_ctrl.d \
./src/esp_wifi_task.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DSTM32F407xx -DUSE_HAL_DRIVER -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Device\ST\STM32F4xx\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\portable\GCC\ARM_CM4F" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\ports\Esp8266LwipPort\include" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


