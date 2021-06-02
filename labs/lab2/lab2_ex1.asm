;=================================================
; Name: Ivan Castaneda; 
; Email: icast016@ucr.edu
; Lab: lab 2. ex 1
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction
	LD R3, DEC_65
	LD R4, HEX_41
	HALT
	
	; Local Data
	DEC_65 .FILL #65
	HEX_41 .FILL x41

.END
