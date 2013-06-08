/*
 * asm_05_intLightSwitch.asm
 *
 *  Created: 21.11.2012 16:40:38
 *   Author: EndresChristian
 */ 

.org $0000		jmp reset					//Reset
				jmp EXT_INT0				//Ext. Interrupt 0
				reti						//Ext. Interrupt 1
				reti						//Ext. Interrupt 2
				reti						//Ext. Interrupt 3
				reti						//Ext. Interrupt 4
				reti						//Ext. Interrupt 5
				reti						//Ext. Interrupt 6
				reti						//Ext. Interrupt 7
				reti						//Pin Change Int. 0
				reti						//Pin Change Int. 1
				reti						//Pin Change Int. 2
				reti						//Watchdog Timeout
				reti						//Timer 2 Compare A
				reti						//Timer 2 Compare B
				reti						//Timer 2 Overflow
				reti						//Timer 1 Capture
				reti						//Timer 1 Compare A
				reti						//Timer 1 Compare B
				reti						//Timer 1 Compare C
				reti						//Timer 1 Overflow
				reti						//Timer 0 Compare A
				reti						//Timer 0 Compare B
				reti						//Timer 0 Overflow
				reti						//SPI Transfer Complete
				reti						//USART 0, Rx Complete
				reti						//USART 0, UDR Empty
				reti						//USART 0, Tx Complete
				reti						//Analog Comparator
				reti						//AD Conversion Complete
				reti						//EEPROM Ready
				reti						//Timer 3 Capture
				reti						//Timer 3 Compare A
				reti						//Timer 3 Compare B
				reti						//Timer 3 Compare C
				reti						//Timer 3 Overflow
				reti						//USART 1, Rx Complete
				reti						//USART 1, UDR Empty
				reti						//USART 1, Tx Complete
				reti						//Two-Wire Serial Interface
				reti						//SPM Ready
				reti						//Timer 4 Capture
				reti						//Timer 4 Compare A
				reti						//Timer 4 Compare B
				reti						//Timer 4 Compare C
				reti						//Timer 4 Overflow
				reti						//Timer 5 Capture
				reti						//Timer 5 Compare A
				reti						//Timer 5 Compare B
				reti						//Timer 5 Compare C
				reti						//Timer 5 Overflow
				reti						//USART 2, Rx Complete
				reti						//USART 2, UDR Empty
				reti						//USART 2, Tx Complete
				reti						//USART 3, Rx Complete
				reti						//USART 3, UDR Empty
				reti						//USART 3, Tx Complete

reset:			ldi r16,high(RAMEND)
				out SPH,r16
				ldi r16,low(RAMEND)
				out SPL,r16

				ldi r16,0x00
				out DDRD,r16
				ldi r16,0xFF
				out PORTD,r16
				sts DDRL,r16

				ldi r17,0x00
				sts PORTL,r17

				clt						//1. schritt

				ldi r16,0x02			//2. schritt: ext int0 konfigurieren
				sts EICRA,r16
				ldi r16,0x01
				out EIMSK,r16

				sei						//3. schritt: interrupthandler freigeben

mainloop:		rjmp mainloop			//programm in endlosschleife

EXT_INT0:		rcall debounce
				brts switchOff
				set
				ldi r17,0xFF			//licht an
				sts PORTL,r17			//
				rjmp endINT0
switchOff:		clt
				ldi r17,0x00			//licht aus
				sts PORTL,r17			//alternativ:
										//toggln mit com r17; sts PORTL,r17
										//dann kein t register benötigt
endINT0:		reti

debounce:		ldi r19,0xFF
decrement1:		ldi r20,0xFF
decrement2:		dec r20
				brne decrement2
				dec r19
				brne decrement1
				ret
