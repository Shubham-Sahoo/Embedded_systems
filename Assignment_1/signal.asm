MOV 30H, #0 ;values corresponds to the tangential waveform
MOV 31H, #66 
MOV 32H, #89
MOV 33H, #102
MOV 34H, #110
MOV 35H, #116
MOV 36H, #122
MOV 37H, #127
MOV 38H, #132
MOV 39H, #138
MOV 3AH, #144
MOV 3BH, #152
MOV 3CH, #165
MOV 3DH, #188
MOV 3EH, #255
MOV 3FH, #0

MOV 40H, #127 ;values corresponds to the sinusoidal waveform
MOV 41H, #176
MOV 42H, #217
MOV 43H, #245
MOV 44H, #255
MOV 45H, #245
MOV 46H, #217
MOV 47H, #176
MOV 48H, #127
MOV 49H, #78
MOV 4AH, #37
MOV 4BH, #9
MOV 4CH, #0
MOV 4DH, #9
MOV 4EH, #37
MOV 4FH, #127

CLR P0.7  ;  to enable the DAC WR
signal:
	MOV R0,#30H
	JNB p2.0,tan
	JNB p2.1,trap
	JNB p2.2,saw
	JNB p2.3,sin

vis:
	MOV R1,#10H 
loop:
	MOV A,@R0
	CLR P0.7
	MOV P1,A
	INC R0
	DJNZ R1,loop
	JMP signal

tan:
	MOV R0,#30H 
	JMP vis

trap:
	MOV R1,#0FH
	MOV A,#00H
risingval:
	CLR P0.7
	MOV P1,A
	ADD A,#11H ; increment of 17
	DJNZ R1,risingval
	MOV R1,#0FH ;stays in constant value 16 times
	MOV P1,A
	DJNZ R1,$
	MOV R1,#0FH
fallingval:
	SUBB A,#11H ;  decrement in step of 31
	MOV P1,A
	DJNZ R1,fallingval
	MOV R1,#0FH 
	MOV P1,A
	DJNZ R1,$
	JMP signal

saw:
	MOV R1,#0FH ; 15 values taken to go from 0 - 240
	MOV A,#00H
	CLR P0.7
rep:
	ADD A,#11H ;increment of 16 
	MOV P1,A
	DJNZ R1,rep
	MOV P1,#00H
	SETB P0.7
	JMP signal
 
sin:
	MOV R0,#40H
	JMP vis
