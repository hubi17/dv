/*
 * praxis01_ka.asm
 *
 *  Created: 26.01.2013 17:15:18
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

reset:			//init stack pointer
				ldi r16,high(RAMEND)
				out SPH,r16
				ldi r16,low(RAMEND)
				out SPL,r16

				//init I/O ports
				ldi r16,0x00
				sts DDRK,r16
				out DDRD,r16
				ldi r16,0xFF
				out PORTD,r16
				sts PORTK,r16
				sts DDRL,r16
				//init light bar, starting state OFF
				ldi r17,0x00
				sts PORTL,r17

				//init state of light bar ON/OFF
				clt
				//init light bar state when ON (direction DOWN, lightBar STOPPED)
				ldi r18,0x00

				//init external interrupt 0, falling edge
				ldi r16,0x02
				sts EICRA,r16
				ldi r16,0x01
				out EIMSK,r16
				//enable interrupt handler
				sei

				//ensure that CARRY cleared
				clc

mainloop:		//idle if T-bit cleared (light bar OFF)
				brtc mainloop
				
				//joystick polling
				lds r16,PINK
				//STOP/RUN
				sbrs r16,5
				rcall lightBarSTOP
				//UP
				sbrs r16,3
				rcall changeDirUP
				//DOWN
				sbrs r16,7
				rcall changeDirDOWN

				//light bar STOPPED?
				cpi r18,0x00
				breq mainloop

				//light bar RUNNING, direction UP
				cpi r18,0x03
				breq dirUP
				
				//light bar RUNNING, direction DOWN
				cpi r17,0x01
				brne normalDOWN
				ldi r17,0x80
				sts PORTL,r17
				ldi r19,0x5A
				rcall debounce
				rjmp mainloop

normalDOWN:		ror r17
				sts PORTL,r17
				ldi r19,0x5A
				rcall debounce
				rjmp mainloop

dirUP:			cpi r17,0x80
				brne normalUP
				ldi r17,0x01
				sts PORTL,r17
				ldi r19,0x5A
				rcall debounce
				rjmp mainloop

normalUP:		lsl r17
				sts PORTL,r17
				ldi r19,0x5A
				rcall debounce
				rjmp mainloop

changeDirUP:	ldi r18,0x03
				ret
changeDirDOWN:	ldi r18,0x01
				ret
lightBarSTOP:	ldi r18,0x00
				ret


EXT_INT0:		ldi r19,0x01
				rcall debounce
				brts switchOff
				set
				ldi r17,0x01
				sts PORTL,r17
				ldi r18,0x00
				reti
switchOff:		clt
				ldi r17,0x00
				sts PORTL,r17
				ldi r18,0x00		
				reti

debounce:		ldi r20,0xAF
decrement1:		ldi r21,0xFF
decrement2:		dec r21
				brne decrement2
				dec r20
				brne decrement1
				dec r19
				brne debounce
				ret

