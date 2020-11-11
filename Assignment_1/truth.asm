; Function realization

ORG 0
	JMP main	; Jump to main

ORG 20H	
main:			; main function
	MOV R0,#30H	; start of memory address
	MOV R3,#00H	; iterator for 16 values
	MOV R1,#00H	

loop:			; Loop for iterating the whole series
	JNB P2.0,blink	; if sw0 is pressed, go to blink function
	MOV A,R0	; else move R0 to accumulator		
	ADD A,R3	; add iteration index from R3
	MOV R1,A	; Store the memory address in R1
	MOV A,R3	; Move R3 to accumulator for printing the Inputs
	CPL A		; Complement the values in accumulator
	JNB ACC.4,finish	; If 5th bit is Low, the series is completed so jump to finish
	MOV P1,A	; else copy accumulator to P1 for displaying Inputs
	INC R3		; Increase iterator by 1
	MOV A,@R1	; Move the value stored at memory location to A
	SETB P1.4	; Make the output LED blank
	JZ loop		; If value in accumulator is zero, then go to next iteration
	CLR P1.4	; Else the value is one, so glow the output LED
	JMP loop	; Jump to the next iteration

finish:			; End function
	JMP main	; Redirects to main function

blink:			; LED Blink function
	MOV P1,#224 ; Glow first 5 LEDs. Put 11100000 in P1
	NOP			; No Operation
	MOV R5,#50	; For Delay routine
	CALL delay	; Delay call
	MOV P1,#255	; Off all the LEDs. Put 11111111 in P1
	NOP			; No Operation
	MOV R5,#50
	CALL delay	; Delay call
	JMP main	; Jump to main function, to restart the truth table realization

delay:			; Delay routine
	DJNZ R5,$	; Decrease register value and jump here until value equals zero
	RET			; return