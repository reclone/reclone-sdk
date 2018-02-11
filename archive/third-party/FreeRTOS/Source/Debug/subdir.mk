################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../croutine.c \
../event_groups.c \
../list.c \
../queue.c \
../tasks.c \
../timers.c 

OBJS += \
./croutine.o \
./event_groups.o \
./list.o \
./queue.o \
./tasks.o \
./timers.o 

C_DEPS += \
./croutine.d \
./event_groups.d \
./list.d \
./queue.d \
./tasks.d \
./timers.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -munaligned-access -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\include" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\portable\GCC\ARM_CM4F" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\config" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


