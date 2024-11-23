
	PROCESSOR 16F84A
	RADIX DEC
	ERRORLEVEL -302 ;remove Message about using proper bank
	ERRORLEVEL -203 ;remove Message Found opcode in column 1
	LIST
; P16F84A.INC  Standard Header File, Version 2.00    Microchip Technology, Inc.
	NOLIST

; This header file defines configurations, registers, and other useful bits of
; information for the PIC16F84 microcontroller.  These names are taken to match
; the data sheets as closely as possible.

; Note that the processor must be selected before this file is
; included.  The processor may be selected the following ways:

;       1. Command line switch:
;               C:\ MPASM MYFILE.ASM /PIC16F84A
;       2. LIST directive in the source file
;               LIST   P=PIC16F84A
;       3. Processor Type entry in the MPASM full-screen interface

;==========================================================================
;
;       Revision History
;
;==========================================================================

;Rev:   Date:    Reason:

;1.00   2/15/99 Initial Release

;==========================================================================
;
;       Verify Processor
;
;==========================================================================

        IFNDEF __16F84A
           MESSG "Processor-header file mismatch.  Verify selected processor."
        ENDIF

;==========================================================================
;
;       Register Definitions
;
;==========================================================================

W                            EQU     H'0000'
F                            EQU     H'0001'

;----- Register Files------------------------------------------------------

INDF                         EQU     H'0000'
TMR0                         EQU     H'0001'
PCL                          EQU     H'0002'
STATUS                       EQU     H'0003'
FSR                          EQU     H'0004'
PORTA                        EQU     H'0005'
PORTB                        EQU     H'0006'
EEDATA                       EQU     H'0008'
EEADR                        EQU     H'0009'
PCLATH                       EQU     H'000A'
INTCON                       EQU     H'000B'

OPTION_REG                   EQU     H'0081'
TRISA                        EQU     H'0085'
TRISB                        EQU     H'0086'
EECON1                       EQU     H'0088'
EECON2                       EQU     H'0089'

;----- STATUS Bits --------------------------------------------------------

IRP                          EQU     H'0007'
RP1                          EQU     H'0006'
RP0                          EQU     H'0005'
NOT_TO                       EQU     H'0004'
NOT_PD                       EQU     H'0003'
Z                            EQU     H'0002'
DC                           EQU     H'0001'
C                            EQU     H'0000'

;----- INTCON Bits --------------------------------------------------------

GIE                          EQU     H'0007'
EEIE                         EQU     H'0006'
T0IE                         EQU     H'0005'
INTE                         EQU     H'0004'
RBIE                         EQU     H'0003'
T0IF                         EQU     H'0002'
INTF                         EQU     H'0001'
RBIF                         EQU     H'0000'

;----- OPTION_REG Bits ----------------------------------------------------

NOT_RBPU                     EQU     H'0007'
INTEDG                       EQU     H'0006'
T0CS                         EQU     H'0005'
T0SE                         EQU     H'0004'
PSA                          EQU     H'0003'
PS2                          EQU     H'0002'
PS1                          EQU     H'0001'
PS0                          EQU     H'0000'

;----- EECON1 Bits --------------------------------------------------------

EEIF                         EQU     H'0004'
WRERR                        EQU     H'0003'
WREN                         EQU     H'0002'
WR                           EQU     H'0001'
RD                           EQU     H'0000'

;==========================================================================
;
;       RAM Definition
;
;==========================================================================

        __MAXRAM H'CF'
        __BADRAM H'07', H'50'-H'7F', H'87'

;==========================================================================
;
;       Configuration Bits
;
;==========================================================================

_CP_ON                       EQU     H'000F'
_CP_OFF                      EQU     H'3FFF'
_PWRTE_ON                    EQU     H'3FF7'
_PWRTE_OFF                   EQU     H'3FFF'
_WDT_ON                      EQU     H'3FFF'
_WDT_OFF                     EQU     H'3FFB'
_LP_OSC                      EQU     H'3FFC'
_XT_OSC                      EQU     H'3FFD'
_HS_OSC                      EQU     H'3FFE'
_RC_OSC                      EQU     H'3FFF'

        LIST


;Setup of PIC configuration flags
;XT oscillator
;Disable watch dog timer
;Enable power up timer
;Disable code protect
__CONFIG 3FF1H

; variabili da "ritoccare"
Countdown EQU 11111111B ; 255
ra0 EQU 1
ra1 EQU 2
;LCD Control lines
LCD_RS EQU 2			;Register Select
LCD_E EQU 3			;Enable
;LCD data line bus
LCD_DB4 EQU 4			;LCD data line DB4
LCD_DB5 EQU 5			;LCD data line B5
LCD_DB6 EQU 6			;LCD data line DB6
LCD_DB7 EQU 7			;LCD data line DB7


; memoria allocata
ORG 0CH
; Memoria per i calcoli. DIGITx devono avere indirizzi contigui
REGA0 RES 1			;lsb
REGA1 RES 1
REGA2 RES 1
REGA3 RES 1			;msb
REGB0 RES 1			;lsb
REGB1 RES 1
REGB2 RES 1
REGB3 RES 1			;msb
REGC0 RES 1			;lsb
REGC1 RES 1
REGC2 RES 1
REGC3 RES 1			;msb
DSIGN RES 1			;Digit Sign. 0=positive,1=negative
DIGIT1 RES 1			;MSD
DIGIT2 RES 1
DIGIT3 RES 1
DIGIT4 RES 1
DIGIT5 RES 1			;Decimal (BCD) digits
DIGIT6 RES 1
DIGIT7 RES 1
DIGIT8 RES 1
DIGIT9 RES 1
DIGIT10 RES 1			;LSD
MTEMP RES 1
MCOUNT RES 1
DCOUNT RES 1
Count1 RES 1 			; usato per calcolare la frequenza
Count2 RES 1 			; usato per sapere se si puo' procedere al calcolo della frequenza (1)
			; oppure bisogna grabbarla (0)
