/*
 * _04_adcPWMDimmer.c
 *
 * Created: 18.04.2013 17:38:38
 *  Author: EndresChristian
 */ 

#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>

#define FOREVER while(1)
#define NO_ERROR 0

int initIOPorts(void);
int initADC(void);
int initTimer(void);
int initInterrupts(void);

char adResult = 0x80;

ISR(TIMER0_OVF_vect) {
	// top wert des timers anpassen
	// sollte in der isr geschehen
	OCR0A = adResult;
}

int main(void) {

	int error = NO_ERROR;

	error = initIOPorts();
	error = initADC();
	error = initTimer();
	error = initInterrupts();


	FOREVER {

		ADCSRA |= 0x40;
		while(ADCSRA & 0x40) {}
		adResult = ADCH;

		// mindestens 32 als ergebnis festlegen
		// ergebnis wird als top wert fuer timer benutzt
		if(adResult < 32) adResult = 32;

	}

	return error;
}

int initIOPorts(void) {

	DDRB = 0xFF;
	PORTB = 0x00;

	DDRF = 0x00;
	PORTF = 0xFF;

	return NO_ERROR;
}

int initADC(void) {

	ADMUX = 0x60;
	ADCSRB &= 0xF7;
	ADCSRA = 0x87;
	DIDR0 = 0x01;

	return NO_ERROR;
}

int initTimer(void) {

	TCCR0A = 0x83;
	TCCR0B = 0x04;
	OCR0A = 0x80;

	return NO_ERROR;
}

int initInterrupts(void) {

	TIMSK0 = 0x01;
	sei();

	return NO_ERROR;
}
