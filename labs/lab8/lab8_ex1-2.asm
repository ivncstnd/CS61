;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 8, ex 1 & 2
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

; test harness
					.orig x3000
						
						LD R6, SUB_PRINT_OPCODE_TABLE
						JSRR R6						
						LD R6, SUB_FIND_OPCODE
						JSRR R6
					
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
					SUB_PRINT_OPCODE_TABLE	.FILL	x3200
					SUB_FIND_OPCODE			.FILL 	x3600

;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;				 and corresponding opcode in the following format:
;					ADD = 0001
;					AND = 0101
;					BR = 0000
;					…
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3200

						ST R1, BACKUP_R1_3200
						ST R2, BACKUP_R2_3200
						ST R3, BACKUP_R3_3200
						ST R7, BACKUP_R7_3200
				 
						LD R1, INDEX
						LD R2, opcodes_po_ptr		; NUMS
						LD R3, instructions_po_ptr	; STRINGS
						
						WHILE_LOOP
							LDR R0, R3, #0 ; load each char until null
							OUT
							ADD R3, R3, #1
							ADD R0, R0, #0
							BRnp WHILE_LOOP
							
							LEA R0, EQUAL  ; print equal
							PUTS
							
							LD R6, SUB_PRINT_OPCODE	; print opcode subroutine
							JSRR R6
							
							LD R0, NEWLINE ; newline
							OUT
							
							ADD R1, R1, #-1    ; repeat for all opcodes
							BRz END_WHILE_LOOP
							ADD R2, R2, #1
							BR WHILE_LOOP
							
						END_WHILE_LOOP
						LD R1, BACKUP_R1_3200
						LD R2, BACKUP_R2_3200
						LD R3, BACKUP_R3_3200
						LD R7, BACKUP_R7_3200
						
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
opcodes_po_ptr		.fill 	x4000				; local pointer to remote table of opcodes
instructions_po_ptr	.fill 	x4100				; local pointer to remote table of instructions
INDEX			.FILL		x10
NEWLINE			.FILL		x0A
EQUAL			.STRINGZ	" = "
BACKUP_R1_3200	.BLKW		#1
BACKUP_R2_3200	.BLKW		#1
BACKUP_R3_3200	.BLKW		#1
BACKUP_R7_3200	.BLKW		#1
SUB_PRINT_OPCODE	.FILL	x3400

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3400
					
						ST R1, BACKUP_R1_3400
						ST R2, BACKUP_R2_3400
						ST R7, BACKUP_R7_3400
				 
						AND R1, R1, x0
						ADD R1, R1, x4
						
						ADD R2, R2, R2
						ADD R2, R2, R2
						ADD R2, R2, R2
						ADD R2, R2, R2
						
						ADD R2, R2, R2
						ADD R2, R2, R2
						ADD R2, R2, R2
						ADD R2, R2, R2
						
						ADD R2, R2, R2
						ADD R2, R2, R2
						ADD R2, R2, R2
						ADD R2, R2, R2
				 
						BIN_PRINT_LOOP
							ADD R2, R2, #0
							BRzp PRINT_ZERO
							BR PRINT_ONE
						CLOSE_LOOP
							ADD R2, R2, R2
							ADD R1, R1, #-1
							BRp BIN_PRINT_LOOP
						
						LD R1, BACKUP_R1_3400
						LD R2, BACKUP_R2_3400
						LD R7, BACKUP_R7_3400
				 
					ret
					
					PRINT_ZERO
						LD R0, ZERO
						OUT
						BR CLOSE_LOOP
						
					PRINT_ONE
						LD R0, ZERO
						ADD R0, R0, #1
						OUT
						BR CLOSE_LOOP
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
ZERO			.FILL		x30
BACKUP_R1_3400	.BLKW		#1
BACKUP_R2_3400	.BLKW		#1
BACKUP_R7_3400	.BLKW		#1



