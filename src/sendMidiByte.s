;
; PANIC MIDI - AVR Version
; 
; Copyright (c) 2012-2022 Luc Hondareyte
; All rights reserved.
;
; $Id$
;

#include <avr/io.h>

#define	counter	  r16 	// bit counter
#define	temp	  r17	// char buffer
#define	mask      0xff	// mask to address midi output
#define MIDI_IN   _SFR_IO_ADDR(PINB),2
#define MIDI_OUT  _SFR_IO_ADDR(PORTB),3

.extern tx_buffer
.global sendMidiByte

sendMidiByte:

	cli			; Disable interruptions
	push counter		; saving registers
	push temp		; 

	ldi 	counter, 8	; load bit counter
	ldi 	temp, tx_buffer ; load char to send

	rcall	start_bit       ; let's go

next_bit:

	lsr	temp		; shift to carry
	brcc	skip_high 	; If carry = 1 -> high_bit else low_bit
	rcall	high_bit	
	rjmp	skip_low
skip_high:
	rcall 	low_bit	        
skip_low:
	dec	counter
	brne	next_bit	; next bit

	rcall 	stop_bit	; go to stop_bit after last bit


;
; 32us delay beetween two bytes. We can use counter register 
; since it's no more used for transmission
;

	ldi counter,4
_delay_32us:

	nop
	nop
	nop
	nop
 
	nop
	nop
	dec counter
	brne _delay_32us

	pop	temp		; restore registers
	pop	counter		
	sei			; enable interrupts
	ret			; back to main()


;
; Bit generation ‡ 32us per bit @  31200B/s
;

start_bit:
	nop
	nop
	nop
	nop
	nop

low_bit:
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

stop_bit:
	nop
	nop
	nop
	nop
	nop

	nop

high_bit:

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

	pop temp		
	pop counter	
	ret			; 30uS
