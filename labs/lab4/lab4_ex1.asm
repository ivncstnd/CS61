;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 4, ex 1
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instructions
	LD R1, Array_PTR
	LD R2, SIZE
	LD R4, START
	
	DO_WHILE_LOOP
		STR R4, R1, #0	; Store start num into array
		ADD R4, R4, #1	; Increment input number
		ADD R1, R1, #1	; Increment array pointer
		ADD R2, R2, #-1	; Decrement index
		BRp DO_WHILE_LOOP
	
	LD R1, Array_PTR
	LDR R2, R1, #6

	HALT
	; Local Data
	START		.FILL	#0
	SIZE		.FILL	#10
	Array_PTR	.FILL	x4000
	.ORIG x4000
		.BLKW	#10

.END
