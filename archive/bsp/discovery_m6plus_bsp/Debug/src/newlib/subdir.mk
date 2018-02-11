################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/newlib/_exit.c \
../src/newlib/_sbrk.c \
../src/newlib/_startup.c \
../src/newlib/_syscalls.c \
../src/newlib/assert.c 

CPP_SRCS += \
../src/newlib/_cxx.cpp 

OBJS += \
./src/newlib/_cxx.o \
./src/newlib/_exit.o \
./src/newlib/_sbrk.o \
./src/newlib/_startup.o \
./src/newlib/_syscalls.o \
./src/newlib/assert.o 

C_DEPS += \
./src/newlib/_exit.d \
./src/newlib/_sbrk.d \
./src/newlib/_startup.d \
./src/newlib/_syscalls.d \
./src/newlib/assert.d 

CPP_DEPS += \
./src/newlib/_cxx.d 


# Each subdirectory must supply rules for building sources it contributes
src/newlib/%.o: ../src/newlib/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C++ Compiler'
	arm-none-eabi-g++ -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -munaligned-access -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DDEBUG -DHSE_VALUE=8000000 -DOS_USE_TRACE_SEMIHOSTING_DEBUG -DSTM32F407xx -DTRACE -DUSE_FULL_ASSERT -DUSE_HAL_DRIVER -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Device\ST\STM32F4xx\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\bsp\discovery_m6plus_bsp\include" -std=gnu++11 -fabi-version=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/newlib/%.o: ../src/newlib/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -munaligned-access -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -DDEBUG -DHSE_VALUE=8000000 -DOS_USE_TRACE_SEMIHOSTING_DEBUG -DSTM32F407xx -DTRACE -DUSE_FULL_ASSERT -DUSE_HAL_DRIVER -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Inc" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\STM32F4xx_HAL_Driver\Config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Drivers\CMSIS\Device\ST\STM32F4xx\Include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\bsp\discovery_m6plus_bsp\include" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