Count3 RES 1			; usato per salvare TMR0 durante il calcolo
Count4 RES 1			; usato da Moltiplica per moltiplicare
Count5 RES 1			; usato per stampare il valore della frequenza
tmpLcdRegister RES 2 		; used by LCD subroutines
msDelayCounter RES 2 		; used by msDelay subroutine and DELAY macro
TmpRegister RES 1
xCurPos RES 1			; Cursor location
yCurPos RES 1
putTempReg RES 1

;===============================================================================================================
;	INIZIO PROGRAMMA
;
;Reset Vector - Punto di inizio del programma al reset della CPU
ORG 00H
	goto Start

; interrupt handler
ORG 04H		; 5 stack pos (6) + 1 per l'interrupt
btfsc Count2,0
goto caseFrequencyGrab		; Count2,0 = 1
;	goto caseCalculate		; Count2,0 = 0
caseCalculate
movf TMR0,W			; sposta il valore di TMR0 nel registro temporaneo Count3
movwf Count3
bsf Count2,0			; segnare che il valore di TMR0 dopo questo passo e' invalido e va
			; resettato al prossimo interrupt da parte del segnale di clock in arrivo su RB0
call CalcolaFrequenza		; calcola il valore della frequenza
call PrintValue			; una volta calcolato bisogna stampare sul display il valore trovato...
movlw 1			; metti in W un valore non nullo per evitare l'overflow di TMR0 [v. FreqLoop]
goto endie			; poi attendere il prossimo interrupt
caseFrequencyGrab
clrf TMR0			; setta i valori di TMR0 e Count1 come da reset
movlw Countdown
movwf Count1
bcf Count2,1			; resetta anche Count2,1 cosi' da poter iniziare al primo ciclo
bcf Count2,0			; resetta Count2 --> si puo' procedere di nuovo con il grab
;	goto endie			; poi torna dall'interrupt
endie
bcf INTCON,INTF			; riabilita l'interrupt sulla porta RB0
retfie					; qundo tutto e' stato fatto ritorna dall'interrupt


Start		; 4 stack pos (5)
	bsf STATUS,RP0			; Commuta sul secondo banco dei registri

; Definizione delle linee di I/O (0=Uscita, 1=Ingresso)
	movlw 00011111B	
	movwf TRISA
;*****  eventualmente...  *****
;	movlw 11111111B ;Set PORTB lines
;	movwf TRISB
;	bcf PORTB,LCD_DB4 ;Set as output just the LCD's lines
;	bcf PORTB,LCD_DB5
;	bcf PORTB,LCD_DB6
;	bcf PORTB,LCD_DB7
;	bcf PORTB,LCD_E
;	bcf PORTB,LCD_RS
	movlw 11000000B			; setta la porta B
	movwf TRISB
	movlw 00000100B			; Assegna il PRESCALER a TMR0 e lo configura a 1:32
	movwf OPTION_REG
	bcf STATUS,RP0			; Commuta sul primo banco dei registri

	movlw 10010000B			; abilita l'interrupt (1xxxxxxx) in particolare quello su RB0 (xxx1xxxx)
	movwf INTCON			; disabilita gli altri (x00x0xxx) e resetta quelli precedenti (xxxxx000)
	call LcdInit			; LCD inizialization
	call PrintInitScreen		; stampa il nome del progettista =)
	bsf Count2,0		; dopo il reset deve aspettare 2 interrupt prima di calcolare la frequenza!
	bsf Count2,1			; ma soprattutto il primo (che potrebbe non arrivare!)!!!
noFreqLoop
	btfsc Count2,1
	goto noFreqLoop		; Count2,1 =1 --> situazione iniziale. aspetta il primo segnale di interrupt
					; Count2,1 = 0 --> primo interrupt arrivato, si comincia!
	call Frequency			; Lettura della frequenza
	call OutOfRange			; Se il PC punta qua allora forse siamo fuori range...
	btfss Count2,2			; se =1 allora siamo fuori range!...
	goto noFreqLoop			; se =0 allora c'e' ancora speranza!
	sleep				; ...intanto meglio spegnere tutto

; 4Mhz / 4 / 2-256 = 500.000-3906.25 Hz
; ... divisa per 256 dal TMR0 500.000-3906.25 / 256 = 1953.125-15.258789 Hz
; ... e per 256 dal contatore Count1 1953.125-15.258789 / 256 = 7.6293945-0.05960464Hz

; subroutine di grab della frequenza
Frequency
;	clrf TMR0	i primi 3 comandi non servono piu'!!!
;	movlw Countdown			; Il registro Count viene inizializzato a 255 in quanto il suo scopo e'
;	movwf Count1			; tener memoria del tempo trascorso.
				; se questo tempo supera il limite massimo la subroutine esce e stampa a display
				; un messaggio di errore di overflow.
