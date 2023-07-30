/*
 * Copyright (c) 2012-2023 Luc Hondareyte
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include "io.h"
#include <avr/io.h>

#define	counter	  r16 	// bit counter
#define	temp	  r17	// char buffer

.extern tx_buffer

.global sendMidiByte

sendMidiByte:
	cli                     ; Disable interrupts

	push counter            ; Saving registers
	push temp 

        sbi MIDI_OUT
	ldi counter, 8          ; load bit counter
	lds temp, tx_buffer     ; load char to send

	rcall StartBit          ; c'est parti!

NextBit:
	sbrc temp, 0            ; If temp[0] = 0 -> Call Zero
	rcall One               ; else One
	sbrs temp, 0
	rcall Zero	

	lsr temp                ; shift to right for next bit
	dec counter
	brne NextBit	

end:
	rcall StopBit           ; go to StopBit after last bit
	rcall delay_32us        ; 32 us delay between two bits

	pop temp                ; restore registers
	pop counter		
	sei                     ; enable interrupts
	ret                     ; back to main

;
; Delay between two bytes. We can use counter register 
; since it's no more used for transmission
;

delay_32us:

	ldi counter,4

_loop0:

	nop
	nop
	nop
	nop
 
	nop
	nop

	dec counter
	brne _loop0
	ret		

;
; Bit generation ‡ 32us per bit @  31200B/s
;

StartBit:
	nop
	nop
	nop
	nop
	nop

Zero:
	nop
	nop
	nop
        nop
	nop
        cbi MIDI_OUT

	nop
	nop
	nop
	nop
	nop			

	nop
	nop
	nop
	nop
	nop			

	nop			
	nop			
	nop			
	nop
	nop

	ret		

StopBit:
	nop
	nop
	nop
	nop
	nop

	nop

One:

	nop
	nop
        nop
	nop
        sbi MIDI_OUT

	nop
	nop
	nop
	nop
	nop

	nop
	nop
	nop
	nop
	nop

	nop
	nop
	nop
	nop
	nop

	ret
