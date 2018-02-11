################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(CC_DEPS)),)
-include $(CC_DEPS)
endif
ifneq ($(strip $(C++_DEPS)),)
-include $(C++_DEPS)
endif
ifneq ($(strip $(C_UPPER_DEPS)),)
-include $(C_UPPER_DEPS)
endif
ifneq ($(strip $(CXX_DEPS)),)
-include $(CXX_DEPS)
endif
ifneq ($(strip $(ASM_DEPS)),)
-include $(ASM_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(CPP_DEPS)),)
-include $(CPP_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
SECONDARY_FLASH += \
FsmcRTOS.hex \

SECONDARY_SIZE += \
FsmcRTOS.siz \


# All Target
all: FsmcRTOS.elf secondary-outputs

dependents:
	-cd C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/bsp/discovery_m6plus_bsp/Debug && $(MAKE) clean all
	-cd C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/STM32CubeF4/Debug && $(MAKE) clean all
	-cd C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/FreeRTOS/Source/Debug && $(MAKE) clean all
	-cd C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/FreeRTOS_EC/Debug && $(MAKE) clean all

# Tool invocations
FsmcRTOS.elf: $(OBJS) $(USER_OBJS) C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/bsp/discovery_m6plus_bsp/Debug/libDiscovery_m6plus_BSP.a C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/STM32CubeF4/Debug/libSTM32CubeF4.a C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/FreeRTOS/Source/Debug/libFreeRTOS.a C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/FreeRTOS_EC/Debug/libFreeRTOS_EC.a
	@echo 'Building target: $@'
	@echo 'Invoking: Cross ARM C++ Linker'
	arm-none-eabi-g++ -mcpu=cortex-m4 -mthumb -mlittle-endian -mfloat-abi=softfp -mfpu=fpv4-sp-d16 -munaligned-access -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -ffreestanding -fno-move-loop-invariants -Wunused -Wuninitialized -Wall -Wextra -Wmissing-declarations -Wconversion -Wpointer-arith -Wshadow -Wlogical-op -Waggregate-return -Wfloat-equal  -g3 -T mem.ld -T libs.ld -T sections.ld -nostartfiles -Xlinker --gc-sections -L"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS_EC\Debug" -L"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\FreeRTOS\Source\Debug" -L"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\STM32CubeF4\Debug" -L"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\bsp\discovery_m6plus_bsp\Debug" -L"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\bsp\discovery_m6plus_bsp\ldscripts" -Wl,-Map,"FsmcRTOS.map" --specs=nano.specs -o "FsmcRTOS.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

FsmcRTOS.hex: FsmcRTOS.elf
	@echo 'Invoking: Cross ARM GNU Create Flash Image'
	arm-none-eabi-objcopy -O ihex "FsmcRTOS.elf"  "FsmcRTOS.hex"
	@echo 'Finished building: $@'
	@echo ' '

FsmcRTOS.siz: FsmcRTOS.elf
	@echo 'Invoking: Cross ARM GNU Print Size'
	arm-none-eabi-size --format=berkeley "FsmcRTOS.elf"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(CC_DEPS)$(C++_DEPS)$(OBJS)$(C_UPPER_DEPS)$(CXX_DEPS)$(SECONDARY_FLASH)$(SECONDARY_SIZE)$(ASM_DEPS)$(S_UPPER_DEPS)$(C_DEPS)$(CPP_DEPS) FsmcRTOS.elf
	-@echo ' '

secondary-outputs: $(SECONDARY_FLASH) $(SECONDARY_SIZE)

.PHONY: all clean dependents
.SECONDARY:
C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/bsp/discovery_m6plus_bsp/Debug/libDiscovery_m6plus_BSP.a:
C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/STM32CubeF4/Debug/libSTM32CubeF4.a:
C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/FreeRTOS/Source/Debug/libFreeRTOS.a:
C:/Users/Jeff/Documents/svn/reclone-sdk.git/branches/develop/third-party/FreeRTOS_EC/Debug/libFreeRTOS_EC.a:

-include ../makefile.targets
