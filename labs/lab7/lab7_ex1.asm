;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 7, ex 1
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

; MAIN
	; Instructions
	
	LD R6, SUB_ONE
	JSRR R6
	
	ADD R1, R1, #1
	
	LD R6, SUB_TWO
	JSRR R6
	
	HALT
	; Local Data
	SUB_ONE 	.FILL 	x3200
	SUB_TWO		.FILL 	x3400
	
	
;=================================================
; Subroutine : SUB_ONE
; Parameter : none 
; Postcondition : Takes a value from local subroutine data and
;				  fills a register with it.
; Return Value (R1) : .FILL value
;=================================================

.ORIG x3200
	; Instructions
	ST R0, BACKUP_R0_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R6, BACKUP_R6_3200
	ST R7, BACKUP_R7_3200
	
	LD R1, VALUE
	
	LD R0, BACKUP_R0_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R6, BACKUP_R6_3200
	LD R7, BACKUP_R7_3200
	
	RET
	
	; Local Data
	BACKUP_R0_3200	.BLKW	#1
	BACKUP_R2_3200	.BLKW	#1
	BACKUP_R3_3200	.BLKW	#1
	BACKUP_R4_3200	.BLKW	#1
	BACKUP_R5_3200	.BLKW	#1
	BACKUP_R6_3200	.BLKW	#1
	BACKUP_R7_3200	.BLKW	#1
	VALUE			.FILL	#20000
;=================================================
; Subroutine : SUB_TWO
; Parameter (R1) : Value loaded from previous subroutine
; Postcondition : Take value found within R1 and output as an
;				  ASCII string
; Return Value : Output on console
;=================================================

.ORIG x3400
	; Instructions
	ST R0, BACKUP_R0_3400
	ST R1, BACKUP_R1_3400
	ST R2, BACKUP_R2_3400
	ST R3, BACKUP_R3_3400
	ST R4, BACKUP_R4_3400
	ST R5, BACKUP_R5_3400
	ST R6, BACKUP_R6_3400
	ST R7, BACKUP_R7_3400
	
	AND R3, R3, x0	; First Digit Flag (skips 0s when a digit has not been outputted)
	AND R5, R5, x0	; Place counter
	ADD R2, R1, #0	; Integer copy
	ADD R1, R1, #0
	BRn NORMALIZE
	
	TEN_THOUSANDTHS_PLACE
		LD R4, TEN_THOUSANDTHS
		ADD R1, R1, R4
		BRzp TT_COUNT
		ADD R3, R3, #0
		BRz THOUSANDTHS_PLACE
		LD R0, ZERO
		ADD R0, R0, R5
		OUT
		AND R5, R5, x0
		BR THOUSANDTHS_PLACE
	
	THOUSANDTHS_PLACE
		ADD R1, R2, #0
		LD R4, THOUSANDTHS
		ADD R1, R1, R4
		BRzp T_COUNT
		ADD R3, R3, #0
		BRz HUNDREDTHS_PLACE
		LD R0, ZERO
		ADD R0, R0, R5
		OUT
		AND R5, R5, x0
		BR HUNDREDTHS_PLACE
	
	HUNDREDTHS_PLACE
		ADD R1, R2, #0
		LD R4, HUNDREDTHS
		ADD R1, R1, R4
		BRzp H_COUNT
		ADD R3, R3, #0
		BRz TENTHS_PLACE
		LD R0, ZERO
		ADD R0, R0, R5
		OUT
		AND R5, R5, x0
		BR TENTHS_PLACE

	TENTHS_PLACE
		ADD R1, R2, #0
		LD R4, TENTHS
		ADD R1, R1, R4
		BRzp TN_COUNT
		ADD R3, R3, #0
		BRz ONETHS_PLACE
		LD R0, ZERO
		ADD R0, R0, R5
		OUT
		AND R5, R5, x0
		BR ONETHS_PLACE
	
	ONETHS_PLACE
		ADD R1, R2, #0
		LD R0, ZERO
		ADD R0, R0, R1
		OUT
	
	LD R0, NEWLINE
	OUT
	
	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400
	LD R2, BACKUP_R2_3400
	LD R3, BACKUP_R3_3400
	LD R4, BACKUP_R4_3400
	LD R5, BACKUP_R5_3400
	LD R6, BACKUP_R6_3400
	LD R7, BACKUP_R7_3400
	
	RET
	
	NORMALIZE
		NOT R1, R1
		ADD R1, R1, #1
		ADD R2, R1, #0
		LD R0, NEGSIGN
		OUT
		BR TEN_THOUSANDTHS_PLACE
	
	TT_COUNT
		ADD R2, R1, #0
		ADD R5, R5, #1
		ADD R3, R3, #1	; First digit seen
		BR TEN_THOUSANDTHS_PLACE
	
	T_COUNT
		ADD R2, R1, #0
		ADD R5, R5, #1
		ADD R3, R3, #1
		BR THOUSANDTHS_PLACE
	
	H_COUNT
		ADD R2, R1, #0
		ADD R5, R5, #1
		ADD R3, R3, #1
		BR HUNDREDTHS_PLACE
		
	TN_COUNT
		ADD R2, R1, #0
		ADD R5, R5, #1
		ADD R3, R3, #1
		BR TENTHS_PLACE
		
	; Local Data
	BACKUP_R0_3400	.BLKW	#1
	BACKUP_R1_3400	.BLKW	#1
	BACKUP_R2_3400	.BLKW	#1
	BACKUP_R3_3400	.BLKW	#1
	BACKUP_R4_3400	.BLKW	#1
	BACKUP_R5_3400	.BLKW	#1
	BACKUP_R6_3400	.BLKW	#1
	BACKUP_R7_3400	.BLKW	#1
	ZERO			.FILL	x30
	NEGSIGN			.FILL 	x2D
	NEWLINE			.FILL	x0A
	TEN_THOUSANDTHS	.FILL	#-10000
	THOUSANDTHS		.FILL	#-1000
	HUNDREDTHS		.FILL	#-100
	TENTHS			.FILL 	#-10

	

	
