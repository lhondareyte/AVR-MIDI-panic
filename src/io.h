/*
 * Copyright (c) 2012-2023 Luc Hondareyte
 *
 * SPDX-License-Identifier: MIT
 *
 */

#define RESET_SW  0
#define FIRE_SW   1
#define IN        2
#define OUT       3
#define LED       4
#define PORT_SW   PINB
#define MIDI_IN   _SFR_IO_ADDR(PORTB),IN
#define MIDI_OUT  _SFR_IO_ADDR(PORTB),OUT
#define LED_OUT   _SFR_IO_ADDR(PORTB),LED
