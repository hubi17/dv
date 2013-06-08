/*
 * _02_siebenSegmentAnz.c
 *
 * Created: 22.02.2013 17:01:57
 *  Author: EndresChristian
 */ 

#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define FOREVER while(1)
#define NO_ERROR 0

unsigned char digitDisplayed = 0;

int initIOPorts(void);
int initInterrupts(void);

ISR (INT0_vect) {
	
	_delay_ms(400);
	
	if(digitDisplayed < 9) digitDisplayed++;
}

ISR (INT1_vect) {
	
	_delay_ms(400);
	
	if(digitDisplayed > 0) digitDisplayed--;
}

int main(void) {
    
	int errorCode = NO_ERROR;
	unsigned char digit[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0xFD, 0x07, 0x7F, 0xEF};
	
	errorCode = initIOPorts();
	errorCode = initInterrupts();
	
	FOREVER {
		
		PORTB = digit[digitDisplayed];
         
    }
	
	return errorCode;
}

int initIOPorts(void) {
	
	DDRD = 0x00;
	PORTD = 0xFF;
	
	DDRB = 0xFF;
	PORTB = 0x00;
	
	return NO_ERROR;
}

int initInterrupts(void) {
	
	EICRA = 0x82;
	EIMSK = 0x03;
	sei();
	
	return NO_ERROR;
}