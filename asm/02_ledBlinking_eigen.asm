/*
 * ledBlinking.asm
 *
 *  Created: 02.10.2012 11:47:59
 *   Author: auhuberdaniel
 */ 

 .org $0000 rjmp main

 main:
			//diese init von stack muss immer vorgenommen werden
			//ramadressen sind 16bit lang
			//high byte in register laden
			//danach low byte
			ldi	r16,high(RAMEND)	//Stack-Initialisierung
			out	SPH,r16				//Vorbelegen des High- und
			ldi	r16,low(RAMEND)		//des Low-Bytes des
			out SPL,r16
			ldi r16, 0xFF
			sts DDRL,r16
			ldi r16,0x00
			sts PORTL,r16

mainloop:
			ldi r16,0x01
			sts PORTL,r16
			rcall timeloop
			ldi r16,0x00
			sts PORTL,r16
			rcall timeloop
			rjmp mainloop

timeloop:
			ldi r17,0x3F
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

