;sort data from RAM
ORG 0H
	JMP main     ; Main function

main:
	; BCD Conversion
	MOV R0,#30H  
	MOV A,@R0    ; Memory access
	MOV B,#0AH   ; 10D stored
	DIV AB       ; Divide by 10
	MOV R1,B     ; Remainder stored
	MOV B,#0AH    
	DIV AB       ; Divide by 10
	MOV R2,B     ; Remainder stored
	MOV SP,#40H
	PUSH ACC     ; Quotient pushed
	MOV A,R2	 ; 10's place stored
	RL A         ; Right shift by 4
	RL A
	RL A
	RL A
	ADD A,R1     ; 1's place added
	PUSH ACC     ; Pushed to memory

	; Palindrome check
	MOV SP,#3FH
	MOV R0,#30H
	MOV R1,#3FH
	JMP palin    ; Palindrome function
	
; Sorting initialisation
ss:
	MOV SP,#30H
	MOV R0,#10H
	MOV R1,#0FH
	MOV R5,#3FH
	
; Bubble-sort loop
ll:
	MOV SP,#30H
	MOV R1,#0FH
	DJNZ R0,sort
	MOV R0,#10H

show:			; show the sorted output on LEDs
	POP ACC		; Pop out the value to accumulator
	MOV P1,A	; Copy it to LEDs port
	INC SP		; Increase the stack by 2
	INC SP
	DJNZ R0,show ; Repeat for 16 values
	JMP $

; Bubble-sort implementation
sort:
	CLR A
	CLR C
	POP ACC 	; Pop out value to accumulator
	MOV R2,A	; Store it in register
	INC SP
	INC SP
	POP ACC		; Pop next value to accumulator
	SUBB A,R2 	; Subtract previous value
	JC swapbub	; If previous value is larger then swap
	JMP sw		; Else iterate this until last index

sw:	DEC R1		; Iteration count
	MOV A,R1
	JZ ll		; Jump to bubble-sort loop if zero
	INC SP
	JMP sort	; Else sort in the current iteration

; Swap to neighbouring indices	
swapbub:
	INC SP		; Increase stack pointer
	POP ACC		; Pop out value to accumulator
	MOV R3,A	; Store it in register
	MOV A,R2	; Move other register value to accumulator
	PUSH ACC    ; Push to memory
	DEC SP		; Decrease stack pointer twice to point to previous location
	DEC SP
	MOV A,R3    ; Move the lower value to accumulator
	PUSH ACC	; Push to memory
	JMP sw		; Jump to sorting next iteration

; Palindrome function implementation
palin:
	MOV A,#01H   ;Assuming series is palindrome 
	MOV SP,#3FH	   
	PUSH ACC     ; Push 01 to memory
	MOV A,R1	 ; Check for series completion, start index >= end index
	SUBB A,R0
	JC ss
	CLR C       
	MOV A,@R1    ; else check for equal elements from both sides
	SUBB A,@R0
	INC R0       ; Increase start index by 1
	DEC R1       ; Decrease end index by 1
	JZ palin     ; Loop back the same procedure if elements are equal
	JNZ notpalin ; Else not a palindrome
	JMP ss       ; Jump to sorting initialisation
	
; if not palindrome
notpalin:
	MOV A,#0FFH  ; Push FF to memory if not a palindrome
	MOV SP,#3FH
	PUSH ACC
	JMP ss       ; Jump to sorting initialisation
