# MIDI panic device

Port to AVR attiny13 from a previous [project based on PIC 12C508
](https://github.com/lhondareyte/MIDI-Panic)


## Build instructions

Install `avr-gcc` on your system, then

    git clone https://github.com/lhondareyte/AVR-MIDI-panic
    cd AVR-MIDI-panic/src
    make
    make load
    make wfuse

The `load` (and `wfuse`) target assume that you have a TL866 programmer with [`minipro`](https://gitlab.com/DavidGriffith/minipro)installed

## Pass through mode

The panic device act as a passthrough device : all data entering the PB2 pin are replicated on the PB3 output. If you don't need this mode, comment out the following line in config.mk

    CFLAGS          += -D __PASS_THROUGH__

Or you can connect PB2 to VCC.
    
## License

* MIT License
