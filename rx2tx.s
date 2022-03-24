;
; PANIC MIDI - AVR Version
; 
; Copyright (c) 2012-2022 Luc Hondareyte
; All rights reserved.
;
; $Id$
;

#include <avr/io.h>

#define MIDI_IN   _SFR_IO_ADDR(PINB),2
#define MIDI_OUT  _SFR_IO_ADDR(PORTB),3

.global rx2tx

rx2tx:
	; sbic : skip if bit in I/O register is clear
	; sbi  : set bit in I/o register
	; sbis : skip if bit in I/o register is set
	; cbi  : clear bit in I/o register
	sbic    MIDI_IN
	sbi     MIDI_OUT
	sbis    MIDI_IN
	cbi     MIDI_OUT
	rjmp	rx2tx

