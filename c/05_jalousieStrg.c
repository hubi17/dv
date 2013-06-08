/*
 * _05_jalousieStrg.c
 *
 * Created: 02.05.2013 16:46:43
 *  Author: EndresChristian
 * 
 * Zuordnungsliste:
 *  S1	PORTH.Pin0	snapshotOfInputs.Bit0		Auswahlschalter AUTO <--> MANUAL == 1 <--> 0
 *  B1	PORTH.Pin6	snapshotOfInputs.Bit6		Endlage TOP (NC)
 *  B2	PORTH.Pin7	snapshotOfInputs.Bit7		Endlage BOTTOM (NC)
 *	S2	PORTK.Pin1	snapshotOfInputs.Bit1		Tippbetrieb UP
 *	S3	PORTK.Pin2	snapshotOfInputs.Bit2		Tippbetrieb DOWN
 *
 */ 

#include <avr/io.h>

#define FOREVER while(1)

#define STOP 0
#define TOP 1
#define BOTTOM 2
#define UP 3
#define DOWN 4

#define BIT_ACO 0x20
#define S1 0x01
#define B1 0x40
#define B2 0x80
#define S2 0x02
#define S3 0x04

int initIOPorts(void);
int initAC(void);
void selectInitialState(unsigned char *);
void snapshotOfInputs(unsigned char *);
void switchMotor(unsigned char);

int main(void) {
	
	int errorCode = 0;
	unsigned char state = STOP;
	unsigned char snapshot = 0x00;
	
	errorCode = initIOPorts();
	errorCode = initAC();
	
	switchMotor(STOP);
	selectInitialState(&state);
	
    FOREVER {
		
		snapshotOfInputs(&snapshot);
				
		if(snapshot & S1) {
			//Automatikbetrieb
			switch(state) {
				
				case BOTTOM:
					switchMotor(STOP);
					if(!(snapshot & BIT_ACO)) state = UP;
					break;
					
				case TOP:
					switchMotor(STOP);
					if(snapshot & BIT_ACO) state = DOWN;
					break;
					
				case UP:
					switchMotor(UP);
					if(!(snapshot & B1)) state = TOP;
					break;
						
				case DOWN:
					switchMotor(DOWN);
					if(!(snapshot & B2)) state = BOTTOM;
					break;
					
				case STOP:
					if(!(snapshot & BIT_ACO)) state = UP;
					else state = DOWN;
					break;
				
			}
		}
		else {
			//Manueller Betrieb
			switch(state) {
				
				case BOTTOM:
					switchMotor(STOP);
					if(!(snapshot & S2)) state = UP;
					break;
				
				case TOP:
					switchMotor(STOP);
					if(!(snapshot & S3)) state = DOWN;
					break;
				
				case UP:
					switchMotor(UP);
					if(!(snapshot & B1)) state = TOP;
					else if(snapshot & S2) state = STOP;
					break;
					
				case DOWN:
					switchMotor(DOWN);
					if(!(snapshot & B2)) state = BOTTOM;
					else if(snapshot & S3) state = STOP;
					break;
					
				case STOP:
					switchMotor(STOP);
					if(!(snapshot & S2)) state = UP;
					else if(!(snapshot & S3)) state = DOWN;
					break;
			
			}					
		}				
        
    }
	
	return 0;
}

int initIOPorts(void) {
	
	DDRL = 0xFF;
	PORTL = 0x00;
	
	DDRH = 0x00;
	PORTH = 0xFF;
	DDRK = 0x00;
	PORTK = 0xFF;
	DDRE = 0x00;
	PORTE = 0xFF;
	
	return 0;
}

int initAC(void) {
	
	ADCSRB &= 0xBF;
	ACSR = 0x00;
	DIDR1 = 0x03;
	return 0;
}

void selectInitialState(unsigned char *state) {
	
	unsigned char senseSwitches = PINH & 0xC0;
	
	if(senseSwitches == 0x80) *state = TOP;
	else if(senseSwitches == 0x40) *state = BOTTOM;
	else *state = STOP;
	
}

void snapshotOfInputs(unsigned char *snapshot) {

	unsigned char tempSnapshot = 0x00;
	*snapshot = 0x00;	
	
	tempSnapshot = PINH & 0xC1;
	*snapshot |= tempSnapshot;
	
	tempSnapshot = PINK & 0x06;
	*snapshot |= tempSnapshot;
	
	tempSnapshot = ACSR & BIT_ACO;
	*snapshot |= tempSnapshot;
	
}

void switchMotor(unsigned char mode) {
	
	if(mode == UP) PORTL = 0x02;
	else if(mode == DOWN) PORTL = 0x01;
	else PORTL = 0x00;
	
}
