################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../portable/MSVC-MingW/port.c 

OBJS += \
./portable/MSVC-MingW/port.o 

C_DEPS += \
./portable/MSVC-MingW/port.d 


# Each subdirectory must supply rules for building sources it contributes
portable/MSVC-MingW/%.o: ../portable/MSVC-MingW/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"../include" -I"../portable/GCC/ARM_CM4F" -I"../config" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


