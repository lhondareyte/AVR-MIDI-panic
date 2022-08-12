/*
 * PANIC AVR - AVR Version
 *
 * Copyright (c) 2012 Luc Hondareyte
 * All rights reserved.
 *
 * $Id$
 */
 
#ifndef __PANIC_H__
#define __PANIC_H__

#include <avr/io.h>
#include <stdlib.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <util/delay.h>

#if defined (__AVR_ATtiny13__) || defined (__AVR_ATtiny4__)

extern void rx2tx(void);
extern void sendMidiByte(void);

#define RESET_SW  0
#define FIRE_SW   1
#define PORT_SW   PINB
#define MIDI_IN   _SFR_IO_ADDR(PINB),2
#define MIDI_OUT  _SFR_IO_ADDR(PORTB),3

#else
#error "Device not supported"
#endif

#endif /* __PANIC_H__ */
