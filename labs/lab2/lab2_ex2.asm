;=================================================
; Name: Ivan Castaneda
; Email:  icast016@ucr.edu
; 
; Lab: lab 2, ex 2
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction
	LDI R3, DEC_65_PTR
	LDI R4, HEX_41_PTR 
	
	ADD R3, R3, #1
	ADD R4, R4, #1
	
	STI R3, DEC_65_PTR
	STI R4, HEX_41_PTR
	
	HALT
	
	; Local Data
	DEC_65_PTR .FILL x4000
	HEX_41_PTR .FILL x4001
	.orig x4000
		; Local Data
		DEC_65 .FILL #65
		HEX_41 .FILL x41
		
.END