FreqLoop
	btfsc Count2,0			; se Count2 e' settato allora aspetta il prossimo clock esterno...
	movwf TMR0			; ...quindi per non andare in overflow setta TMR0 con il valore
				; impostato dalla routine di interrupt (valore in W)
	movf TMR0,W			; se TMR0 vale 0 (ha fatto 256 cicli)
	btfss STATUS,Z			; allora vai oltre
	goto FreqLoop 			; altrimenti aspetta ancora...

	clrf TMR0			; reimposta TMR0,
	decfsz Count1,F			; decrementa Count1
	goto FreqLoop			; e continua l'attesa
return					; se il contatore e' pieno allora siamo fuori scala!!!

; subroutine per il calcolo della frequenza
;	prende in input da Count3 il valore di TMR0 e da Count1 l'overflow di TMR0
;	rende il valore in output nel registro Count3
CalcolaFrequenza	; 2 stack pos
	movlw 0DH			; sposta il cursore nella posizione del PS
	call LcdLocate
	movf Count1,W			; trova il valore effettivo di Count1
	sublw Countdown
	movwf Count1			; e salvalo in Count1 (intanto l'interrupt e' disabilitato)
; F=(Fosc/4)*PS*(1/Count1TMR0) (*MOLT)
	movlw 01000000B			; REGA = 00000000 00001111 01000010  01000000B = 10^6 (=Fosc/4)
	movwf REGA0
	movlw 01000010B
	movwf REGA1
	movlw 00001111B
	movwf REGA2
	clrf REGA3
	movf Count1,W			; metti il valore di Count1 nel registro REGB1
	movwf REGB1
	movf Count3,W			; metti il valore di TMR0 nel registro REGB0
	movwf REGB0
	clrf REGB2			; e pulisci i registri superiori
	clrf REGB3
	call divide			; (Fosc/4)/Count1TMR0
	; secondo passo dividere per il prescaler
	; metti in REGBx il valore in binario del prescaler leggendolo dal registro di stato
	bsf STATUS,RP0			; Commuta sul secondo banco dei registri
	movf OPTION_REG,W		; copia il valore del prescaler (e non solo) in Count4
	bcf STATUS,RP0			; ritorna sul primo banco dei registri
	movwf Count4
	btfsc Count4,2			; determina il valore del prescaler
	goto Ps32to256			; se il prescaler e' 1xx allora e' >16
Ps2to16					; 0xx
	btfss Count4,1
	goto Ps2to4
	goto Ps8to16
Ps32to256				; 1xx
	btfss Count4,1
	goto Ps32to64
	goto Ps128to256
Ps2to4					; 00x
	btfss Count4,0
	goto Ps2
	goto Ps4
Ps8to16					; 01x
	btfss Count4,0
	goto Ps8
	goto Ps16
Ps32to64				; 10x
	btfss Count4,0
	goto Ps32
	goto Ps64
Ps128to256				; 11x
	btfss Count4,0
	goto Ps128
	goto Ps256

Ps2	movlw 30H			; 0
	call LcdSendData
	movlw 30H			; 0
	call LcdSendData
	movlw 32H			; 2
	call LcdSendData
	movlw 00000010B			; se e' 2 metti il valore 2 in REGBx
	movwf REGB0
	goto endPs
Ps4	movlw 30H			; 0
	call LcdSendData
	movlw 30H			; 0
	call LcdSendData
	movlw 34H			; 4
	call LcdSendData
	movlw 00000100B			; se e' 4 metti il valore 4 in REGBx
	movwf REGB0
	goto endPs
Ps8	movlw 30H			; 0
	call LcdSendData
	movlw 30H			; 0
	call LcdSendData
	movlw 38H			; 8
	call LcdSendData
	movlw 00001000B			; se e' ...
	movwf REGB0
	goto endPs
Ps16	movlw 30H			; 0
	call LcdSendData
	movlw 31H			; 1
	call LcdSendData
	movlw 36H			; 6
	call LcdSendData
	movlw 00010000B
	movwf REGB0
	goto endPs
Ps32	movlw 30H			; 0
	call LcdSendData
	movlw 33H			; 3
	call LcdSendData
	movlw 32H			; 2
	call LcdSendData
	movlw 00100000B
	movwf REGB0
	goto endPs
Ps64	movlw 30H			; 0
	call LcdSendData
	movlw 36H			; 6
	call LcdSendData
	movlw 34H			; 4
	call LcdSendData
	movlw 01000000B
	movwf REGB0
	goto endPs
Ps128	movlw 31H			; 1
	call LcdSendData
	movlw 32H			; 2
	call LcdSendData
	movlw 38H			; 8
	call LcdSendData
	movlw 10000000B
	movwf REGB0
	goto endPs
Ps256	movlw 32H			; 2
	call LcdSendData
	movlw 35H			; 5
	call LcdSendData
	movlw 36H			; 6
	call LcdSendData
	clrf REGB0			; se e' 256 i registri da modificare sono 2...
	movlw 00000001B
	movwf REGB1
	goto endPs256
endPs
	clrf REGB1			; ...negli altri casi il secondo e' zero
endPs256
	clrf REGB2			; il resto di REGB va a 0
	clrf REGB3
	call divide			; REGA / REGB -> REGA == ((Fosc/4)/Count1TMR0)/PS
	movf Count1,F			; verifica il valore in Count1 ed eventualmente modifica il PS
	btfsc STATUS,Z
	call MovePSminus
	movf REGA1,F			; verifica il valore in REGA2 (65536+) ed eventualmente modifica il PS
	btfsc STATUS,Z
	call MovePSplus
