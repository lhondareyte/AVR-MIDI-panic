;
; PANIC MIDI - AVR Version
; 
; Copyright (c) 2012 Luc Hondareyte <luc.hondareyte@laposte.net>
; All rights reserved.
;
; $Id$
;

#include <avr/io.h>
#include "midi.h"

.global rx2tx

rx2tx:
	sbic	MIDI_IN
	sbi	MIDI_OUT
	sbis	MIDI_IN
	cbi	MIDI_OUT
	rjmp	rx2tx

