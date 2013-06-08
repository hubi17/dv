/* Bier h
 * asmHelloWorld.asm
 *
 *  Created: 02.07.2012 17:35:30
 *   Author: EndresChristian
 */ 
 
.org $0000 rjmp main
 
//Initialisierung (wird nur einmal nach RESET durchlaufen)
main:
			ldi	r16,high(RAMEND)	//Stack-Initialisierung
			out	SPH,r16				//Vorbelegen des High- und
			ldi	r16,low(RAMEND)		//des Low-Bytes des
			out SPL,r16				//Stack-Pointers

//DDR(L): Data Direction Register für Port L
			ldi	r16,255				//Definiere PORTL ganz als Ausgangsport
			STS DDRL,r16			//mit DDRL=1111 1111 oder DDRL=0xFF

			ldi r16,0				//PORTL = 0x00: Schalte alle LED's
			STS PORTL,r16			//an PORTL aus

			ldi r17,0				//Definiere PORTK ganz als Eingangsport
			STS DDRK,r17			//mit DDRK=0000 0000 oder DDRK=0x00

//Hauptprogramm in Endlosschleife
mainLoop:
			ldi r16,0				
			LDS r17,PINK			//Lesen der Eingangspins am PORTK
			sbrs r17,0				//Prüfe Taster an PORTK, Pin 0 auf Betätigung
			ldi r16,1				//Falls Taster betätigt, steuere LED an
			STS PORTL,r16			//PORTL, Pin 0 an
			rjmp mainLoop
