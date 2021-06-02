;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 4, ex 2
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
	LD R2, SIZE
	LD R3, HEX_30
	DO_PRINT_LOOP
		LDR R0, R1, #0	; Load R0 with index of R1 array
		ADD R0, R0, R3	; Convert R0 into ASCII code
		OUT
		ADD R1, R1, #1	; Increment array ptr
		ADD R2, R2, #-1	; Decrement index
		BRp DO_PRINT_LOOP
		
	HALT
	; Local Data
	START		.FILL	#0
	HEX_30		.FILL	x30
	SIZE		.FILL	#10
	Array_PTR	.FILL	x4000
	.ORIG x4000
		.BLKW	#10
	

.END