return

; subroutine per la stampa a display del valore della frequenza
;	prende in input dal registro REGAx il valore da stampare
PrintValue		; 4 stack pos (5)
	call PrintZero
	; call MOLT
MOLT		; subroutine per la rilevazione del moltiplicatore esterno
	clrf Count5
	btfss PORTA,ra1			; determinazione del moltiplicatore
	goto MOLT0to2
;	goto MOLTto42
MOLTto42
	btfss PORTA,ra0
	goto MOLTto4
;	goto MOLT2
MOLT2					; RA0=1, RA1=1	== ',' spostata a sx 2 posti
	bsf Count5,7
	movlw 07H			; sposta il cursore nella posizione del moltiplicatore
	call LcdLocate
	movlw 2BH			; +
	call LcdSendData
	movlw 32H			; 2
	call LcdSendData
	movlw 1BH			; sposta il cursore nella posizione del primo zero
	call LcdLocate
	movlw 2CH			; ,
	call LcdSendData
	movlw 30H
	call LcdSendData
	call LcdSendData
	movlw 1AH			; sposta ora il cursore alla cifra - significativa
	movwf Count1 ;######### BOH!?!?
	goto vondeMOLT
MOLTto4					; RA0=0, RA1=1	== ',' spostata a dx 4 posti
				; == agguingere 4 zeri e shiftare a sx il valore
	bsf Count5,2
	movlw 07H			; sposta il cursore nella posizione del moltiplicatore
	call LcdLocate
	movlw 2DH			; -
	call LcdSendData
	movlw 34H			; 4
	call LcdSendData
	movlw 1AH
	call LcdLocate
	movlw 30H
	call LcdSendData
	call LcdSendData
	call LcdSendData
	call LcdSendData
	movlw 19H			; sposta ora il cursore alla cifra - significativa
	movwf Count1
	goto vondeMOLT
MOLT0to2
	btfss PORTA,ra0
	goto MOLT0
;	goto MOLTto2
MOLTto2					; RA0=1, RA1=0	== ',' spostata a dx 2 posti 
				; == agguingere 2 zeri e shiftare a sx il valore
	bsf Count5,1
	movlw 07H			; sposta il cursore nella posizione del moltiplicatore
	call LcdLocate
	movlw 2DH			; -
	call LcdSendData
	movlw 32H			; 2
	call LcdSendData
	movlw 1CH			; sposta il cursore nella posizione del primo zero
	call LcdLocate
	movlw 30H
	call LcdSendData
	call LcdSendData
	movlw 1BH			; sposta ora il cursore alla cifra - significativa
	movwf Count1
	goto vondeMOLT
MOLT0					; RA0=0, RA1=0	== ',' non spostata
	bsf Count5,0
	movlw 07H			; sposta il cursore nella posizione del moltiplicatore
	call LcdLocate
	movlw 2BH			; +
	call LcdSendData
	movlw 30H			; 0
	call LcdSendData
	movlw 1DH			; sposta ora il cursore alla cifra - significativa
	movwf Count1
vondeMOLT
	call LcdLocate
; return --- end MOLT

PRINTFREQ		; subroutine per la stampa delle cifre a display
	movlw DIGIT10			; puntatore alle cifre
	movwf FSR
	call bin2dec			; in REGAx c'e' ancora il valore della frequenza
	btfsc Count5,7
	goto PosExp			; il moltiplicatore e' 10^2
	; goto Neg0Exp
Neg0Exp	btfsc Count5,0
	goto noneMore2go		; il moltiplicatore e' 0
	; goto negExp
NegExp	btfsc Count5,1
	goto twoMore2go
	; goto fourMore2go
fourMore2go movlw 4			; i valori sono -1 perche' si parte da 0
	goto beginPrintFreq
twoMore2go movlw 6			; per colpa di 'decfsz Count5'
	goto beginPrintFreq
PosExp					; stampa i primi 2 valori e poi passa sotto
	movf INDF,W			; prima cifra
	addlw 0x30			; valore da sommare per i caratteri ASCII
	call LcdSendData
	movlw 1CH			; metti a posto il cursore
	call LcdLocate
	decf FSR,F			; sposta il cursore sulle cifre
	movf INDF,W			; seconda cifra
	addlw 0x30			; valore da sommare per i caratteri ASCII
	call LcdSendData
	movlw 1AH			; metti a posto il cursore
	movwf Count1
	call LcdLocate
	movlw 5
	goto beginPrintFreq
noneMore2go
	movlw 8
beginPrintFreq				; a questo punto il cursore e' nella posizione 
				; corretta in tutti e 4 i casi (v. MOLT)
	movwf Count5			; ora Count5 diventa un contatore per finire di stampare
PFloop
	movf INDF,W			; cifra puntata da FSR
	addlw 0x30			; valore da sommare per i caratteri ASCII
	call LcdSendData
	decf Count1,W			; valore del puntatore sul display
	movwf Count1			; va salvato altrimenti scrive sempre nella stessa posizione
	call LcdLocate
	decf FSR,F			; sposta il puntatore alla cifra successiva
	decfsz Count5,F
	goto PFloop
; return --- end PRINTFREQ

