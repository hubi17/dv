/*
 * asmHelloWorld.asm
 *
 *  Created: 02.07.2012 17:35:30
 *   Author: EndresChristian
 */ 
 
 .org $0000 rjmp main				//$0000 erste adresse in speicher, wird mit anweisung 'rjmp main' gefüllt
 
 // main wird nur einmal durchlaufen nach RESET
 main:
			//diese init von stack muss immer vorgenommen werden
			//ramadressen sind 16bit lang
			//high byte in register laden
			//danach low byte
			ldi	r16,high(RAMEND)	//Stack-Initialisierung
			out	SPH,r16				//Vorbelegen des High- und
			ldi	r16,low(RAMEND)		//des Low-Bytes des
			out SPL,r16				//Stack-Pointers
									//Stack liegt am Ende des Datenspeicherbereichs

			ldi	r16,255				//wert 255 in register r16 speichern
			STS DDRL,r16			//wert aus register r16 in sram an ddrl speichern
									//DDR = data direction register
									//DDRL = port L
									//definieren alles pins von port L als ausgangsport
									//durch DDRL = 11111111

			ldi r16,0				//wert 0 in register r16 speichern
			STS PORTL,r16			//wert aus register r16 in portl laden
									//initialisierung aller pinausgänge auf NULL schalten

			ldi r17,0				//wert 0 in register r17 speichern
			STS DDRK,r17			//wert aus register r17 in ddrk laden
									//definiere port k ganz als eingangsport

			ldi r17,0xFF			//pull up widerstand aktivieren
			sts PORTK,r17			//"

// hauptprogramm in endlosschleife
mainLoop:
			ldi r16,0				//wert 0 in register r16 speichern
			LDS r17,PINK			//wert aus PINK (eingagnssignal von port k) in register r17 speichern
									//lesen der eingangspins am port K
			sbrs r17,0				//zeile überspringen falls bit nr '0' von register 'r17' gesetzt ist
									//(pruefe taster an port K, pin 0 auf betaetigung)
			ldi r16,1				//wert 1 in register r16 speichern
			STS PORTL,r16			//wert aus register r16 auf port L legen - steuert led an
			rjmp mainLoop			//sprung zurück an label "mainLoop"
