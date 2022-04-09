#include <avr/io.h>
#include <util/delay.h>

void func(void)
{
	for (;;)
	{
		asm("NOP");
		PORTB = 1 << PB5;
		_delay_ms(500);
		PORTB &= ~(1 << PB5);
		_delay_ms(500);
	}
}