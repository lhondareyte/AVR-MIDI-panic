#
# Copyright (c) 2006-2011 Luc HONDAREYTE
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or 
# without modification, are permitted provided that the 
# following conditions are met:
# 1. Redistributions of source code must retain the above 
#    copyright notice, this list of conditions and the 
#    following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF 
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# $Id: Makefile,v 1.4 2011/04/25 16:21:03 luc Exp luc $
#

FIRMWARE	:=panic
MCU		:=attiny13
HZ		:=4000000
#
# Valeurs de hfuse et lfuse
LFUSE		:=0xff
HFUSE		:=0xdf

#CCPATH		:=/usr/local/CrossPack-AVR/bin
CCPATH		:=/usr/local/bin
#
# Vous ne devriez pas avoir besoin de modifier ce qui suit
CC		:= $(CCPATH)/avr-gcc
OBJCOPY		:= $(CCPATH)/avr-objcopy
CFLAGS		:= -Os -D F_CPU=$(HZ)
CFLAGS		+= -g -mmcu=$(MCU) -Wall -Wstrict-prototypes
CFLAGS		+= -D __ALL_NOTES_OFF_ENABLE__
CFLAGS		+= -D __ALL_SOUND_OFF_ENABLE__
HEADERS         := $(wildcard *.h)
SOURCES         := $(wildcard *.c) 
ASMSRCS		:= $(wildcard *.s)
OBJECTS         := $(patsubst %.c,%.o,$(SOURCES))
OBJECTS         += $(patsubst %.s,%.o,$(ASMSRCS))
ASMFLAGS	:=-Os -mmcu=$(MCU) -x assembler-with-cpp -gstabs -I /usr/local/avr/include

all: $(FIRMWARE).hex

coffee: all load verify wfuse mrproper
	@echo "All is nice. Have a good day."

$(FIRMWARE).hex: $(FIRMWARE).out 
	@printf "Generating $(FIRMWARE).hex..."
	@$(OBJCOPY) -R .eeprom -O ihex $(FIRMWARE).out $(FIRMWARE).hex
	@echo "done."

$(FIRMWARE).out: $(OBJECTS)
	@printf "Linking    $(FIRMWARE)..."
	@$(CC) $(CFLAGS) -o $(FIRMWARE).out \
		-Wl,-Map,$(FIRMWARE).map $(OBJECTS)
	@echo "done."

.c.o:  $(HEADERS) $(SOURCES)
	@printf "Compiling  $<..."
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "done."

.s.o:  $(HEADERS) $(ASMSRCS)
	@printf "Compiling  $<..."
	@$(CC) $(ASMFLAGS) -c $< -o $@
	@echo "done."

asm: $(FIRMWARE).out
	@printf "Generating assembler source file..."
	@$(CCPATH)/avr-objdump -D -S $(FIRMWARE).out > $(FIRMWARE).s
	@echo "done."

bin: $(FIRMWARE).hex
	@printf "Generating binary file..."
	@hex2bin $(FIRMWARE).hex > /dev/null 2>&1
	@echo "done."
	@ls -l $(FIRMWARE).bin
#
# Configuration du programmateur ISP
LOADER=/usr/local/bin/avrdude

ifeq ($(shell uname -s), FreeBSD)
ISP=-c stk500v2 -P /dev/cuaU0		# Programmateur USB
#ISP	:=-c stk200 -P /dev/ppi0	# Programmateur parallele
endif

ifeq ($(shell uname -s), Darwin)
MODEM	:= $(shell ([ -c /dev/cu*usbmodem* ] && ls /dev/cu*usbmodem*))
ISP	:=-c avrispmkII -P $(MODEM)
#ISP	:=-c stk500v2 -P $(MODEM)
endif

LOADER	:=$(LOADER) -p $(MCU) $(ISP)
LOAD	:=$(LOADER) -i 5 -U flash:w:$(FIRMWARE).hex
DUMP	:=$(LOADER) -i 5 -U flash:r:$(FIRMWARE).hex:i
VERIFY	:=$(LOADER) -i 5 -U flash:v:$(FIRMWARE).hex
ERASE	:=$(LOADER) -i 5 -e
RFUSE	:=$(LOADER) -U lfuse:r:low.txt:b -U hfuse:r:high.txt:b
WFUSE	:=$(LOADER) -U lfuse:w:$(LFUSE):m -U hfuse:w:$(HFUSE):m

load:
	echo $(MODEM)
	@printf "Loading firmware..."
	#@$(LOAD) > /dev/null 2>&1
	@$(LOAD)
	@echo "done."
dump:
	@printf "Reading $(MCU) device..."
	@$(DUMP) > /dev/null 2>&1
	@echo "done."
verify:
	@printf "Verify $(MCU) device..."
	@$(VERIFY) > /dev/null 2>&1
	$(VERIFY) 
	@echo "done."
erase:
	@printf "Erasing $(MCU) device..."
	@$(ERASE) > /dev/null 2>&1
	@echo "done."
rfuse:
	@printf "Reading fuse..."
	@$(RFUSE) > /dev/null 2>&1
	@echo "done."
wfuse:
	@printf "Writing fuse..."
	@$(WFUSE) > /dev/null 2>&1
	@echo "done."
#
# Nettoyage, Archivage, etc.
clean :
	@printf "Cleaning source tree..."
	@rm -f *.map *.bin *~ *.out *.gch *.o \
		low.txt high.txt $(FIRMWARE) $(FIRMWARE).asm
	@echo "done."

mrproper : clean
	@rm -f *.hex

archive: mrproper
	@tar cvzf ../../$(FIRMWARE).tgz ../../$(FIRMWARE)
#EOF
