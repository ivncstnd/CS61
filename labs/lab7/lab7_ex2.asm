;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

; MAIN
	; Instructions
	LEA R0, PROMPT
	PUTS
	
	GETC
	OUT
	
	ADD R2, R0, #0
	
	LD R6, SUB_BIN_ONES_COUNT
	JSRR R6
	
	LEA R0, EXIT
	PUTS
	
	ADD R0, R2, #0
	OUT
	
	LEA R0, EXIT2
	PUTS
	
	LD R0, ZERO
	ADD R0, R0, R1
	OUT
	
	LD R0, NEWLINE
	OUT
	
	HALT
	
	
	; Local Data
	PROMPT				.STRINGZ 	"Enter a character: "
	EXIT				.STRINGZ	"\nThe number of 1's found in '"
	EXIT2				.STRINGZ	"' is: "
	ZERO				.FILL		x30
	NEWLINE				.FILL		x0A
	SUB_BIN_ONES_COUNT	.FILL		x3200
	
;=================================================
; Subroutine : SUB_BIN_ONES_COUNT
; Parameter : none
; Postcondition : Counts all the 1's found in a character binary
; Return Value (R1) : Total count
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
	
	LD R1, COUNT
	LD R2, INDEX
	
	AND R3, R3, #0
	ADD R3, R0, #0
	
	FOR_LOOP
		ADD R3, R3, #0
		BRzp IF_ZERO
		ADD R3, R3, #0
		BRn IF_ONE
	
	IF_ZERO
		ADD R3, R3, R3
		ADD R2, R2, #-1
		BRz END_FOR_LOOP
		BR	FOR_LOOP
	
	IF_ONE
		ADD R3, R3, R3
		ADD R1, R1, #1
		ADD R2, R2, #-1
		BRz END_FOR_LOOP
		BR	FOR_LOOP
	
	END_FOR_LOOP
	
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
	INDEX			.FILL	x10
	COUNT			.FILL	x00
	
.END	

	
