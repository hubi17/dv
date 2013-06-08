/*
 * _03_adWandlungPoti.c
 *
 * Created: 10.04.2013 17:20:47
 *  Author: EndresChristian
 */ 

#define F_CPU 16000000UL

#include <avr/io.h>

#define FOREVER while(1)
#define NO_ERROR 0

int initIOPorts(void);
int initADC(void);

int main(void) {
    
	int errorCode = NO_ERROR;
	
	unsigned char digit[9] = {0x40, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0xFD, 0x07, 0x7F};
	unsigned char digitDisplayed = 0;
	unsigned char adResult = 0x00;
	
	errorCode = initIOPorts();
	errorCode = initADC();
	
	PORTB = digit[digitDisplayed];
	
	FOREVER {
		
		// start converion bit setzen
		ADCSRA |= 0x40;
		// warten bis bit wieder zurueckgesetzt ist
		while(ADCSRA & 0x40) {}
		
		// ergebnis der umwandlung abholen
		adResult = ADCH;
		
		if(adResult > 252) digitDisplayed = 0;
		else if (adResult > 221) digitDisplayed = 1;
		else if (adResult > 190) digitDisplayed = 2;
		else if (adResult > 159) digitDisplayed = 3;
		else if (adResult > 128) digitDisplayed = 4;
		else if (adResult > 97) digitDisplayed = 5;
		else if (adResult > 66) digitDisplayed = 6;
		else if (adResult > 35) digitDisplayed = 7;
		else digitDisplayed = 8;
		
		PORTB = digit[digitDisplayed];
         
    }
	
	return errorCode;
}

int initIOPorts(void) {
	
	DDRF = 0x00;
	PORTF = 0xFF;
	
	DDRB = 0xFF;
	PORTB = 0x00;
	
	return NO_ERROR;
}

int initADC(void) {
	
	ADMUX = 0x60;
	ADCSRB &= 0xF7;
	ADCSRA = 0x87;
	DIDR0 = 0x01;
	
	return NO_ERROR;
}
