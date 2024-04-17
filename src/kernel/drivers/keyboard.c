
#include <stdint.h>

volatile uint8_t* ps2Data = (uint8_t*)0x60;
volatile uint8_t* ps2Status = (uint8_t*)0x64;
volatile uint8_t* ps2Command = (uint8_t*)0x64;

void ps2_keyboardInit()
{
	*ps2Command = 0xa7; // disable port 2

	*ps2Command = 0xae; // enable keyboard
}

int ps2_isDataAvailable()
{
	return (*ps2Status & 0x01); // bit 1 is data available
}

char getc()
{
	while (!ps2_isDataAvailable());
	return (char)*ps2Data;
}



