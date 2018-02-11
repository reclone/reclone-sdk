################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../AManagedTask.cpp \
../ASyncObject.cpp \
../ATimer.cpp \
../CBinarySemaphore.cpp \
../CCountingSemaphore.cpp \
../CFreeRTOS.cpp \
../CMessageTask.cpp \
../CMutex.cpp \
../CQueue.cpp \
../CRecursiveMutex.cpp \
../CTask.cpp 

OBJS += \
./AManagedTask.o \
./ASyncObject.o \
./ATimer.o \
./CBinarySemaphore.o \
./CCountingSemaphore.o \
./CFreeRTOS.o \
./CMessageTask.o \
./CMutex.o \
./CQueue.o \
./CRecursiveMutex.o \
./CTask.o 

CPP_DEPS += \
./AManagedTask.d \
./ASyncObject.d \
./ATimer.d \
./CBinarySemaphore.d \
./CCountingSemaphore.d \
./CFreeRTOS.d \
./CMessageTask.d \
./CMutex.d \
./CQueue.d \
./CRecursiveMutex.d \
./CTask.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C++ Compiler'
	arm-none-eabi-g++ -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -munaligned-access -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\config" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\portable\GCC\ARM_CM4F" -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\include" -std=gnu++11 -fabi-version=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