; stampa il valore del prescaler presente in DIGIT 8 - 9 - 10
	movf REGB0,W			; sposta il valore del prescaler nel registro REGAx
	movwf REGA0
	movf REGB1,W
	movwf REGA1
	clrf REGA2
	clrf REGA3
	call bin2dec			; e converti in decimale tale valore
	movlw 2				; numero di iterazioni (3)
	movwf Count5
	movlw DIGIT8			; puntatore alle cifre
	movwf FSR
	movlw 0DH
PPSloop
	call LcdLocate
	movf INDF,W			; cifra puntata da FSR
	addlw 0x30			; valore da sommare per i caratteri ASCII
	call LcdSendData
	incf FSR,F			; sposta il puntatore alla cifra successiva
	decfsz Count5,F
	goto PPSloop
return

; subroutine per la modifica del prescaler al valore immediatamente inferiore di divisione 1/2^(PS0-1)
MovePSminus
	bsf STATUS,RP0			; Commuta sul secondo banco dei registri
	movf OPTION_REG,W		; metti il valore del prescaler in W
	decfsz W,W			; decrementa il valore di OPTION_REG: se era = 00H diventera' FFH
	btfsc W,6		; quindi un qualsiasi bit sara' settato e quindi non si puo decrementare
	goto OptionRegClear		; non se ne fa nulla...
	decf OPTION_REG,F		; diminuisci il valore del prescaler di 1
	bcf STATUS,RP0			; Commuta sul primo banco dei registri
	bcf Count2,2			; operazione terminata con successo
    return
OptionRegClear
	bcf STATUS,RP0			; Commuta sul primo banco dei registri
	bsf Count2,2			; operazione non riuscita, PS = 1/2 (000)
return


; subroutine per la modifica del prescaler al valore immediatamente superiore di divisione 1/2^(PS0+1)
MovePSplus
	bsf STATUS,RP0			; Commuta sul secondo banco dei registri
	movf OPTION_REG,W		; metti il valore del prescaler in W
	incfsz W,W			; incrementa il valore di OPTION_REG: se era = 03H diventera' 04H
	btfsc W,3		; quindi il quarto bit sara' settato e quindi non si puo incrementare
	goto OptionRegSet		; non se ne fa nulla...
	incf OPTION_REG,F		; aumenta il valore del prescaler di 1
	bcf STATUS,RP0			; Commuta sul primo banco dei registri
	bcf Count2,2			; operazione terminata con successo
    return
OptionRegSet
	bcf STATUS,RP0			; Commuta sul primo banco dei registri
	bsf Count2,2			; operazione non riuscita, PS = 1/256 (111)
return


;*** 32 BIT SIGNED MULTIPLY ***
;REGA * REGB -> REGA
;Return carry set if overflow
multiply	; 1 stack pos
	clrf	MTEMP		;Reset sign flag
	call	absa		;Make REGA positive
	btfss STATUS,C		;skpc
	call	absb		;Make REGB positive
	btfsc STATUS,C		;skpnc
	return			;Overflow
	call	movac		;Move REGA to REGC
	call	clra		;Clear product
	movlw	D'31'		;Loop counter
	movwf	MCOUNT
muloop	call	slac		;Shift left product and multiplicand
	rlf	REGC3,w		;Test MSB of multiplicand
	btfsc STATUS,C		;skpnc		;If multiplicand bit is a 1 then
	call	addba		;add multiplier to product
	btfss STATUS,C		;skpc		;Check for overflow
	rlf	REGA3,w
	btfsc STATUS,C		;skpnc
	return
	decfsz	MCOUNT,F	;Next
	goto	muloop
	btfsc	MTEMP,0		;Check result sign
	call	negatea		;Negative
	return

;*** 32 BIT SIGNED DIVIDE ***
;REGA / REGB -> REGA
;Remainder in REGC
;Return carry set if overflow or division by zero
divide		; 1 stack pos
	clrf	MTEMP		;Reset sign flag
	movf	REGB0,w		;Trap division by zero
	iorwf	REGB1,w
	iorwf	REGB2,w
	iorwf	REGB3,w
	sublw	0
	btfss STATUS,C		;skpc
	call	absa		;Make dividend (REGA) positive
	btfss STATUS,C		;skpc
	call	absb		;Make divisor (REGB) positive
	btfsc STATUS,C		;skpnc
	return			;Overflow
	clrf	REGC0		;Clear remainder
	clrf	REGC1
	clrf	REGC2
	clrf	REGC3
	call	slac		;Purge sign bit
	movlw	D'31'		;Loop counter
	movwf	MCOUNT
dvloop	call	slac		;Shift dividend (REGA) msb into remainder (REGC)
	movf	REGB3,w		;Test if remainder (REGC) >= divisor (REGB)
	subwf	REGC3,w
	btfss STATUS,Z		;skpz
	goto	dtstgt
	movf	REGB2,w
	subwf	REGC2,w
	btfss STATUS,Z		;skpz
	goto	dtstgt
	movf	REGB1,w
	subwf	REGC1,w
	btfss STATUS,Z		;skpz
	goto	dtstgt
	movf	REGB0,w
	subwf	REGC0,w
dtstgt	btfss STATUS,C		;skpc		;Carry set if remainder >= divisor
	goto	dremlt
	movf	REGB0,w		;Subtract divisor (REGB) from remainder (REGC)
	subwf	REGC0,f
	movf	REGB1,w
	btfss STATUS,C		;skpc
	incfsz	REGB1,w
	subwf	REGC1,f
	movf	REGB2,w
	btfss STATUS,C		;skpc
	incfsz	REGB2,w
	subwf	REGC2,f
	movf	REGB3,w
	btfss STATUS,C		;skpc
	incfsz	REGB3,w
	subwf	REGC3,f
	bcf STATUS,C		;clrc
	bsf	REGA0,0		;Set quotient bit
