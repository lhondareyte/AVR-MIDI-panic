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

#if defined (__AVR_ATtiny13__) || defined (__AVR_ATtiny13a__)
#undef F_CPU
#define F_CPU	4800000UL
#define INTMSKR         GIMSK           // Interupt mask register
#define INTRGST         MCUCR           // Interrupt register
#else
#error "Device not supported"
#endif
extern void rx2tx(void);
extern void sendMidiByte(void);
void sendMessages(void);

#define setBit(octet,bit)     ( octet |= (1<<bit))
#define clearBit(octet,bit)   ( octet &= ~(1<<bit))
#define toggleBit(octet,bit)  ( octet ^= (1<<bit))
#define enable_INT0()         setBit(INTMSKR,INT0)
#define disable_INT0()        clearBit(INTMSKR,INT0)

#include <avr/io.h>
#include <stdlib.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <util/delay.h>

#endif /* __PANIC_H__ */
