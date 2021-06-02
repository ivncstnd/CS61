;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

; test harness
					.orig x3000
					LD R4, BASE
					LD R5, MAX
					LD R6, TOS
				 
					WHILE_LOOP
						AND R2, R2, x0
						; Print prompt
						LEA R0, PROMPT
						PUTS
						
						; Get input
						GETC
						OUT
						
						; Check input
						LD R1, ZERO
						ADD R0, R0, R1
						BRz POP_STACK
						
						; If input is > 0, push 
						LEA R0, PUSH_PROMPT
						PUTS
						
						; Get input
						GETC
						OUT
						
						; Save Input and output newline
						ADD R2, R2, R0
						LD R0, NEWLINE
						OUT
						; Check any digit between 0-9, loads the subroutine and outputs correctly
						ADD R0, R2, R1
						LD R3, SUB_STACK_PUSH
						JSRR R3
						BR WHILE_LOOP	
						
						; If pop stack
						POP_STACK
							; Out newline
							LD R0, NEWLINE
							OUT
							AND R0, R0, x0
							; Subroutine
							LD R1, SUB_STACK_POP
							JSRR R1
							; Calculate number popped
							LD R1, ZERO
							NOT R1, R1
							ADD R1, R1, #1
							ADD R0, R0, R1
							BRn WHILE_LOOP
							; Check if underflow
							NOT R1, R0
							ADD R1, R1, #1
							LD R2, NINE
							ADD R2, R2, R1
							BRn WHILE_LOOP
							; else output num and loop
							OUT
							LEA R0, POP_PROMPT
							PUTS
							BR WHILE_LOOP
							
							
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
SUB_STACK_PUSH	.FILL	x3200
SUB_STACK_POP	.FILL	x3400
ZERO			.FILL	#-48
NINE			.FILL	#57
NEWLINE			.FILL	#10
BASE			.FILL	xA000
MAX				.FILL	xA005
TOS				.FILL	xA000
PROMPT			.STRINGZ	"POP or PUSH? (0 - 1)\n"
PUSH_PROMPT		.STRINGZ	"\nValue to push?\n"
POP_PROMPT		.STRINGZ	" popped.\n"



;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3200
				 
ST R2, BACKUP_R2_3200
ST R7, BACKUP_R7_3200

; 2's complament of max index
NOT R2, R5
ADD R2, R2, #1

; Overflows if index is at max or exceeding
ADD R2, R6, R2
BRzp OVERFLOW_ERROR

; Otherwise store value and increase index
ADD R6, R6, #1
STR R0, R6, #0

BR RET_3200

OVERFLOW_ERROR
	LEA R0, OVERFLOW
	PUTS
  
RET_3200
	LD R2, BACKUP_R2_3200
	LD R7, BACKUP_R7_3200		 
	RET
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data

OVERFLOW .STRINGZ "overflow\n"

BACKUP_R2_3200 .BLKW 1
BACKUP_R7_3200 .BLKW 1

;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3400
ST R2, BACKUP_R2_3400
ST R7, BACKUP_R7_3400

; 2's complement of the starting index
NOT R2, R4
ADD R2, R2, #1

; Add the current index to the starting index and underflow if not valid
ADD R2, R6, R2
BRnz UNDERFLOW_ERROR

; otherwise get the popped element and decrement address index
LDR R0, R6, #0
ADD R6, R6, #-1
BR RET_3400

UNDERFLOW_ERROR
	LEA R0, UNDERFLOW
	PUTS

RET_3400
	LD R2, BACKUP_R2_3400
	LD R7, BACKUP_R7_3400
	RET
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
UNDERFLOW	.STRINGZ "underflow\n"

BACKUP_R2_3400	.BLKW 1
BACKUP_R7_3400	.BLKW 1


;===============================================================================================