dremlt	decfsz	MCOUNT,F	;Next
	goto	dvloop
	btfsc	MTEMP,0		;Check result sign
	call	negatea		;Negative
	return

;*** 32 BIT SIGNED BINARY TO DECIMAL ***
;REGA -> DIGITS 1 (MSD) TO 10 (LSD) & DSIGN
;DSIGN = 0 if REGA is positive, 1 if negative
;Return carry set if overflow
;Uses FSR register
bin2dec		; 1 stack pos
	clrf	MTEMP		;Reset sign flag
	call	absa		;Make REGA positive
	btfsc STATUS,C		;skpnc
	return			;Overflow
	call	clrdig		;Clear all digits
	movlw	D'32'		;Loop counter
	movwf	MCOUNT
b2dloop	rlf	REGA0,f		;Shift msb into carry
	rlf	REGA1,f
	rlf	REGA2,f
	rlf	REGA3,f
	movlw	DIGIT10
	movwf	FSR		;Pointer to digits
	movlw	D'10'		;10 digits to do
	movwf	DCOUNT
adjlp	rlf	INDF,f		;Shift digit and carry 1 bit left
	movlw	D'10'
	subwf	INDF,w		;Check and adjust for decimal overflow
	btfsc STATUS,C		;skpnc
	movwf	INDF
	decf	FSR,f		;Next digit
	decfsz	DCOUNT,F
	goto	adjlp
	decfsz	MCOUNT,F	;Next bit
	goto	b2dloop
	btfsc	MTEMP,0		;Check sign
	bsf	DSIGN,0		;Negative
	bcf STATUS,C		;clrc
	return


;**********************************************************************
; Init LCD
; This subroutine must be called before each other lcd subroutine
;**********************************************************************
LcdInit		; 3 stack pos
	movlw 30 ;Wait 30 ms
	call msDelay
	bcf PORTB,LCD_RS ;Set LCD command mode
	bsf PORTB,LCD_DB4 ;Send a reset sequence to LCD
	bsf PORTB,LCD_DB5
	bcf PORTB,LCD_DB6
	bcf PORTB,LCD_DB7
	bsf PORTB,LCD_E ;Enables LCD
	movlw 5 ;Wait 5 ms
	call msDelay
	bcf PORTB,LCD_E ;Disables LCD
	movlw 1 ;Wait 1ms
	call msDelay
	bsf PORTB,LCD_E ;Enables LCD
	movlw 1 ;Wait 1ms
	call msDelay
	bcf PORTB,LCD_E ;Disables LCD
	movlw 1 ;Wait 1ms
	call msDelay
	bsf PORTB,LCD_E ;Enables E
	movlw 1 ;Wait 1ms
	call msDelay
	bcf PORTB,LCD_E ;Disables E
	movlw 1 ;Wait 1ms
	call msDelay
	bcf PORTB,LCD_DB4
	bsf PORTB,LCD_DB5
	bcf PORTB,LCD_DB6
	bcf PORTB,LCD_DB7
	bsf PORTB,LCD_E ;Enables LCD
	movlw 1 ;Wait 1ms
	call msDelay
	bcf PORTB,LCD_E ;Disabled LCD
	movlw 1 ;Wait 1ms
	call msDelay
;Set 4 bit data bus length
	movlw 28H;
	bcf PORTB,LCD_RS
	call LcdSendByte
;Entry mode set, increment, no shift
	movlw 06H;
	bcf PORTB,LCD_RS
	call LcdSendByte
;Display ON, Curson ON, Blink OFF
	movlw 0EH
	bcf PORTB,LCD_RS
	call LcdSendByte
;Clear display
	call LcdClear
return
;**********************************************************************
; Clear LCD
;**********************************************************************
LcdClear	; 2 stack pos
	clrf xCurPos	; riposiziona il cursore ad inizio display
	clrf yCurPos
	movlw 01H ;Clear display
	bcf PORTB,LCD_RS
	call LcdSendByte
	movlw 2 ;Wait 2 ms
	call msDelay
	movlw 80H ;DD RAM address set 1st digit
	bcf PORTB,LCD_RS
	call LcdSendByte
return
;**********************************************************************
; Put a char to xCurPos, yCurPos position on LCD
; W = Char to show
; xCurPos = x position
; yCurPos = y position
; xCurPos and yCurPos will be increase automaticaly
;**********************************************************************
putchar		; 2 stack pos (4)
	movwf putTempReg
	swapf yCurPos,W
	iorwf xCurPos,W
	call LcdLocate
	movf putTempReg,W
	call LcdSendData
	incf xCurPos,F
	movlw 16
	xorwf xCurPos,W
	btfss STATUS,Z
	goto moveLcdCursor
	clrf xCurPos
	incf yCurPos,F
	movlw 2
	xorwf yCurPos,W
	btfss STATUS,Z
	goto moveLcdCursor
	clrf yCurPos
moveLcdCursor
	swapf yCurPos,W
	iorwf xCurPos,W
