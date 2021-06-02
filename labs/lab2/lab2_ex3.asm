;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 2, ex 3
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction
	LD R5, DEC_65_PTR 	; Base pointers
	LD R6, HEX_41_PTR
	
	LDR R3, R5, #0		; Relative pointers
	LDR R4, R6, #0		; Loads pointers with offset 0
	
	ADD R3, R3, #1		; Operation
	ADD R4, R4, #1
	
	STR R5, R3, #0		; Store relative pointers
	STR R6, R4, #0		; back to Base with offset 0
	
	HALT
	
	; Local Data
	DEC_65_PTR .FILL x4000
	HEX_41_PTR .FILL x4001
	.orig x4000
		DEC_65 .FILL #65
		HEX_41 .FILL x41
		
.END
	
