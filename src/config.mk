#
# $Id: Makefile,v 1.4 2011/04/25 16:21:03 luc Exp luc $
#

FIRMWARE	:=panic
MCU		:=attiny13
#MCU		:=attiny4

include Mk/$(MCU).mk

CFLAGS          += -D __PASS_THROUGH__
