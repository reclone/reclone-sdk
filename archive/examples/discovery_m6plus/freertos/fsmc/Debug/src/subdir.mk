################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/BlinkyTask.cpp \
../src/FsmcTask.cpp \
../src/main.cpp 

OBJS += \
./src/BlinkyTask.o \
./src/FsmcTask.o \
./src/main.o 

CPP_DEPS += \
./src/BlinkyTask.d \
./src/FsmcTask.d \
./src/main.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C++ Compiler'
	arm-none-eabi-g++ -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -munaligned-access -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -ffreestanding -fno-move-loop-invariants -Wunused -Wuninitialized -Wall -Wextra -Wmissing-declarations -Wconversion -Wpointer-arith -Wshadow -Wlogical-op -Waggregate-return -Wfloat-equal  -g3 -DUSE_HAL_DRIVER -DUSE_FULL_ASSERT -DTRACE -DSTM32F407xx -DOS_USE_TRACE_SEMIHOSTING_DEBUG -DHSE_VALUE=8000000 -DDEBUG -DSTM32F417xx -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS_EC" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\portable\GCC\ARM_CM4F" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\bsp\discovery_m6plus_bsp" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\bsp\discovery_m6plus_bsp\include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Device\ST\STM32F4xx\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Inc" -I"../include" -std=gnu++11 -fabi-version=0 -fno-exceptions -fno-rtti -fno-use-cxa-atexit -fno-threadsafe-statics -Wabi -Wctor-dtor-privacy -Wnoexcept -Wnon-virtual-dtor -Wstrict-null-sentinel -Wsign-promo -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


