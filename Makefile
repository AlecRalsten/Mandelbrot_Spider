TARGET := payload

SOURCES = source 
INCLUDES = include

C_FILES := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.c)) 
S_FILES := $(foreach dir,$(SOURCES),$(wildcard $(dir)/*.S))
OBJS    := $(C_FILES:.c=.o) $(S_FILES:.S=.o)

PREFIX=arm-none-eabi
CC=$(PREFIX)-gcc
LD=$(PREFIX)-ld
STRIP=$(PREFIX)-strip
OBJCOPY=$(PREFIX)-objcopy

ARCH    = -marm -mcpu=arm946e-s -march=armv5te -mlittle-endian -fshort-wchar -fno-zero-initialized-in-bss
ASFLAGS = $(ARCH)
CFLAGS  = -c -s -g -Os -Wall $(ASFLAGS) -I$(INCLUDES) -std=c99
LDFLAGS = -nostartfiles -nostdlib

all: Launcher.dat clean

Launcher.dat: $(TARGET).bin

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -S -O binary $(TARGET).elf $(TARGET).bin
	cp tools/Launcher.dat Launcher.dat
	python tools/insert.py Launcher.dat $(TARGET).bin 0x16D8D0
$(TARGET).elf: $(OBJS)
	$(LD) $(LDFLAGS) -T tools/linker.x $(OBJS) -o $(TARGET).elf

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
%.o: %.S
	$(CC) $(ASFLAGS) -c $< -o $@

clean:
	@rm -rf $(OBJS) $(TARGET).elf
	@echo "Cleaned!"
