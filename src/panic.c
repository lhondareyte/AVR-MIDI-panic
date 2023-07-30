/*
 * Copyright (c) 2012-2023 Luc Hondareyte
 *
 * SPDX-License-Identifier: MIT
 *
 */

#include "io.h"
#include "midi.h"
#include "panic.h"

uint8_t tx_buffer;
volatile uint8_t ready = 0x00;

ISR (INT0_vect) {
	ready = 0xff;
	setBit(PORTB,4);
	cli();
}

inline void sendMessages(void) {

	// Loop variables
	uint8_t c;

	if (bit_is_clear(PORT_SW,RESET_SW)) {
		tx_buffer=MIDI_RESET_MSG;
		sendMidiByte();	
	}
	else 
	{

#ifdef __ALL_SOUND_OFF_ENABLE__
		// Send ALL-SOUND-OFF
		for (c=0; c<16 ; c++) {
			tx_buffer=MIDI_CTRLCHG_MSG+c;
			sendMidiByte();	
			tx_buffer=ALL_SOUND_OFF;
			sendMidiByte();	
			tx_buffer=0x00;
			sendMidiByte();	
		}
#endif

		// Send ALL-NOTES-OFF 
		for (c=0; c<16 ; c++) {
			tx_buffer=MIDI_CTRLCHG_MSG+c;
			sendMidiByte();	
			tx_buffer=ALL_NOTES_OFF;
			sendMidiByte();	
			tx_buffer=0x00;
			sendMidiByte();	
		}

		tx_buffer = 0b10110000;
		sendMidiByte();	

#ifdef __LEGACY__
		// Send NOTEOFF for each note
		uint8_t i;
		for (c=0; c<16 ; c++) {
			c=MIDI_NOTEON_MSG+c;
			for (i=0; i<128; i++) {
				tx_buffer=c;
				sendMidiByte();
				tx_buffer=i;
				sendMidiByte();
				tx_buffer=0x00;
				sendMidiByte();
			}
		}
#endif
	}
}

int main(void)
{
	// PINB3+4 on output
	DDRB=0b00011000;

	// Configure INT0
	INTRGST=0x00;
	INTMSKR=0x40;

	// Pullup resistor on input pins
	PORTB=0x06;

	clearBit(PORTB,4);
	sei();

	while(1) {
		if ( ready == 0xff ) {
			ready = 0x00;
			sendMessages();
			// debounce
			clearBit(PORTB,4);
			_delay_ms(50);
			sei();
		}

		// Copy each bit to output
		rx2tx();
	}
}

