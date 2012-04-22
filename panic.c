/*
 * PANIC MIDI - AVR Version
 * 
 * Copyright (c) 2012 Luc Hondareyte <luc.hondareyte@laposte.net>
 * All rights reserved.
 *
 * $Id$
 */

#include <avr/io.h>
#include <stdlib.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <util/delay.h>
#include "panic.h"
#include "midi.h"

volatile uint8_t tx_buffer;

#ifdef __JACKY_MODE__
ISR (TIMER0_vect)
{

}
#endif

ISR (INT0_vect)
{
	// Loop variables
	uint8_t i,c;

	// Attente anti-rebond
	_delay_ms(50);
	if (bit_is_set(SWITCH_PORT,SW_FIRE))
	{
		// Sequence RESET si switch actif
		if (bit_is_set(SWITCH_PORT,SW_RESET))
		{
			tx_buffer=MIDI_RESET_MSG;
			sendMidiByte();	
		}

#ifdef __ALL_SOUND_OFF_ENABLE__
		// Sequence ALL-SOUND-OFF
		for (c=0; c<16 ; c++)
		{
			tx_buffer=MIDI_CTRLCHG_MSG+c;
			sendMidiByte();	
			tx_buffer=ALL_SOUND_OFF;
			sendMidiByte();	
			tx_buffer=0x00;
			sendMidiByte();	
		}		// Sequence ALL-SOUNDS-OFF
		for (c=0; c<16 ; c++)
		{
			tx_buffer=MIDI_CTRLCHG_MSG+c;
			sendMidiByte();	
			tx_buffer=ALL_SOUND_OFF;
			sendMidiByte();	
			tx_buffer=0x00;
			sendMidiByte();	
		}

#endif

#ifdef __ALL_NOTES_OFF_ENABLE__
		// Sequence ALL-NOTES-OFF 
		for (c=0; c<16 ; c++)
		{
			tx_buffer=MIDI_CTRLCHG_MSG+c;
			sendMidiByte();	
			tx_buffer=ALL_NOTES_OFF;
			sendMidiByte();	
			tx_buffer=0x00;
			sendMidiByte();	
		}
#endif

		// Pour les mal-comprenants
		for (c=0; c<16 ; c++)
		{
			c=MIDI_NOTEON_MSG+c;
			for (i=0; i<128; i++)
			{
				tx_buffer=c;
				sendMidiByte();
				tx_buffer=i;
				sendMidiByte();
				tx_buffer=0x00;
				sendMidiByte();
			}
		}
	}
	// Attente du retour à la normale
	loop_until_bit_is_set(SWITCH_PORT,SW_FIRE);
}

int main(void)
{
	// On recopie l'entrée sur la sortie uniquement, tout se fait en interruption
	while (1)  
	{
		rx2tx();
	}

}
