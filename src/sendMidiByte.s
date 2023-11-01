;
; PANIC MIDI - AVR Version
; 
; Copyright (c) 2012-2023 Luc Hondareyte
; All rights reserved.
;
; $Id$
;

#include "io.h"
#include <avr/io.h>

#define	counter	  r18 	// bit counter
#define	temp	  r19	// char buffer

.extern tx_buffer

.global sendMidiByte

sendMidiByte:
        sbi LED_OUT
	cli                     ; Disable interrupts

	push counter            ; Saving registers
	push temp 

        sbi MIDI_OUT

	rcall StartBit          ; c'est parti!

	ldi counter, 8          ; load bit counter
	lds temp, tx_buffer     ; load char to send

NextBit:
	sbrc temp, 0            ; If temp[0] = 0 -> Call Zero
	rcall Zero              ; else One
	sbrs temp, 0
	rcall One	

	lsr temp                ; shift to right for next bit
	dec counter
	breq end	
	rjmp NextBit

end:
	sbi MIDI_OUT            ; Generate stopbit
	rcall loop              ; 
	rcall loop              ; 32 us delay between two bytes
	pop temp                ; restore registers
	pop counter		
	sei                     ; enable interrupts
	cbi LED_OUT
	ret                     ; back to main

;
; Bit generation ‡ 32us per bit @  31250B/s

StartBit:
Zero:
        cbi MIDI_OUT
	rcall loop
	ret		

One:
        sbi MIDI_OUT
	nop
	nop
	nop
	nop

loop:
        push counter
        ldi counter, 4
_loop:
        dec counter
        brne _loop
        pop counter

        ret
