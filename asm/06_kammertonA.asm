/*
 * asm_06_kammertonA.asm
 *
 *  Created: 01.12.2012 17:44:35
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
				out DDRA,r16
				ldi r16,0x00
				out PORTA,r16
				clt

				ldi r16,0x02
				sts EICRA,r16
				ldi r16,0x01
				out EIMSK,r16

				sei

mainloop:		brtc mainloop					//1 clock-cycle, if T-Bit cleared
				com r16							//1 clock-cycle
				out PORTA,r16					//1 clock-cycle
				rcall halfPeriod				//4 clock-cycles
				rjmp mainloop					//2 clock-cycles

halfPeriod:		ldi r17,96						//1 clock-cycle
halfPeriod1:	nop								//96 * 1 clock-cycles
				ldi r18,92						//96 * 1 clock-cycles
halfPeriod2:	dec r18							//96 * 92 * 1 clock-cycles
				brne halfPeriod2				//96 * ((92-1) * 1 + 1 * 2) clock-cycles
				dec r17							//96 * 1 clock-cycle
				brne halfPeriod1				//((96-1) * 1 + 1 * 2) clock-cycles
				ret								//5 clock-cycles

EXT_INT0:		rcall debounce
				brts switchOff
				set
				reti
switchOff:		clt
				reti

debounce:		ldi r19,0xFF
decrement1:		ldi r20,0xFF
decrement2:		dec r20
				brne decrement2
				dec r19
				brne decrement1
				ret

