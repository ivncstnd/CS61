;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 9, ex 3
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

; test harness
.orig x3000

LD R4, BASE
LD R5, MAX
LD R6, TOS
LD R1, SUB_PUSH

; Print prompt, get input
LEA R0, PROMPT
PUTS

GETC
OUT

; Load ascii zero to get input, and store into stack
LD R2, ZERO_MAIN
ADD R0, R0, R2
JSRR R1

; Get 2nd input and store into stack
GETC
OUT
ADD R0, R0, R2 
JSRR R1

; Get * input, but discard
GETC
OUT
LD R0, NEWLINE_MAIN
OUT

; Call multiply subroutine
LD R1, SUB_MULT
JSRR R1

; Pop the newly stored result
LD R1, SUB_POP
JSRR R1

; Print what is in R0
LD R1, SUB_PRINT
JSRR R1

LEA R0, MESSAGE
PUTS

HALT


;Local Data
SUB_PUSH .FILL x3200
SUB_POP .FILL x3400
SUB_MULT .FILL x3600
SUB_PRINT .FILL x4000
ZERO_MAIN .FILL #-48
NEWLINE_MAIN .FILL x0A
BASE .FILL xA000
MAX .FILL xA005
TOS .FILL xA000

PROMPT .STRINGZ "Enter 2 digits and * operation\n"
MESSAGE .STRINGZ " is the result.\n"



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

NOT R2, R5
ADD R2, R2, #1

ADD R2, R6, R2
BRzp OVERFLOW_ERROR

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

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
					.orig x3600
				 
					ST R0, BACKUP_R0_3600
					ST R1, BACKUP_R1_3600
					ST R2, BACKUP_R2_3600
					ST R3, BACKUP_R3_3600
					ST R7, BACKUP_R7_3600
					AND R2, R2, x0
					AND R3, R3, x0
					; pop the top element
					LD R1, SUB_STACK_POP_3600
					JSRR R1
					
					; Move R0 return value into R2 and pop element to move into R3
					ADD R2, R0, #0
					JSRR R1
					ADD R3, R0, #0
					
					; Multiply and return
					LD R1, SUB_MULTIPLY
					JSRR R1
					
					; Push R0 return into the stack
					LD R1, SUB_STACK_PUSH_3600
					JSRR R1
				 
					LD R0, BACKUP_R0_3600
					LD R1, BACKUP_R1_3600
					LD R2, BACKUP_R2_3600
					LD R3, BACKUP_R3_3600
					LD R7, BACKUP_R7_3600
					ret
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data
BACKUP_R0_3600		.BLKW #1
BACKUP_R1_3600		.BLKW #1
BACKUP_R2_3600		.BLKW #1
BACKUP_R3_3600		.BLKW #1
BACKUP_R7_3600		.BLKW #1
PREV_ELEMENT		.BLKW #1
SUB_STACK_POP_3600	.FILL x3400
SUB_STACK_PUSH_3600	.FILL x3200
SUB_MULTIPLY		.FILL x3800



;===============================================================================================



; SUB_MULTIPLY		
.ORIG x3800
ST R7, BACKUP_R7_3800
AND R0, R0, x0
MULTIPLY
	ADD R0, R0, R2
	ADD R3, R3, #-1
	BRp MULTIPLY

LD R7, BACKUP_R7_3800
RET
BACKUP_R7_3800 .BLKW #1



; SUB_PRINT_DECIMAL		Only needs to be able to print 1 or 2 digit numbers. 
;						You can use your lab 7 s/r.

;=================================================
; Subroutine : SUB_TWO
; Parameter (R1) : Value loaded from previous subroutine
; Postcondition : Take value found within R1 and output as an
;				  ASCII string
; Return Value : Output on console
;=================================================

.ORIG x4000
	; Instructions
	ST R0, BACKUP_R0_4000
	ST R1, BACKUP_R1_4000
	ST R2, BACKUP_R2_4000
	ST R3, BACKUP_R3_4000
	ST R4, BACKUP_R4_4000
	ST R5, BACKUP_R5_4000
	ST R6, BACKUP_R6_4000
	ST R7, BACKUP_R7_4000
	
	; Move R0 parameter to R1
	AND R1, R1, x0
	ADD R1, R1, R0
	
	; Continue subroutine
	
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
	
	LD R0, BACKUP_R0_4000
	LD R1, BACKUP_R1_4000
	LD R2, BACKUP_R2_4000
	LD R3, BACKUP_R3_4000
	LD R4, BACKUP_R4_4000
	LD R5, BACKUP_R5_4000
	LD R6, BACKUP_R6_4000
	LD R7, BACKUP_R7_4000
	
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
	BACKUP_R0_4000	.BLKW	#1
	BACKUP_R1_4000	.BLKW	#1
	BACKUP_R2_4000	.BLKW	#1
	BACKUP_R3_4000	.BLKW	#1
	BACKUP_R4_4000	.BLKW	#1
	BACKUP_R5_4000	.BLKW	#1
	BACKUP_R6_4000	.BLKW	#1
	BACKUP_R7_4000	.BLKW	#1
	ZERO			.FILL	x30
	NEGSIGN			.FILL 	x2D
	NEWLINE			.FILL	x0A
	TEN_THOUSANDTHS	.FILL	#-10000
	THOUSANDTHS		.FILL	#-1000
	HUNDREDTHS		.FILL	#-100
	TENTHS			.FILL 	#-10


