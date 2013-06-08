/*
 * asm_07_timerTonerzeugung.asm
 *
 *  Created: 15.12.2012 14:13:56
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

reset:			//init stackpointer
				ldi r16,high(RAMEND)
				out SPH,r16
				ldi r16,low(RAMEND)
				out SPL,r16

				//init input port D for external interrupt 0
				//activate pull-ups for port D 
				ldi r16,0x00
				out DDRD,r16
				ldi r16,0xFF
				out PORTD,r16
				
				//init output port 
				out DDRB,r16
				ldi r16,0x00
				out PORTB,r16

				//init state flag: T-bit
				clt

				//init external interrupt 0 control registers
				ldi r16,0x02
				sts EICRA,r16
				ldi r16,0x01
				out EIMSK,r16

				//init timer 0 control and comparator registers
				//start with timer stopped (CS02:0 == 0)
				//suppress timer 0 interrupt handling
				ldi r16,0x00
				out TCCR0B,r16
				sts TIMSK0,r16
				out TIFR0,r16
				//toggle OC0A on compare match (COM0A1:0 == 1)
				//CTC mode (WGM02:0 == 2)
				ldi r16,0b01000010
				out TCCR0A,r16
				//init OCR0A for synthesizing tone "e" (freq. around 165 Hz)
				ldi r16,46
				out OCR0A,r16

				//enable interrupt handler
				sei

mainloop:		rjmp mainloop

EXT_INT0:		rcall debounce
				brts switchOff
				set
				ldi r16,0b00000101
				out TCCR0B,r16
				reti
switchOff:		clt
				ldi r16,0b00000000
				out TCCR0B,r16
				reti

debounce:		ldi r19,0x7F
decrement1:		ldi r20,0xFF
decrement2:		dec r20
				brne decrement2
				dec r19
				brne decrement1
				ret
