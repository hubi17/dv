/*
 * _01_lightBar.c
 *
 * Created: 12.02.2013 13:38:00
 *  Author: EndresChristian
 */ 

#define F_CPU 16000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define FOREVER while(1)
#define NO_ERROR 0
#define OFF 0x00
#define STOP 0x01
#define UP 0x02
#define DOWN 0x03

unsigned char lightBar = 0x00;
unsigned char lightBarState = OFF;

unsigned char initIOPorts(void);
unsigned char initSREGFlags(void);
unsigned char initInterrupts(void);

unsigned char pollJoystickSignals(unsigned char);

ISR (INT0_vect) {
	_delay_ms(200);
	if(lightBarState == OFF) {
		lightBar = 0x01;
		lightBarState = STOP;
	}
	else {
		lightBar = 0x00;
		lightBarState = OFF;
	}
}

int main(void) {
	
	unsigned char errorCode = NO_ERROR;

	//initialization
	errorCode = initIOPorts();
	errorCode = initSREGFlags();
	errorCode = initInterrupts();
		
    FOREVER {
		
		if(lightBarState != OFF) {
			
			lightBarState = pollJoystickSignals(lightBarState);
		
			switch(lightBarState) {
				
				case UP:	if(lightBar == 0x80) lightBar = 0x01;
							else lightBar <<= 1;
							break;
						
				case DOWN:	if(lightBar == 0x01) lightBar = 0x80;
							else lightBar >>= 1;
							break;
						
				default:	break;
			}
		
			_delay_ms(300);
        
		}
		
		PORTL = lightBar;
	}
		
	return errorCode;
}

unsigned char initIOPorts(void) {
	
	DDRD = 0x00;
	PORTD = 0xFF;
	
	DDRK = 0x00;
	PORTK = 0xFF;
	
	DDRL = 0xFF;
	PORTL = 0x00;
	
	return NO_ERROR;
}

unsigned char initSREGFlags(void) {
	
	SREG = (0<<SREG_C);
	
	return NO_ERROR;
}

unsigned char initInterrupts(void) {
	
	EICRA = 0x02;
	EIMSK = 0x01;
	sei();
	
	return NO_ERROR;
}

unsigned char pollJoystickSignals(unsigned char state) {
	
	unsigned char joystickState = state;
	
	if(!(PINK&0x20)) joystickState = STOP;
	else if (!(PINK&0x08)) joystickState = UP;
	else if (!(PINK&0x80)) joystickState = DOWN;
	
	return joystickState;	
}			
