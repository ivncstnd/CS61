;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 1, ex 1
; Lab section: 021
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instructions
	AND R1,R1,x0		; Rather than copying 0 from memory, we can 
	LD R2,DEC_12		; use bitwise operator 'AND' and decimal 0's hex 
	LD R3,DEC_6			; x0000 to set any stored bit to 0 in process.

	DO_WHILE_LOOP
			ADD R1,R1,R2
			ADD R3,R3,#-1
			BRp DO_WHILE_LOOP
	END_DO_WHILE_LOOP
	HALT
	
	; Local Data
	DEC_12	.FILL #12
	DEC_6	.FILL #6
	DEC_0	.FILL #0
	
	
.END
	
