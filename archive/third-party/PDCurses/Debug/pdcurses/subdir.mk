################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../pdcurses/addch.c \
../pdcurses/addchstr.c \
../pdcurses/addstr.c \
../pdcurses/attr.c \
../pdcurses/beep.c \
../pdcurses/bkgd.c \
../pdcurses/border.c \
../pdcurses/clear.c \
../pdcurses/color.c \
../pdcurses/debug.c \
../pdcurses/delch.c \
../pdcurses/deleteln.c \
../pdcurses/deprec.c \
../pdcurses/getch.c \
../pdcurses/getstr.c \
../pdcurses/getyx.c \
../pdcurses/inch.c \
../pdcurses/inchstr.c \
../pdcurses/initscr.c \
../pdcurses/inopts.c \
../pdcurses/insch.c \
../pdcurses/insstr.c \
../pdcurses/instr.c \
../pdcurses/kernel.c \
../pdcurses/keyname.c \
../pdcurses/mouse.c \
../pdcurses/move.c \
../pdcurses/outopts.c \
../pdcurses/overlay.c \
../pdcurses/pad.c \
../pdcurses/panel.c \
../pdcurses/printw.c \
../pdcurses/refresh.c \
../pdcurses/scanw.c \
../pdcurses/scr_dump.c \
../pdcurses/scroll.c \
../pdcurses/slk.c \
../pdcurses/termattr.c \
../pdcurses/terminfo.c \
../pdcurses/touch.c \
../pdcurses/util.c \
../pdcurses/window.c 

OBJS += \
./pdcurses/addch.o \
./pdcurses/addchstr.o \
./pdcurses/addstr.o \
./pdcurses/attr.o \
./pdcurses/beep.o \
./pdcurses/bkgd.o \
./pdcurses/border.o \
./pdcurses/clear.o \
./pdcurses/color.o \
./pdcurses/debug.o \
./pdcurses/delch.o \
./pdcurses/deleteln.o \
./pdcurses/deprec.o \
./pdcurses/getch.o \
./pdcurses/getstr.o \
./pdcurses/getyx.o \
./pdcurses/inch.o \
./pdcurses/inchstr.o \
./pdcurses/initscr.o \
./pdcurses/inopts.o \
./pdcurses/insch.o \
./pdcurses/insstr.o \
./pdcurses/instr.o \
./pdcurses/kernel.o \
./pdcurses/keyname.o \
./pdcurses/mouse.o \
./pdcurses/move.o \
./pdcurses/outopts.o \
./pdcurses/overlay.o \
./pdcurses/pad.o \
./pdcurses/panel.o \
./pdcurses/printw.o \
./pdcurses/refresh.o \
./pdcurses/scanw.o \
./pdcurses/scr_dump.o \
./pdcurses/scroll.o \
./pdcurses/slk.o \
./pdcurses/termattr.o \
./pdcurses/terminfo.o \
./pdcurses/touch.o \
./pdcurses/util.o \
./pdcurses/window.o 

C_DEPS += \
./pdcurses/addch.d \
./pdcurses/addchstr.d \
./pdcurses/addstr.d \
./pdcurses/attr.d \
./pdcurses/beep.d \
./pdcurses/bkgd.d \
./pdcurses/border.d \
./pdcurses/clear.d \
./pdcurses/color.d \
./pdcurses/debug.d \
./pdcurses/delch.d \
./pdcurses/deleteln.d \
./pdcurses/deprec.d \
./pdcurses/getch.d \
./pdcurses/getstr.d \
./pdcurses/getyx.d \
./pdcurses/inch.d \
./pdcurses/inchstr.d \
./pdcurses/initscr.d \
./pdcurses/inopts.d \
./pdcurses/insch.d \
./pdcurses/insstr.d \
./pdcurses/instr.d \
./pdcurses/kernel.d \
./pdcurses/keyname.d \
./pdcurses/mouse.d \
./pdcurses/move.d \
./pdcurses/outopts.d \
./pdcurses/overlay.d \
./pdcurses/pad.d \
./pdcurses/panel.d \
./pdcurses/printw.d \
./pdcurses/refresh.d \
./pdcurses/scanw.d \
./pdcurses/scr_dump.d \
./pdcurses/scroll.d \
./pdcurses/slk.d \
./pdcurses/termattr.d \
./pdcurses/terminfo.d \
./pdcurses/touch.d \
./pdcurses/util.d \
./pdcurses/window.d 


# Each subdirectory must supply rules for building sources it contributes
pdcurses/%.o: ../pdcurses/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=cortex-m3 -mthumb -O0 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections  -g3 -I"C:\Users\Jeff\Documents\svn\reclone-sdk.git\branches\develop\third-party\PDCurses" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


