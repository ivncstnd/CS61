;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 4, ex 4
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instructions
	LD R1, Array_PTR
	LD R2, SIZE
	LD R3, START
	DO_WHILE_LOOP
		STR R3, R1, #0
		ADD R1, R1, #1
		ADD R3, R3, R3	; Bit-shift input number to the left to double
		ADD R2, R2, #-1
		BRp DO_WHILE_LOOP
		
	LD R1, Array_PTR
	LD R2, SIZE
	DO_PRINT_LOOP
		LDR R0, R1, #0	; Load R0 with index of R1 array
		OUT
		ADD R1, R1, #1	
		ADD R2, R2, #-1
		BRp DO_PRINT_LOOP
	
	HALT
	; Local Data
	START		.FILL	x1
	SIZE		.FILL	#10
	Array_PTR	.FILL	x4000
	.ORIG x4000
		.BLKW	#10
	
.END
