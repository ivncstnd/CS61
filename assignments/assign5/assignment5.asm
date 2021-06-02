;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 23
; TA: Shirin Shirazi
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================
; Busyness vector: xB600 

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
GET_MENU
	LD R6, SUB_MENU
	JSRR R6

	ADD R5, R1, #-1
	BRz ALL_MACH_BUSY
	ADD R5, R1, #-2
	BRz ALL_MACH_FREE
	ADD R5, R1, #-3
	BRz NUM_MACH_BUSY
	ADD R5, R1, #-4
	BRz NUM_MACH_FREE
	ADD R5, R1, #-5
	BRz MACH_STAT
	ADD R5, R1, #-6
	BRz FIRST_FREE
	ADD R5, R1, #-7
	BRz END
	
	ALL_MACH_BUSY
		LD R6, SUB_ALL_MACHINES_BUSY
		JSRR R6
		LD R0, newline
		OUT
		ADD R2, R2, #0
		BRnp ALL_BUSY
		LEA R0, allnotbusy
		PUTS
		BR GET_MENU
		ALL_BUSY
			LEA R0, allbusy
			PUTS
			BR GET_MENU
	
	ALL_MACH_FREE
		LD R6, SUB_ALL_MACHINES_FREE
		JSRR R6
		LD R0, newline
		OUT
		ADD R2, R2, #0
		BRnp ALL_FREE
		LEA R0, allnotfree
		PUTS
		BR GET_MENU
		ALL_FREE
			LEA R0, allfree	
			PUTS
			BR GET_MENU
	
	NUM_MACH_BUSY
		LD R6, SUB_NUM_MACHINES_BUSY
		JSRR R6
		LD R0, newline
		OUT
		LEA R0, busymachine1
		PUTS
		LD R6, SUB_PRINT_NUM
		JSRR R6
		LEA R0, busymachine2
		PUTS
		BR GET_MENU
		
	NUM_MACH_FREE
		LD R6, SUB_NUM_MACHINES_FREE
		JSRR R6
		LD R0, newline
		OUT
		LEA R0, freemachine1
		PUTS
		LD R6, SUB_PRINT_NUM
		JSRR R6
		LEA R0, freemachine2
		PUTS
		BR GET_MENU
	
	MACH_STAT
		LD R6, SUB_GET_MACHINE_NUM
		JSRR R6
		LD R0, newline
		OUT
		AND R2, R2, x0
		ADD R2, R5, R2
		LEA R0, status1
		PUTS
		LD R6, SUB_PRINT_NUM
		JSRR R6
		LD R6, SUB_MACHINE_STATUS
		JSRR R6
		ADD R2, R2, #0
		BRz BUSY_STATUS
		LEA R0, status3
		PUTS
		BR GET_MENU
		BUSY_STATUS
			LEA R0, status2
			PUTS
			BR GET_MENU
	
	FIRST_FREE
		LD R6, SUB_FIRST_FREE
		JSRR R6
		LD R0, newline
		OUT
		ADD R1, R1, #0
		BRn NO_FREE
		LEA R0, firstfree1
		PUTS
		LD R6, SUB_PRINT_NUM
		JSRR R6
		LD R0, newline
		OUT
		BR GET_MENU
		NO_FREE
			LEA R0, firstfree2
			PUTS
			BR GET_MENU
		
END
LD R0, newline
OUT
LEA R0, goodbye
PUTS
HALT
;---------------	
;Data
;---------------
;Subroutine pointers
SUB_MENU	.FILL	x3200
SUB_ALL_MACHINES_BUSY	.FILL x3400
SUB_ALL_MACHINES_FREE	.FILL x3600
SUB_NUM_MACHINES_BUSY	.FILL x3800
SUB_NUM_MACHINES_FREE	.FILL x4000
SUB_MACHINE_STATUS		.FILL x4200
SUB_FIRST_FREE			.FILL x4400
SUB_GET_MACHINE_NUM		.FILL x4600
SUB_PRINT_NUM			.FILL x4800
;Other data 
newline                 .fill '\n'

; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree1      .stringz "The first available machine is number "
firstfree2      .stringz "No machines are free\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3200
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_3200

GET_OPTION
	LD R0, Menu_string_addr
	PUTS
	
	GETC
	OUT
	
	; Check upper / lower bounds of input and return if valid
	LD R1, SEVEN_3200
	ADD R1, R1, R0
	BRp INVALID_OPTION
	LD R1, ZERO_3200
	ADD R1, R1, R0
	BRnz INVALID_OPTION
	
;HINT Restore
LD R7, BACKUP_R7_3200
RET

INVALID_OPTION
	LD R0, NEWLINE_3200
	OUT
	LEA R0, Error_msg_1
	PUTS
	BR GET_OPTION
;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_msg_1	      .STRINGZ "INVALID INPUT\n"
Menu_string_addr  .FILL x5000
NEWLINE_3200	  .FILL x0A
ZERO_3200		  .FILL #-48
SEVEN_3200		  .FILL	#-55
BACKUP_R7_3200	  .BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3400
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
;HINT back up 
ST R1, BACKUP_R1_3400
ST R7, BACKUP_R7_3400

