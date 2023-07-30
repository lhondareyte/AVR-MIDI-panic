/*
 * Copyright (c) 2012-2023 Luc Hondareyte
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include "io.h"
#include <avr/io.h>

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

