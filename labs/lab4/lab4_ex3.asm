;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 4, ex 3
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
		ADD R3, R3, R3
		ADD R2, R2, #-1
		BRp DO_WHILE_LOOP
		
	LD R1, Array_PTR
	LDR R2, R1, #6
	
	HALT
	; Local Data
	START		.FILL	#1
	SIZE		.FILL	#10
	Array_PTR	.FILL	x4000
	.ORIG x4000
		.BLKW	#10
	
.END
