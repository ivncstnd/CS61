;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 3, ex 2
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction	
	LEA R0, INTRO
	PUTS					; Print intro
	
	LD R1, INDEX			; Load index for loop into R1
	LEA R2, ARR				; Load address of block for array into R2
	
	DO_WHILE_LOOP			; While index is > 0
		GETC				; Input char into R0
		OUT
		STR R0, R2, #0		; Store content of R0 into R2's location w/ offset 0
		ADD R2, R2, #1		; Increment memory location by 1
		
		ADD R1, R1, #-1		; Decrement index
	BRp DO_WHILE_LOOP
	
	HALT
	
	; Local Data
	INTRO	.STRINGZ	"Input 10 chars\n"
	INDEX 	.FILL		#10
	ARR		.BLKW		#10
	
.END