; Clear flag reg
AND R2, R2, x0		  
; Load R1 with busyness vector
LDI R1, BUSYNESS_ADDR_ALL_MACHINES_BUSY
; Add vector with 0
ADD R1, R1, x0
; if the vector outcome is not 0, vector contains a free machine - skip to return 
BRnp RETURN_3400
; else vector is 0, vector contains all busy machines, toggle flag
ADD R2, R2, #1
RETURN_3400
;HINT Restore
LD R1, BACKUP_R1_3400
LD R7, BACKUP_R7_3400
RET
;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xB600
BACKUP_R1_3400	.BLKW #1
BACKUP_R7_3400	.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3600
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
;HINT back up 
ST R1, BACKUP_R1_3600
ST R7, BACKUP_R7_3600

; Clear flag reg
AND R2, R2, x0
; Load R1 with busyness vector
LDI	R1, BUSYNESS_ADDR_ALL_MACHINES_FREE
; All machines are free if vector is xFFFF (#-1). Add 1 and check if 0
ADD R1, R1, #1
; If outcome not 0, vector contains a busy machine - skip to return
BRnp RETURN_3600
; else toggle flag
ADD R2, R2, #1
RETURN_3600
;HINT Restore
LD R1, BACKUP_R1_3600
LD R7, BACKUP_R7_3600
RET
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xB600
BACKUP_R1_3600	.BLKW #1
BACKUP_R7_3600	.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3800
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
;HINT back up 
ST R2, BACKUP_R2_3800
ST R3, BACKUP_R3_3800
ST R7, BACKUP_R7_3800

AND R1, R1, x0
LDI R2, BUSYNESS_ADDR_NUM_BUSY_MACHINES
LD R3, INDEX_3800

COUNT_BUSY_MACHINES
	ADD R2, R2, #0
	; If the current number in R2 is a negative number (1 msb) - left shift next machine 
	BRn NEXT_MACHINE_2
	; Otherwise, increment flag and left shift next machine
	ADD R1, R1, #1
	NEXT_MACHINE_2
		; Left shift and decrement a 16 index count (total vector size)
		ADD R2, R2, R2
		ADD R3, R3, #-1
		BRp COUNT_BUSY_MACHINES
	
;HINT Restore
LD R2, BACKUP_R2_3800
LD R3, BACKUP_R3_3800
LD R7, BACKUP_R7_3800
RET
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xB600
BACKUP_R2_3800	.BLKW #1
BACKUP_R3_3800	.BLKW #1
BACKUP_R7_3800	.BLKW #1
INDEX_3800		.FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4000
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
;HINT back up 
ST R2, BACKUP_R2_4000
ST R3, BACKUP_R3_4000
ST R7, BACKUP_R7_4000

AND R1, R1, x0
LDI R2, BUSYNESS_ADDR_NUM_FREE_MACHINES
LD R3, INDEX_4000

COUNT_FREE_MACHINES
	ADD R2, R2, #0
	BRzp NEXT_MACHINE
	ADD R1, R1, #1
	NEXT_MACHINE
		ADD R2, R2, R2
		ADD R3, R3, #-1
		BRp COUNT_FREE_MACHINES

;HINT Restore
LD R2, BACKUP_R2_4000
LD R3, BACKUP_R3_4000
LD R7, BACKUP_R7_4000
RET
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xB600
BACKUP_R2_4000	.BLKW #1
BACKUP_R3_4000	.BLKW #1
BACKUP_R7_4000	.BLKW #1
INDEX_4000		.FILL #16

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4200
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
;HINT back up 
ST R1, BACKUP_R1_4200
ST R7, BACKUP_R7_4200 

AND R2, R2, x0
AND R3, R3, x0
LDI R4, BUSYNESS_ADDR_MACHINE_STATUS
; Create a bitmask by adding 1 to a register and shifting it to the position of the machine to check
ADD R3, R3, #1
BIT_MASK
	ADD R3, R3, R3
	ADD R1, R1, #-1
	BRp BIT_MASK
; Check if 1 is busy by ANDing bitmask and busyness vector
AND R3, R3, R4
BRz RETURN_4200
; Toggle the flag if true
ADD R2, R2, #1
RETURN_4200
;HINT Restore
LD R1, BACKUP_R1_4200
LD R7, BACKUP_R7_4200
RET
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS	.Fill xB600
BACKUP_R1_4200	.BLKW #1
BACKUP_R7_4200	.BLKW #1


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R1): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4400
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
;HINT back up 
ST R7, BACKUP_R7_4400
AND R1, R1, x0
AND R2, R2, x0
LDI R4, BUSYNESS_ADDR_FIRST_FREE ; Vector
LD R3, INDEX_4400 ; 16
ADD R2, R2, #1
COUNT_MACHINES
	AND R5, R2, R4
	BRnp FIRST_FREE_FOUND
	ADD R2, R2, R2
	ADD R1, R1, #1
	ADD R3, R3, #-1
		BRp COUNT_MACHINES
		
	AND R1, R1, #0
	ADD R1, R1, #-1
	FIRST_FREE_FOUND
	
