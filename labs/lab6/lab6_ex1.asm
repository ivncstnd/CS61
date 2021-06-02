;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

; MAIN
	; Instructions
	LEA	R0, START
	PUTS
	
	LEA R0, NEWLINE
	PUTS

	LD R1, Array_PTR
	
	; subroutine call
	LD R6, SUB_GET_STRING
	JSRR R6
	
	; print
	LD R0, Array_PTR
	PUTS
	
	LEA R0, NEWLINE
	PUTS
	
	HALT
	; Local Data
	START			.STRINGZ	"Enter a string. Exit with [ENTER] key."
	NEWLINE			.STRINGZ	"\n"
	SUB_GET_STRING	.FILL		x3200
	Array_PTR		.FILL		x4000
	.ORIG x4000
		.BLKW	#100
	
;=================================================
; Subroutine : SUB_GET_STRING
; Parameter (R1): The starting address of the character array
; Postcondition: The subroutine has prompted the user to input a string,
;				 terminated by the [ENTER] key (the "sentinel"), and has stored
;				 the received characters in an array of characters starting at (R1).
;				 the array is NULL-terminated; the sentinel character is NOT stored.
; Return Value (R5): The number of non-sentinel characters read from the user.
;					R1 contains the starting address of the array unchanged.
;=================================================

.ORIG x3200

	ST R0, BACKUP_R0_3200
	ST R1, BACKUP_R1_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R6, BACKUP_R6_3200
	ST R7, BACKUP_R7_3200

	; Instructions
	LD R2, ASCII_NEWLINE
	NOT R2, R2
	LD R5, STRING_SIZE
	
	WHILE_LOOP
		GETC
		OUT
		
		; check if input character is [ENTER]
		ADD R3, R0, #0	
		ADD R3, R3, R2
		ADD R3, R3, #1
		BRz	END_LOOP
	
		; store characters into array [R1] and increment in size/loop
		STR R0, R1, #0
		ADD R1, R1, #1
		ADD R5, R5, #1
		BRnp WHILE_LOOP
		
		
	END_LOOP
		; add null character to the end of array and return
		LD R3, NULL
		STR R3, R1, #0
	
	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R1_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R6, BACKUP_R6_3200
	LD R7, BACKUP_R7_3200
	
	RET
	; Local Data
	BACKUP_R0_3200	.BLKW	#1
	BACKUP_R1_3200	.BLKW	#1
	BACKUP_R2_3200	.BLKW	#1
	BACKUP_R3_3200	.BLKW	#1
	BACKUP_R4_3200	.BLKW	#1
	BACKUP_R6_3200	.BLKW	#1
	BACKUP_R7_3200	.BLKW	#1
	STRING_SIZE		.FILL	x0
	ASCII_NEWLINE	.FILL	x0A
	NULL			.FILL	x0
.END