;	call LcdLocate
;return
;**********************************************************************
; Locate cursor on LCD
; W = D7-D4 row, D3-D0 col
;**********************************************************************
LcdLocate	; 1 stack pos (3)
	movwf tmpLcdRegister+0
	movlw 80H
	movwf tmpLcdRegister+1
	movf tmpLcdRegister+0,W
	andlw 0FH
	iorwf tmpLcdRegister+1,F
	btfsc tmpLcdRegister+0,4
	bsf tmpLcdRegister+1,6
	movf tmpLcdRegister+1,W
	bcf PORTB,LCD_RS
	goto LcdSendByte	; il return di LcdSendByte prende il posto di questo!!
;	call LcdSendByte
;return
;**********************************************************************
; Send a data to LCD
;**********************************************************************
LcdSendData	; 1 stack pos (2)
	bsf PORTB,LCD_RS
;	call LcdSendByte	; se LcdSendByte e' contiguo non DOVREBBE servire un'ulteriore chiamata!
;return
;**********************************************************************
; Send a byte to LCD by 4 bit data bus
;**********************************************************************
LcdSendByte	; 1 stack pos
;Save value to send
	movwf tmpLcdRegister
;Send highter four bits
	bcf PORTB,LCD_DB4
	bcf PORTB,LCD_DB5
	bcf PORTB,LCD_DB6
	bcf PORTB,LCD_DB7
	btfsc tmpLcdRegister,4
	bsf PORTB,LCD_DB4
	btfsc tmpLcdRegister,5
	bsf PORTB,LCD_DB5
	btfsc tmpLcdRegister,6
	bsf PORTB,LCD_DB6
	btfsc tmpLcdRegister,7
	bsf PORTB,LCD_DB7
	bsf PORTB,LCD_E ;Enables LCD
	movlw 1 ;Wait 1ms
	call msDelay
	bcf PORTB,LCD_E ;Disabled LCD
	movlw 1 ;Wait 1ms
	call msDelay
;Send lower four bits
	bcf PORTB,LCD_DB4
	bcf PORTB,LCD_DB5
	bcf PORTB,LCD_DB6
	bcf PORTB,LCD_DB7
	btfsc tmpLcdRegister,0
	bsf PORTB,LCD_DB4
	btfsc tmpLcdRegister,1
	bsf PORTB,LCD_DB5
	btfsc tmpLcdRegister,2
	bsf PORTB,LCD_DB6
	btfsc tmpLcdRegister,3
	bsf PORTB,LCD_DB7
	bsf PORTB,LCD_E ;Enables LCD
	movlw 1 ;Wait 1ms
	call msDelay
	bcf PORTB,LCD_E ;Disabled LCD
	movlw 1 ;Wait 1ms
;	call msDelay
;return
;**********************************************************************
; Delay subroutine
;
; W = Requested delay time in ms (clock = 4MHz)
;**********************************************************************
msDelay
	movwf msDelayCounter+1
	clrf msDelayCounter+0
; 1 ms (about) internal loop
msDelayLoop
	nop
	decfsz msDelayCounter+0,F
	goto msDelayLoop
	nop
	decfsz msDelayCounter+1,F
	goto msDelayLoop
return



;UTILITY ROUTINES
;Add REGB to REGA (Unsigned)
addba	movf	REGB0,w		;Add lo byte
	addwf	REGA0,f

	movf	REGB1,w		;Add mid-lo byte
	btfsc STATUS,C		;skpnc		;No carry_in, so just add
	incfsz	REGB1,w		;Add carry_in to REGB
	addwf	REGA1,f		;Add and propagate carry_out

	movf	REGB2,w		;Add mid-hi byte
	btfsc STATUS,C		;skpnc
	incfsz	REGB2,w
	addwf	REGA2,f

	movf	REGB3,w		;Add hi byte
	btfsc STATUS,C		;skpnc
	incfsz	REGB3,w
	addwf	REGA3,f
return

;Move REGA to REGC
movac	movf	REGA0,w
	movwf	REGC0
	movf	REGA1,w
	movwf	REGC1
	movf	REGA2,w
	movwf	REGC2
	movf	REGA3,w
	movwf	REGC3
return

;Clear REGB and REGA
clrba	clrf	REGB0
	clrf	REGB1
	clrf	REGB2
	clrf	REGB3
;Clear REGA
clra	clrf	REGA0
	clrf	REGA1
	clrf	REGA2
	clrf	REGA3
return

;Check sign of REGA and convert negative to positive
absa	rlf	REGA3,w
	btfss STATUS,C		;skpc
return				;Positive

;Negate REGA
negatea	movf	REGA3,w		;Save sign in w
	andlw	0x80
	comf	REGA0,f		;2's complement
	comf	REGA1,f
	comf	REGA2,f
	comf	REGA3,f
	incfsz	REGA0,f
	goto	nega1
	incfsz	REGA1,f
	goto	nega1
	incfsz	REGA2,f
	goto	nega1
	incf	REGA3,f
nega1
	incf	MTEMP,f		;flip sign flag
	addwf	REGA3,w		;Return carry set if -2147483648
return

;Check sign of REGB and convert negative to positive
absb	rlf	REGB3,w
	btfss STATUS,C		;skpc
return				;Positive

;Negate REGB
negateb	movf	REGB3,w		;Save sign in w
	andlw	0x80
	comf	REGB0,f		;2's complement
	comf	REGB1,f
	comf	REGB2,f
	comf	REGB3,f
	incfsz	REGB0,f
	goto	negb1
	incfsz	REGB1,f
	goto	negb1
	incfsz	REGB2,f
	goto	negb1
	incf	REGB3,f
