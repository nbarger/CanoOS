
#include <stdint.h>
#include <stddef.h>

#define CONSOLE_WIDTH 80
#define CONSOLE_HEIGHT 25

volatile uint16_t* vgaBuffer = (uint16_t*)0xB8000;

void cls()
{
	for (size_t i=0; i<CONSOLE_WIDTH*CONSOLE_HEIGHT; i++)
	{
		vgaBuffer[i] = (uint16_t)(' ' | 0x0700);
	}
}

void putchar(char c)
{
	static size_t row = 0;
	static size_t column = 0;

	switch(c)
	{
	case '\n':
		row++;
		column = 0;
		break;
	case '\r':
		column = 0;
		break;
	case '\t':
		column += 4;
		break;
	default:
		vgaBuffer[row*CONSOLE_WIDTH+column] = (uint16_t)(c | 0x0700);
		column++;
		break;
	}

	if (column >= CONSOLE_WIDTH)
	{
		column = 0;
		row++;
	}
	if (row >= CONSOLE_HEIGHT)
	{
		row = 24;
		for(size_t r = 1; r < CONSOLE_HEIGHT; r++)
		{
			for (size_t c = 0; c < CONSOLE_WIDTH; c++)
			{
				vgaBuffer[(r-1)*CONSOLE_WIDTH+c] = vgaBuffer[r*CONSOLE_WIDTH+c];
			}
		}
		for (size_t c = 0; c < CONSOLE_WIDTH; c++)
		{
			vgaBuffer[CONSOLE_HEIGHT*CONSOLE_WIDTH+c] = (uint16_t)(' ' | 0x0700);
		}
	}
}

void puts(const char* str)
{
	while (*str != '\0')
	{
		putchar(*str);
		str++;
	}
}

