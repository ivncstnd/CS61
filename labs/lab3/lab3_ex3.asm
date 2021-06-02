;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 3, ex 3
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction	
	LEA R0, INTRO					
	PUTS
	
	LD R1, INDEX			
	LEA R2, ARR				
	
	DO_WHILE_IN_LOOP			; Input into array
		GETC				
		OUT
		STR R0, R2, #0		
		ADD R2, R2, #1					
		
		ADD R1, R1, #-1		
		BRp DO_WHILE_IN_LOOP
	END_DO_WHILE_IN_LOOP
	
	LD R1, INDEX				; Reset index
	LEA R2, ARR					; Reset array
	
	DO_WHILE_OUT_LOOP
		LDR R0, R2, #0			; Load R0 with content from address of R2		
		OUT						; Print newline
		
		LEA R0, NEWLINE
		PUTS					; Print newline
		
		ADD R2, R2, #1			; Increment address location
		ADD R1, R1, #-1			; Decrement index
		BRp DO_WHILE_OUT_LOOP
	END_DO_WHILE_OUT_LOOP
	
	HALT
	
	; Local Data
	INTRO	.STRINGZ	"Input 10 chars\n"
	NEWLINE	.STRINGZ	"\n"
	INDEX 	.FILL		#10
	ARR		.BLKW		#10
	
.END

	
