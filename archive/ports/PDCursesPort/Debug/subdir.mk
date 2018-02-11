################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../pdcclip.c \
../pdcdisp.c \
../pdcgetsc.c \
../pdckbd.c \
../pdcscrn.c \
../pdcsetsc.c \
../pdcutil.c 

OBJS += \
./pdcclip.o \
./pdcdisp.o \
./pdcgetsc.o \
./pdckbd.o \
./pdcscrn.o \
./pdcsetsc.o \
./pdcutil.o 

C_DEPS += \
./pdcclip.d \
./pdcdisp.d \
./pdcgetsc.d \
./pdckbd.d \
./pdcscrn.d \
./pdcsetsc.d \
./pdcutil.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\PDCurses" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


