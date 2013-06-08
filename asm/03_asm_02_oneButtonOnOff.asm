/*
 * asm_02_oneButtonOnOff.asm
 *
 *  Created: 09.07.2012 16:19:57
 *   Author: EndresChristian
 */ 

.org $0000 rjmp reset

reset:
		ldi r16,high(RAMEND)	//initialisierung des stack pointers 
		out SPH,r16				//an ende des internen speichers (0x21FF)
		ldi r16,low(RAMEND)
		out SPL,r16
		
		ldi r16,0xFF			//port L als ausgansport definieren
		sts DDRL,r16
		
		ldi r17,0x00			//bei reset alle LEDs aus
		
		ldi r16,0x00			//port K als eingangsport definieren
		sts DDRK,r16
		
		ldi r16,0xFF			//pull up widerstand bei k aktivieren
		sts PORTK,r16
		
		cbi GPIOR0,0			//oder 'clt' :=merker

mainLoop:
		sts PORTL,r17			//port L := r17
		lds r16,PINK			//taster an port K bit 0 einlesen
		sbrc r16,0				//taster betätigt? port K bit 0 == 0?
		rjmp clearFlag
		rcall timeLoop			//taster entprellen
		sbis GPIOR0,0			//merker == 1?
		rjmp invertOutput
		rjmp mainLoop
invertOutput:
		sbi GPIOR0,0			//merker := 1
		sbrs r17,0				//bit 0 in r17 == 1?
		rjmp setBitNow
		cbr r17,1				//clear bit 0 in register r17
								/* cbr r17,k := r17 ^(0xFF - k)
								wert in r17 wird mit konstante verundet */
		rjmp mainLoop
setBitNow:
		sbr r17,1				//bit 0 in r17 := 1
		rjmp mainLoop
clearFlag:
		cbi GPIOR0,0			//GPIOR0 := general purpose i/o register 0; merker := 0
		rjmp mainLoop

timeLoop:
		ldi r18,0x1F
decrement1:
		ldi r19,0xFF
decrement2:
		ldi r20,0xFF
decrement3:
		dec r20
		brne decrement3
		dec r19
		brne decrement2
		dec r18
		brne decrement1
		ret
