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
#define	counter	r16
#define	temp	r17

.extern	tx_buffer
.global sendMidiByte

sendMidiByte:

	cli
	push counter
	push temp

;************************************************************************;
;               Transmission de 1 caractere avec 1 BIT de                ;
;                        START et un bit de STOP                         ;
;************************************************************************;

	; initialisation du compteur de bits
	ldi 	counter, 8
	ldi 	temp, tx_buffer
	rcall	StartBit

next_bit:

    	;;nop			; **** Ajustement ******

	lsr	temp		; décalage pour tester la retenue
	brcc	skip_un
	rcall	UnLogic		; si C=1 on envoie un "1"
	rjmp	skip_zero
skip_un:
	rcall 	ZeroLogic	; sinon, on envoie "0"
skip_zero:
	dec	counter
	brne	next_bit	; Bit suivant

	rcall 	StopBit		; après dernier bit traité, envoi du STOP BIT
	rcall	Pause32uS


	pop	temp
	pop	counter
	ret	

;************************************************************************;
; Pause de 32us entre deux bytes
; Ici, on reutilise le registre counter qui n'est plus utilise pour 
; le comptages des bits
;************************************************************************;
Pause32uS:
	ldi counter,4
loop0:
	nop
	nop
	nop
	nop
 
	nop
	nop
	dec counter
	brne loop0
	ret
;************************************************************************;
;     Generation des signaux logiques ‡ 31250 Bauds soit 32uS par bit    ;
;************************************************************************;

StartBit:
	nop
	nop
	nop
	nop
	nop

ZeroLogic:
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

UnLogic:

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

	nop
	nop
	ret			; 30uS