negb1
	incf	MTEMP,f		;flip sign flag
	addwf	REGB3,w		;Return carry set if -2147483648
return

;Shift left REGA and REGC
slac	rlf	REGA0,f
	rlf	REGA1,f
	rlf	REGA2,f
	rlf	REGA3,f
slc	rlf	REGC0,f
	rlf	REGC1,f
	rlf	REGC2,f
	rlf	REGC3,f
return

;Set all digits to 0
clrdig	clrf	DSIGN
	clrf	DIGIT1
	clrf	DIGIT2
	clrf	DIGIT3
	clrf	DIGIT4
	clrf	DIGIT5
	clrf	DIGIT6
	clrf	DIGIT7
	clrf	DIGIT8
	clrf	DIGIT9
	clrf	DIGIT10
return

; subroutine che stampa i caratteri di contorno ai dati significativi
PrintZero	; 3 stack pos (4)
	call LcdClear			; pulisce il display e posiziona il cursore
	movlw H'004D'			; M
	call putchar
	movlw H'006F'			; o
	call putchar
	movlw H'006C'			; l
	call putchar
	movlw H'0074'			; t
	call putchar
	movlw H'0031'			; 1
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'005E'			; ^
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0050'			; P
	call putchar
	movlw H'0053'			; S
	call putchar
	movlw H'0031'			; 1
	call putchar
	movlw H'002F'			; /
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0031'			; 1
	call putchar

	movlw H'0046'			; F
	call putchar
	movlw H'0072'			; r
	call putchar
	movlw H'0065'			; e
	call putchar
	movlw H'0071'			; q
	call putchar
	movlw H'003D'			; =
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0060'			; 0
	call putchar
	movlw H'0060'			; 0
	call putchar
	movlw H'0060'			; 0
	call putchar
	movlw H'0050'			; 0
	call putchar
	movlw H'0048'			; H
	call putchar
	movlw H'007A'			; z
	call putchar
	bsf Count2,3			; un valore valido e' stato trovato e quindi non cancellare il display
return

; subroutine di stampa a display della schermata iniziale
PrintInitScreen	; 3 stack pos (4)
	call LcdClear			; pulisce il display e posiziona il cursore
	movlw H'00A2'			;
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'007E'			; ->
	call putchar
	movlw H'007E'			; ->
	call putchar
	movlw H'00DA'			; V
	call putchar
	movlw H'00E0'			; A
	call putchar
	movlw H'00D5'			; L
	call putchar
	movlw H'00AE'			; E
	call putchar
	movlw H'007F'			; <-
	call putchar
	movlw H'007F'			; <-
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar

	movlw H'0020'			; spazio
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'004E'			; N
	call putchar
	movlw H'006F'			; o
	call putchar
	movlw H'0076'			; v
	call putchar
	movlw H'0065'			; e
	call putchar
	movlw H'0032'			; 2
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0030'			; 0
	call putchar
	movlw H'0035'			; 5
	call putchar
	movlw H'006D'			; m
	call putchar
	movlw H'0062'			; b
	call putchar
	movlw H'0061'			; a
	call putchar
	movlw H'0052'			; R
	call putchar
	movlw H'0034'			; 4
	call putchar
	movlw H'00A3'			;
	call putchar
return

; subroutine di errore
OutOfRange	; 3 stack pos (4)
	clrf TMR0			; setta i valori di TMR0 e Count1 come da reset
	movlw Countdown
	movwf Count1
	bcf Count2,0			; resetta anche Count2,1 cosi' da poter reiniziare il grab
	bcf Count2,1
	call MovePSplus		; se va in overflow rallenta il PS 1 volta sola per ciclo per evitare confusione
	bsf Count2,1			; cosi' al ritorno ricomincia come dopo un reset
	btfss Count2,2		; con il caso Count2,2
	return				; Count2,2 = 0 --> il prescaler e' stato cambiato con successo
				; Count2,2 =1 --> il PS non puo' essere cambiato. Stampa il msg di errore
	btfsc Count2,3
	return				; Count2,3 = 1 --> c'e' un valore sul display, non cancellare!
	call LcdClear			; Count2,3 = 0 --> nessun valore trovato. cancella tutto, ERRORE!!
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'007E'			; ->
	call putchar
	movlw H'007E'			; ->
	call putchar
	movlw H'00DA'			; V
	call putchar
	movlw H'00E0'			; A
	call putchar
	movlw H'00D5'			; L
	call putchar
	movlw H'00AE'			; E
	call putchar
	movlw H'007F'			; <-
	call putchar
	movlw H'007F'			; <-
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar

	movlw H'0020'			; spazio
	call putchar
	movlw H'004F'			; O
	call putchar
	movlw H'0055'			; U
	call putchar
	movlw H'0054'			; T
	call putchar
	movlw H'0076'			; spazio
	call putchar
	movlw H'0065'			; spazio
	call putchar
	movlw H'004F'			; O
	call putchar
	movlw H'0046'			; F
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0020'			; spazio
	call putchar
	movlw H'0052'			; R
	call putchar
	movlw H'0041'			; A
	call putchar
	movlw H'004E'			; N
	call putchar
	movlw H'0047'			; G
	call putchar
	movlw H'0045'			; E
	call putchar
	movlw H'0020'			; spazio
	call putchar
return

END
