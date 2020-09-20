;sort data from RAM
ORG 0H
	JMP main

ORG 20H
main:
	MOV SP,#3FH
	MOV R0,#30H
	MOV R1,#3FH
	JMP palin
ss:
	MOV SP,#30H
	MOV R0,#10H
	MOV R1,#0FH
	MOV R5,#3FH
	
ll:
	MOV SP,#30H
	MOV R1,#0FH
	DJNZ R0,sort
	JMP $

;ORG 50H
sort:
	CLR A
	CLR C
	POP ACC
	MOV R2,A
	INC SP
	INC SP
	POP ACC
	SUBB A,R2
	JC swapbub
	JMP sw
sw:	DEC R1
	MOV A,R1
	JZ ll
	INC SP
	JMP sort
	
;ORG 60H
swapbub:
	INC SP
	POP ACC
	MOV R3,A
	MOV A,R2
	PUSH ACC 
	DEC SP
	DEC SP
	MOV A,R3
	PUSH ACC
	;INC SP
	JMP sw

palin:
	MOV A,#01H
	MOV SP,#3FH
	PUSH ACC
	MOV A,R1
	SUBB A,R0
	JC ss
	CLR C
	MOV A,@R1
	SUBB A,@R0
	INC R0
	DEC R1
	JZ palin
	JNZ notpalin
	JMP ss
	

notpalin:
	MOV A,#0FFH
	MOV SP,#3FH
	PUSH ACC
	JMP ss


