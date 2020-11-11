ORG 0
	JMP main
ORG 3
	JMP ext0ISR
ORG 0BH
	JMP timer0ISR
ORG 1BH
	JMP timer1ISR

ORG 30H			
main:
	MOV DPL, #LOW(LEDcodes)
	MOV DPH, #HIGH(LEDcodes)
	SETB IT0
	SETB EX0
	MOV TMOD, #17	
	MOV TH0, #11  
	MOV TL0, #220	
	MOV TH1, #11 
	MOV TL1, #220
	MOV R1,#0
	MOV R2,#0
	MOV R3,#0
	MOV R4,#0
	SETB TR0	
	SETB ET0	 
	;SETB TR1	
	;SETB ET1	 
	SETB EA
	CLR F0
show:
	JB F0,showst
	MOV A,R1
	MOV B,#0AH   ; 10D stored
	DIV AB       ; Divide by 10
	MOV R5,B     ; Remainder stored
	MOV B,#0AH    
	DIV AB       ; Divide by 10
	MOV R6,B     ; Remainder stored
	MOV A,R6	 ; 10's place stored
	MOVC A, @A+DPTR
	CLR P3.4	
	SETB P3.3
	MOV P1, A
	CALL delay
	
	MOV A,R5     ; 1's place added
	MOVC A, @A+DPTR
	CLR P3.3	
	CLR P3.4
	MOV P1, A
	CALL delay

	MOV A,R2
	MOV B,#0AH   ; 10D stored
	DIV AB       ; Divide by 10
	MOV R5,B     ; Remainder stored
	MOV B,#0AH    
	DIV AB       ; Divide by 10
	MOV R6,B     ; Remainder stored
	MOV A,R6	 ; 10's place stored
	MOVC A, @A+DPTR
	SETB P3.3	
	SETB P3.4
	MOV P1, A
	CALL delay

	MOV A,R5     ; 1's place added
	MOVC A, @A+DPTR
	CLR P3.3	
	SETB P3.4
	MOV P1, A
	CALL delay

	JMP show			

showst:
	JNB F0,show
	MOV A,R3
	MOV B,#0AH   ; 10D stored
	DIV AB       ; Divide by 10
	MOV R5,B     ; Remainder stored
	MOV B,#0AH    
	DIV AB       ; Divide by 10
	MOV R6,B     ; Remainder stored
	MOV A,R6	 ; 10's place stored
	MOVC A, @A+DPTR
	CLR P3.4	
	SETB P3.3
	MOV P1, A
	CALL delay
	
	MOV A,R5     ; 1's place added
	MOVC A, @A+DPTR
	CLR P3.3	
	CLR P3.4
	MOV P1, A
	CALL delay

	MOV A,R4
	MOV B,#0AH   ; 10D stored
	DIV AB       ; Divide by 10
	MOV R5,B     ; Remainder stored
	MOV B,#0AH    
	DIV AB       ; Divide by 10
	MOV R6,B     ; Remainder stored
	MOV A,R6	 ; 10's place stored
	MOVC A, @A+DPTR
	SETB P3.3	
	SETB P3.4
	MOV P1, A
	CALL delay

	MOV A,R5     ; 1's place added
	MOVC A, @A+DPTR
	CLR P3.3	
	SETB P3.4
	MOV P1, A
	CALL delay

	JMP showst

delay:
	MOV R0, #100
	DJNZ R0, $
	RET

ext0ISR:
	CLR P3.7
	JB P2.0,swo 
	JNB P2.0,sw1
	SETB P3.7	
	RETI	
swo:
	SETB TR1	
	SETB ET1	 
	SETB EA
	INC R3
	MOV A,R3
	SUBB A,#60
	JNC min2
	RETI
min2:
	INC R4
	MOV R3,#0
	RETI	
	RETI
sw1:
	CLR TR1	
	CLR ET1	
	MOV TH1, #11 
	MOV TL1, #220
	MOV R3,#0
	MOV R4,#0
	RETI


timer0ISR:
	CLR P3.6
	SETB P3.6
	INC R1
	MOV A,R1
	SUBB A,#60
	JNC min    ; Previous JZ, miss error 
	;SETB P3.7
	JNB P2.1,on
	JB P2.1,off
	RETI
min:
	INC R2
	MOV R1,#0
	;MOV DPL, #LOW(LEDcodes)
	;MOV DPH, #HIGH(LEDcodes)
	RETI

timer1ISR:
	SETB P3.7
	JNB P2.1,on
	JB P2.1,off
	RETI
on:		
	SETB F0
	RETI

off:
	CLR F0
	RETI

LEDcodes:	; | this label points to the start address of the 7-segment code table which is 
		; | stored in program memory using the DB command below
	DB 11000000B, 11111001B, 10100100B, 10110000B, 10011001B, 10010010B, 10000010B, 11111000B, 10000000B, 10010000B
