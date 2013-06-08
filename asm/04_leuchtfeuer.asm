/*
 * _04_leuchtfeuer.asm
 *
 *  Created: 06.11.2012 10:39:38
 *   Author: auhuberdaniel
 */ 

 .org $0000 rjmp reset

reset:
		ldi r16,high(RAMEND)	//initialisierung des stack pointers 
		out SPH,r16				//an ende des internen speichers (0x21FF)
		ldi r16,low(RAMEND)
		out SPL,r16
		
		ldi r16,0xFF			//port L als ausgangsport definieren
		sts DDRL,r16

		ldi r16,0x00			//port K als eingangsport definieren
		sts DDRK,r16
		
		ldi r16,0xFF			//pull up widerstand bei k aktivieren
		sts PORTK,r16

		clt						//merker (laufrichtung) zuruecksetzen

mainloop:
		ldi r20,0x02			//dauer der zeitschleife setzen
		rcall timeloop			//entprellen von s2
		ldi r17,0x00
		sts PORTL,r17			//LEDs ausschalten

button1:
		lds r16,PINK			//button 1 pruefen
		sbrc r16,0
		rjmp button1
		ldi r20,0x02
		rcall timeLoop		
button2:
		lds r16,PINK			//button 2 pruefen
		sbrs r16,1
		rjmp mainloop
		
		lds r16,PINK			//joystick up pruefen
		sbrs r16,3
		rcall directionNorth
		
		lds r16,PINK	
		sbrs r16,7				//joystick down pruefen
		rcall directionSouth
		
		brts south				//falls T-bit set dann richtung south sonst north

north:
		lsl r17					//weiterschalten des lauffeuers
		inc r17
		sts PORTL,r17
		ldi r20,0x03			//wartezeit fuer lauffeuer
		rcall timeloop
		cpi r17,0xFF			//pruefen ob r17 "voll" ist
		brne button2
		ldi r17,0x00
		rjmp button2

south:
		asr r17
		sbr r17,0x80
		sts PORTL,r17
		ldi r20,0x3A
		rcall timeloop
		cpi r17,0xFF
		brne button2
		ldi r17,0x00
		rjmp button2

directionNorth:
		ldi r17,0x00			//r17 zuruecksetzen
		sts PORTL,r17
		clt						//T flag anpassen
		ldi r17,0x00
		ret

directionSouth:
		ldi r17,0x00			//r17 zuruecksetzen
		sts PORTL,r17
		set						//T flag anpassen
		ldi r17,0x00
		ret

timeLoop:
		//ldi r20,0x0F
decrement0:
		ldi r18,0xFF
decrement1:
		ldi r19,0xFF
decrement2:
		dec r19
		brne decrement2
		dec r18
		brne decrement1
		dec r20
		brne decrement0
		ret