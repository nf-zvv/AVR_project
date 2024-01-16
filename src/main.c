#include <avr/io.h>
#include <avr/interrupt.h>
#include "functions.h"

ISR(TIMER1_COMPA_vect)
{
	// сбрасываем счетчик
	TCNT1 = 0;
	// инвертируем бит (переключаем светодиод)
	PORTB ^= (1 << PB5);
}

void Timer1_Init(void)
{
	// 31250 = 500 ms /(1000/(F_CPU/256))
	OCR1A = 31250;
	// Разрешаем прерывание таймера по совпадению
	TIMSK1 = (1 << OCIE1A);
	// Предделитель 256
	TCCR1B = (1 << CS12);
}

int main(void)
{
	// ; Вывести в порт число 0xFF (255)
	PORTB = 0xFF;

	DDRB = 1 << PB5;
	PORTB = 0;

	Timer1_Init();

	// Глобальное разрешение прерываний
	sei();

	//func();

	while (1);

	return 0;
}