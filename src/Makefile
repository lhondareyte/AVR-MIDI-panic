#
# $Id: Makefile,v 1.4 2011/04/25 16:21:03 luc Exp luc $
#

default: all

include config.mk

CC		:= avr-gcc
OBJCOPY		:= avr-objcopy
OBJDUMP		:= avr-objdump
CFLAGS		+=-Os -D F_CPU=$(HZ)
CFLAGS		+=-g -mmcu=$(MCU) -Wall -Wstrict-prototypes

ASMFLAGS	:=-Os -mmcu=$(MCU) -x assembler-with-cpp
ASMFLAGS	+=-I /usr/local/avr/include

all: $(FIRMWARE).hex

coffee: all load verify wfuse mrproper
	@echo "All is nice. Have a good day."

$(FIRMWARE).hex: $(FIRMWARE).out 
	@printf "Generating $(FIRMWARE).hex..."
	@$(OBJCOPY) -R .eeprom -O ihex $(FIRMWARE).out  \
		$(FIRMWARE).hex
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

.s.o: $(HEADERS) $(ASMSRCS)
	@printf "Compiling  $<..."
	@$(CC) $(ASMFLAGS) -c $< -o $@
	@echo "done."

asm: $(FIRMWARE).out
	@printf "Generating assembler source file..."
	@$(OBJDUMP) -D -S $(FIRMWARE).out > $(FIRMWARE).s
	@echo "done."

bin: $(FIRMWARE).out 
	@printf "Generating $(FIRMWARE).bin ..."
	@$(OBJCOPY) -R .eeprom -O binary $(FIRMWARE).out  \
		$(OBJCOPY_OPTS) $(FIRMWARE).bin
	@echo "done."

load: bin
	@printf "Loading firmware..."
	@$(LOAD) > /dev/null 2>&1
	@echo "done."
dump:
	@printf "Reading $(MCU) device..."
	@$(DUMP) > /dev/null 2>&1
	@echo "done."
verify:
	@printf "Verify $(MCU) device..."
	@$(VERIFY) > /dev/null 2>&1
	@echo "done."
erase:
	@printf "Erasing $(MCU) device..."
	@$(ERASE) > /dev/null 2>&1
	@echo "done."
rfuse:
	@printf "Reading fuse..."
	@$(RFUSE) > /dev/null 2>&1
	@echo "done."
wfuse: fuses.txt
	@printf "Writing fuse..."
	@$(WFUSE) > /dev/null 2>&1
	@echo "done."
#
# Nettoyage, Archivage, etc.
clean :
	@printf "Cleaning source tree..."
	@rm -f *.map *.bin *~ *.out *.gch *.o \
		low.txt high.txt $(FIRMWARE) \
		fuses.txt $(FIRMWARE).asm *.hex
	@echo "done."
#EOF
