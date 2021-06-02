;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 6, ex 3
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
	
	; subroutine call to get string
	LD R6, SUB_GET_STRING
	JSRR R6
	
	; subroutine call to check if palindrome
	LD R6, SUB_IS_PALINDROME
	JSRR R6
	
	; print if palindrome
	IF_RETURN_PALINDROME
		LEA R0, PRINT_PALIN
		PUTS
		LD R0, Array_PTR
		PUTS
		ADD R4, R4, #0
		BRnz RETURN_NOT_PALINDROME
		LEA R0, IS_PALIN
		PUTS
	END_IF_RETURN_PALINDROME
		
	LEA R0, NEWLINE
	PUTS
	
	HALT
	
	RETURN_NOT_PALINDROME
		LEA R0, IS_NOT
		PUTS
		BR END_IF_RETURN_PALINDROME
			
	; Local Data
	START				.STRINGZ	"Enter a string. Exit with [ENTER] key."
	NEWLINE				.STRINGZ	"\n"
	PRINT_PALIN			.STRINGZ	"The string \""
	IS_PALIN			.STRINGZ	"\" IS a palindrome"
	IS_NOT				.STRINGZ	"\" IS NOT a palindrome"
	SUB_GET_STRING		.FILL		x3200
	SUB_IS_PALINDROME	.FILL		x3400
	Array_PTR			.FILL		x4000
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
	
;=================================================
; Subroutine : SUB_IS_PALINDROME
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1) is
;				 a palindrome or not, and returned a flag to that effect.
; Return Value (R4): 1 if the string is a palindrome, 0 otherwise
;=================================================

.ORIG x3400

	ST R0, BACKUP_R0_3400
	ST R1, BACKUP_R1_3400
	ST R2, BACKUP_R2_3400
	ST R3, BACKUP_R3_3400
	ST R5, BACKUP_R5_3400
	ST R6, BACKUP_R6_3400
	ST R7, BACKUP_R7_3400
	; Instructions
	; convert palindrome to upper
	LD R6, SUB_TO_UPPER
	JSRR R6 
	AND R2, R2, x0
	AND R3, R3, x0
	ADD R6, R5, R1
	ADD R6, R6, #-1
	
	IF_PALINDROME
		LDR R2, R1, #0
		LDR R3, R6, #0
		NOT R3, R3
		ADD R3, R3, #1
		ADD R2, R2, R3
		BRnp NOT_PALINDROME	
		ADD R1, R1, #1
		ADD R6, R6, #-1
		ADD R5, R5, #-1
		BRnp IF_PALINDROME
		AND R4, R4, #0
		ADD R4, R4, #1
	END_IF_PALINDROME
	
	
	
	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400
	LD R2, BACKUP_R2_3400
	LD R3, BACKUP_R3_3400
	LD R5, BACKUP_R5_3400
	LD R6, BACKUP_R6_3400
	LD R7, BACKUP_R7_3400
	
	RET
	
	NOT_PALINDROME
		AND R4, R4, #0
		BR END_IF_PALINDROME
		
	; Local Data
	BACKUP_R0_3400	.BLKW	#1
	BACKUP_R1_3400	.BLKW	#1
	BACKUP_R2_3400	.BLKW	#1
	BACKUP_R3_3400	.BLKW	#1
	BACKUP_R5_3400	.BLKW	#1
	BACKUP_R6_3400	.BLKW	#1
	BACKUP_R7_3400	.BLKW	#1
	SUB_TO_UPPER	.FILL	x3600

;=================================================
; Subroutine : SUB_TO_UPPER
; Parameter (R1): Starting address of a null-terminated string
; Postcondition: The subroutine has converted the string to upper-case in-place
;			  i.e. the upper-case string has replaced the original string
; No return value, no output (but R1 still contains the array address, unchanged).
;=================================================

.ORIG x3600

	ST R0, BACKUP_R0_3600
	ST R1, BACKUP_R1_3600
	ST R2, BACKUP_R2_3600
	ST R3, BACKUP_R3_3600
	ST R4, BACKUP_R4_3600
	ST R5, BACKUP_R5_3600
	ST R6, BACKUP_R6_3600
	ST R7, BACKUP_R7_3600

	; Instruction
	LD R4, UPPER_BITMASK
	FOR_LOOP
		LDR R2, R1, #0
		ADD R3, R2, #0
		BRz END_FOR_LOOP
		AND R2, R2, R4
		STR R2, R1, #0
		ADD R1, R1, #1
		BR FOR_LOOP
	END_FOR_LOOP
	
	LD R0, BACKUP_R0_3600
	LD R1, BACKUP_R1_3600
	LD R2, BACKUP_R2_3600
	LD R3, BACKUP_R3_3600
	LD R4, BACKUP_R4_3600
	LD R5, BACKUP_R5_3600
	LD R6, BACKUP_R6_3600
	LD R7, BACKUP_R7_3600

	RET
	
	; Local Data
	BACKUP_R0_3600	.BLKW	#1
	BACKUP_R1_3600	.BLKW	#1
	BACKUP_R2_3600	.BLKW	#1
	BACKUP_R3_3600	.BLKW	#1
	BACKUP_R4_3600	.BLKW	#1
	BACKUP_R5_3600	.BLKW	#1
	BACKUP_R6_3600	.BLKW	#1
	BACKUP_R7_3600	.BLKW	#1
	UPPER_BITMASK	.FILL	x5F
.END
