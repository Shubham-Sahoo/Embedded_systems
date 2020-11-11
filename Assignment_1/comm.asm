main:
	CLR SM0
	SETB SM1
	SETB REN
	MOV A, PCON	
	SETB ACC.7	
	MOV PCON, A	

	MOV TMOD, #20H		
	MOV TH1, #243
	MOV TL1, #243
	SETB TR1	

	MOV 40H, #'s'	
	MOV 41H, #'h'		
	MOV 42H, #'u'	
	MOV 43H, #'b'	
	MOV 44H, #'h'
	MOV 45H, #'a'
	MOV 46H, #'m'
	MOV 47H, #' '
	MOV 48H, #'s'
	MOV 49H, #'a'
	MOV 4AH, #'h'
	MOV 4BH, #'o'
	MOV 4CH, #'o'

	MOV 4DH, #0		
	MOV R0, #40H		

again :
	MOV A, @R0		
	JZ read	
	MOV SBUF, A		
	INC R0			
	JNB TI, $		
	CLR TI		
	JMP again		
	
read:
	MOV R1, #30H	
loop:
	JNB RI, $		
	CLR RI			
	MOV A, SBUF		
	CJNE A, #0DH, skip
	JMP finish		

skip:
	MOV @R1, A		
	INC R1			
	JMP loop		
finish:
	JMP $			