;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3600
						ST R2, BACKUP_R2_3600
						ST R7, BACKUP_R7_3600
					 
						LD R2, INSTRUCTION_STRING_PTR
						LD R6, SUB_GET_STRING
						JSRR R6
						
						LD R1, opcodes_fo_ptr
						LD R2, instructions_fo_ptr
						AND R4, R4, #0
						FOR_LOOP_INSTRUCTIONS
								; if end of array, print outcome
								LDR R6, R2, #0
								BRn END_FOR_LOOP
								
								LD R3, INSTRUCTION_STRING_PTR
								; compare input and array chars
								CHECK_CHARS
										LDR R6, R2, #0 		; array string char
										LDR R7, R3, #0 		; input string char
										ADD R6, R7, R6
										BRz MATCHING_FLAG 	; end of string and all characters matched
										LDR R6, R2, #0 		; if not end of string, compare chars
										NOT R6, R6
										ADD R6, R6, #1
										ADD R7, R7, R6
										BRz NEXT_CHAR 		; characters are same, but null char not reached
										BR NEXT_OP			; next opcode
								NEXT_CHAR
										ADD R2, R2, #1
										ADD R3, R3, #1
										BR CHECK_CHARS
								NEXT_OP ; because strings are character arrays, we iterate through each char until null char is hit. then iterate once for new string
										ADD R1, R1, #1 ; increment opcode num
										ITERATE_EACH_CHAR
											LDR R6, R2, #0 
											BRz NEW_STRING
											ADD R2, R2, #1
											BR ITERATE_EACH_CHAR
											NEW_STRING
												ADD R2, R2, #1 
												BR FOR_LOOP_INSTRUCTIONS

						MATCHING_FLAG
						ADD R4, R4, #1
								
						END_FOR_LOOP
						;if R4 is still 0, then user input is invalid instruction
						ADD R4, R4, #0
						BRz PRINT_INVALID_3600
						LD R0, INSTRUCTION_STRING_PTR ;this is equivalent to ADD R0, R2, #0 (cause both 
													  ;strings have been determined to be the same)
						PUTS
						LEA R0, EEQUAL
						PUTS
						LDR R2, R1, #0
						LD R6, SUB_PRINT_OPCODE_2
						JSRR R6
						LD R0, NNNEWLINE
						OUT
						BR END_PRINT_INSTRUCTION_3600
						
						PRINT_INVALID_3600
							LEA R0, INVALID
							PUTS
							BR END_PRINT_INSTRUCTION_3600
							
						END_PRINT_INSTRUCTION_3600

						LD R2, BACKUP_R2_3600
						LD R7, BACKUP_R7_3600
				 ret
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo_ptr			.fill 		x4000
instructions_fo_ptr		.fill 		x4100
INSTRUCTION_STRING_PTR	.FILL 		x4200
SUB_PRINT_OPCODE_2		.FILL 		x3400
SUB_GET_STRING			.FILL 		x3800
EEQUAL					.STRINGZ 	" = "
NNNEWLINE				.FILL		x0A
INVALID					.STRINGZ	"Invalid Instruction\n"			
BACKUP_R2_3600			.BLKW		#1
BACKUP_R7_3600			.BLKW		#1
.ORIG x4200
	INSTRUCTION_STRING	.BLKW #100


;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
					.orig x3800
					
						ST R1, BACKUP_R1_3800
						ST R2, BACKUP_R2_3800
						ST R3, BACKUP_R3_3800
						ST R7, BACKUP_R7_3800
					 
						LEA R0, PROMPT
						PUTS
						
						LD R1, NNEWLINE
						NOT R1, R1
						
						GET_CHAR_LOOP
							GETC
							OUT
							
							ADD R3, R0, #0
							ADD R3, R3, R1
							ADD R3, R3, #1
							BRz END_GET_CHAR_LOOP							
						
							STR R0, R2, #0
							ADD R2, R2, #1
							BR GET_CHAR_LOOP
						END_GET_CHAR_LOOP
						AND R3, R3, x0
						STR R3, R2, #0
					 
						LD R1, BACKUP_R1_3800
						LD R2, BACKUP_R2_3800
						LD R3, BACKUP_R3_3800
						LD R7, BACKUP_R7_3800
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data
NNEWLINE			.FILL		x0A
PROMPT			.STRINGZ	"Enter an instruction: "	
BACKUP_R1_3800	.BLKW		#1
BACKUP_R2_3800	.BLKW		#1
BACKUP_R3_3800	.BLKW		#1
BACKUP_R7_3800	.BLKW		#1


;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
					.ORIG x4000			; list opcodes as numbers from #0 through #15, e.g. .fill #12 or .fill xC
						BR_CODE		.FILL x0	
						ADD_CODE	.FILL x1
						LD_CODE		.FILL x2
						ST_CODE		.FILL x3
						JSR_CODE	.FILL x4
						AND_CODE	.FILL x5
						LDR_CODE	.FILL x6
						STR_CODE	.FILL x7
						RTI_CODE	.FILL x8
						NOT_CODE	.FILL x9
						LDI_CODE	.FILL xA
						STI_CODE	.FILL xB
						JMP_CODE	.FILL xC
						RESERVED	.FILL xD
						LEA_CODE	.FILL xE
						TRAP_CODE	.FILL xF
; opcodes


					.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
								 		; - be sure to follow same order in opcode & instruction arrays!
						BR_OP		.STRINGZ "BR"
						ADD_OP		.STRINGZ "ADD"
						LD_OP		.STRINGZ "LD"
						ST_OP		.STRINGZ "OP"
						JSR_OP		.STRINGZ "JSR"
						AND_OP		.STRINGZ "AND"
						LDR_OP		.STRINGZ "LDR"
						STR_OP		.STRINGZ "STR"
						RTI_OP		.STRINGZ "RTI"
						NOT_OP		.STRINGZ "NOT"
						LDI_OP		.STRINGZ "LDI"
						STI_OP		.STRINGZ "STI"
						JMP_OP		.STRINGZ "JMP"
						RESERVED_OP	.STRINGZ "RESERVED"
						LEA_OP		.STRINGZ "LEA"
						TRAP_OP		.STRINGZ "TRAP"
						END			.FILL	 #-1
; instructions	

;===============================================================================================
