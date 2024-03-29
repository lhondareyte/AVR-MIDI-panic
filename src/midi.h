/*
 * Copyright (c) 2012-2023 Luc Hondareyte
 *
 * SPDX-License-Identifier: MIT
 *
 */
 
#ifndef __MIDI_H__
 #define __MIDI_H__

#define ALL_SOUND_OFF		0x78
#define ALL_NOTES_OFF		0x7B

#define	RESET_MESSAGE		0xFF
#define MIDI_UNKNOW_MSG		0xFF
#define MIDI_NOTOFF_MSG		0x80
#define MIDI_NOTEON_MSG		0x90		
#define MIDI_POLYAF_MSG		0xA0		
#define MIDI_CTRLCHG_MSG	0xB0
#define MIDI_CHNMODE_MSG	0xB0
#define MIDI_PROGCH_MSG		0xC0
#define MIDI_CHANAF_MSG		0xD0
#define MIDI_PITCHB_MSG		0xE0

/*
 *  System common messages
 */

#define MIDI_SYSEX_MSG		0xF0
#define MIDI_QUARTER_MSG	0xF1
#define MIDI_SONGPOS_MSG	0xF2
#define MIDI_SONGSEL_MSG	0xF3

/*
 *  One-byte System common messages
 */

#define MIDI_UNDEF1_MSG		0xF4
#define MIDI_UNDEF2_MSG		0xF5
#define MIDI_TUNERQ_MSG		0xF6
#define MIDI_EOX_MSG		0xF7

/*
 *  System Real Time messages 
 */

#define MIDI_TIMECLK_MSG	0xF8
#define MIDI_UNDEF3_MSG		0xF9
#define MIDI_START_MSG		0xFA
#define MIDI_CONTINUE_MSG	0xFB
#define MIDI_STOP_MSG		0xFC
#define MIDI_UNDEF4_MSG		0xFD
#define MIDI_ACTIVE_MSG		0xFE
#define MIDI_RESET_MSG		0xFF

/*
 *  MIDI Controller Numbers
 */

#define MIDI_BANKSEL_CTRL	0x00
#define MIDI_MODWHEEL_CTRL	0x01
#define MIDI_BREATH_CTRL	0x02
#define MIDI_FOOT_CTRL		0x04
#define MIDI_PORTMTO_CTRL	0x05
#define MIDI_DATAENTRY_CTRL	0x06
#define MIDI_VOLUME_CTRL	0x07
#define MIDI_BALANCE_CTRL	0x08
#define MIDI_PAN_CTRL		0x0A
#define MIDI_EXPRESSION_CTRL	0x0B
#define MIDI_EFFECT1_CTRL	0x0C
#define MIDI_EFFECT2_CTRL	0x0D
#define MIDI_GENPURP1_CTRL	0x10
#define MIDI_GENPURP2_CTRL	0x11
#define MIDI_GENPURP3_CTRL	0x12
#define MIDI_GENPURP4_CTRL	0x13

#endif // __MIDI_H__
