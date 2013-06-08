/*
 * asm_02_twoButtonOnOff.asm
 *
 *  Created: 05.07.2012 18:52:29
 *   Author: EndresChristian
 */ 

.org $0000 rjmp reset

reset:
		ldi r16,high(RAMEND)
		out SPH,r16
		ldi r16,low(RAMEND)
		out SPL,r16
		ldi r16,0xFF
		sts DDRL,r16
		ldi r16,0x00
		sts PORTL,r16
		ldi r16,0x00
		sts DDRK,r16
		// pull up wiederstaende aktivieren
		ldi r16,0xFF
		sts PORTK,r16

mainloop:
		lds r16,PINK
		sbrc r16,0
		rjmp mainloop
		rcall timeLoop
		ldi r16,0xFF
		sts PORTL,r16

switchOff:
		lds r16,PINK
		sbrc r16,1
		rjmp switchOff
		rcall timeLoop
		ldi r16,0x00
		sts PORTL,r16
		rjmp mainloop

timeLoop:
		ldi r17,0x0F
decrement0:
		ldi r18,0xFF
decrement1:
		ldi r19,0xFF
decrement2:
		dec r19
		brne decrement2
		dec r18
		brne decrement1
		dec r17
		brne decrement0
		ret
