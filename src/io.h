#define RESET_SW  0
#define FIRE_SW   1
#define IN        2
#define OUT       3
#define PORT_SW   PINB
#define MIDI_IN   _SFR_IO_ADDR(PINB),IN
#define MIDI_OUT  _SFR_IO_ADDR(PORTB),OUT
