################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/cortexm/_initialize_hardware.c \
../src/cortexm/_reset_hardware.c \
../src/cortexm/exception_handlers.c 

OBJS += \
./src/cortexm/_initialize_hardware.o \
./src/cortexm/_reset_hardware.o \
./src/cortexm/exception_handlers.o 

C_DEPS += \
./src/cortexm/_initialize_hardware.d \
./src/cortexm/_reset_hardware.d \
./src/cortexm/exception_handlers.d 


# Each subdirectory must supply rules for building sources it contributes
src/cortexm/%.o: ../src/cortexm/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -munaligned-access -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DDEBUG -DHSE_VALUE=8000000 -DOS_USE_TRACE_SEMIHOSTING_DEBUG -DSTM32F407xx -DTRACE -DUSE_FULL_ASSERT -DUSE_HAL_DRIVER -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Device\ST\STM32F4xx\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\bsp\discovery_m6plus_bsp\include" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


