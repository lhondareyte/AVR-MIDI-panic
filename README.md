# MIDI panic device

Port to AVR from a previous [project based on PIC 12C508
](https://github.com/lhondareyte/MIDI-Panic)


## Build instructions

Install `avr-gcc` on your system, then

    git clone https://github.com/lhondareyte/AVR-MIDI-panic
    cd AVR-MIDI-panic/src
    make
    make load

The `load` target assume that you have a TL866 programmer with [`minipro`](https://gitlab.com/DavidGriffith/minipro)installed