;HINT Restore
LD R7, BACKUP_R7_4400
RET
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xB600
BACKUP_R7_4400	.BLKW #1
INDEX_4400 		.FILL #16


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4600
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
ST R7, BACKUP_R7_4600
	LD R0, NEWLINE_4600
	OUT
	LEA R0, prompt
	PUTS
	
	AND R1, R1, x0
	; Invalid flag
	AND R3, R3, x0
	AND R4, R4, x0
	
	RETRIEVE_NUM
	
		ADD R3, R3, #0
		BRp INVALID_NUM
		
		GETC
		ADD R2, R0, #0
		
		LD R5, NEWLINE_CHECK
		ADD R5, R2, R5
		BRz END_RETRIEVE_NUM
		
		ADD R4, R4, #0
		BRz POS_SIGN_SKIP
		
		DECIMAL_CHECK
		LD R5, NINE_4600
		ADD R5, R2, R5
		BRnz VALID_CHECK
		
		INVALID_FLAG_TOGGLE
		; Fails first valid check toggle flag
		ADD R3, R3, #1
		BR RETRIEVE_NUM
	END_RETRIEVE_NUM
	
	; Flag check for invalid
	ADD R3, R3, #0
	BRp INVALID_NUM
	ADD R4, R4, #0
	BRz INVALID_NUM
	; Out of bounds
	LD R2, FIFTEEN_4600
	ADD R5, R1, R2
	BRp INVALID_NUM
	
LD R7, BACKUP_R7_4600
RET

POS_SIGN_SKIP
	ADD R4, R4, #1
	LD R5, POS_4600
	ADD R5, R2, R5
	BRz VALID_CONTINUE
	BR DECIMAL_CHECK

VALID_CHECK
	LD R5, ZERO_4600
	ADD R1, R1, #0
	BRp NEXT_NUM
	
	ADD R1, R2, R5
	BRzp VALID_CONTINUE
	BR INVALID_FLAG_TOGGLE
	
VALID_CONTINUE
	OUT
	BR RETRIEVE_NUM
	
NEXT_NUM
	ADD R5, R2, R5
	BRn INVALID_FLAG_TOGGLE
	
	OUT
	AND R6, R6, x0
	ADD R6, R6, #9
	AND R2, R2, x0
	ADD R2, R1, #0
	MULTIPLY_TEN
		ADD R1, R1, R2
		ADD R6, R6, #-1
		BRp MULTIPLY_TEN
	ADD R1, R1, R5
	BR RETRIEVE_NUM

INVALID_NUM
	OUT
	LD R0, NEWLINE_4600
	OUT
	LEA R0, Error_msg_2
	PUTS
	LEA R0, prompt
	PUTS
	AND R1, R1, x0
	AND R3, R3, x0
	AND R4, R4, x0
	BR RETRIEVE_NUM
;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"
BACKUP_R7_4600	.BLKW #1
NEWLINE_4600	.FILL x0A
NEWLINE_CHECK	.FILL #-10
POS_4600		.FILL #-43
ZERO_4600		.FILL #-48
NINE_4600		.FILL #-57
FIFTEEN_4600	.FILL #-15

	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,16}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
;                WITHOUT leading 0's, a leading sign, or a trailing newline.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4800
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
ST R0, BACKUP_R0_4800
ST R1, BACKUP_R1_4800
ST R2, BACKUP_R2_4800
ST R3, BACKUP_R3_4800
ST R4, BACKUP_R4_4800
ST R5, BACKUP_R5_4800
ST R6, BACKUP_R6_4800
ST R7, BACKUP_R7_4800
	
	LD R2, TEN_4800	
	ADD R3, R1, R2
	BRzp PRINT_TEN
	AND R2, R2, x0
	AND R3, R3, x0
	ADD R2, R2, #-1
	ONES
		LD R0, ZERO_4800
		ADD R0, R0, R1
		OUT
		BR RETURN_4800
				
END_4800
LD R0, ZERO_4800
OUT

RETURN_4800
LD R0, BACKUP_R0_4800
LD R1, BACKUP_R1_4800
LD R2, BACKUP_R2_4800
LD R3, BACKUP_R3_4800
LD R4, BACKUP_R4_4800
LD R5, BACKUP_R5_4800
LD R6, BACKUP_R6_4800
LD R7, BACKUP_R7_4800
RET

PRINT_TEN
	ADD R1, R1, R2
	LD R0, ONE_4800
	OUT
	ADD R1, R1, #0
	BRz END_4800
	BR ONES

;--------------------------------
;Data for subroutine print number
;--------------------------------
BACKUP_R0_4800	.BLKW #1
BACKUP_R1_4800	.BLKW #1
BACKUP_R2_4800	.BLKW #1
BACKUP_R3_4800	.BLKW #1
BACKUP_R4_4800	.BLKW #1
BACKUP_R5_4800	.BLKW #1
BACKUP_R6_4800	.BLKW #1
BACKUP_R7_4800	.BLKW #1
ZERO_4800		.FILL #48
ONE_4800		.FILL #49
TEN_4800		.FILL #-10

.ORIG x5000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xB600			; Remote data
BUSYNESS .FILL x0000		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END
