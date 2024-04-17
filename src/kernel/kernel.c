#include "drivers/tty.h"
#include "drivers/keyboard.h"

void kernel_main(void)
{
	cls();

	puts("Hello from CanoOS!\n");
	puts("JS bad BTW\n\n");
	puts("> ");
	while (1)
	{
		char c = getc();
		putchar(c);
	}
}

