/*
 * PANIC AVR - AVR Version
 *
 * Copyright (c) 2012 Luc Hondareyte <luc.hondareyte@laposte.net>
 * All rights reserved.
 *
 * $Id$
 */
 
#ifndef __PANIC_H__
 #define __PANIC_H__

#include <avr/io.h>

#ifndef __AVR_ATtiny13__
#error "Device not supported for this application"
#endif

extern void rx2tx(void);
extern void sendMidiByte(void);

#define SWITCH_PORT	PORTB
#define SW_RESET	0
#define SW_FIRE		1

#endif /* __PANIC_H__ */
