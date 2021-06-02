;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 3, ex 1
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction
	LD R1, DATA_PTR	; Load R1 with contents of x4000
	
	LDR R2, R1, #0	; Load Relative R2 with contents of R1
	ADD R2, R2, #1	; Add 1 to R2
	STR R2, R1, #0	; Store content of R2 back into R1's pointer
	
	ADD R1, R1, #1	; Increment to x4001
	
	LDR R3, R1, #0	; Repeat
	ADD R3, R3, #1
	STR R3, R1, #0
	
	HALT
	
	; Local Data
	DATA_PTR .FILL x4000
	.ORIG x4000
		DEC_65 .FILL #65
		HEX_41 .FILL x41
		
.END
