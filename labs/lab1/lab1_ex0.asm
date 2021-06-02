;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 1, ex 0
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction
	LEA R0, MSG_TO_PRINT
	PUTS
	
	HALT
	; Local Data
	MSG_TO_PRINT .STRINGZ "Hello World!!!!\n"
	
	
.END
