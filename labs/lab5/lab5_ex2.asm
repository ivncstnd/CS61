;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 5, ex 2
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000
	
	; MAIN
	
	; Instructions
	
	LD R6, SUB_READ_BIN
	JSRR R6
	
	LD R6, SUB_PRINT_BIN
	JSRR R6
	
	HALT
	; Local Data
	SUB_READ_BIN	.FILL	x3200
	SUB_PRINT_BIN	.FILL	x3400
	
;=================================================
; subroutine : SUB_READ_BIN_3200
; Input (R0) : get characters input read from keyboard
; Postcondition : the subroutine reads a 16-bit bit binary number and stores into R2
; Return value : R2 16-bit binary
;=================================================

.ORIG x3200

	ST R7, BACKUP_R7_3200
	
	; Insturctions
	LEA R0, START
	PUTS
	
	
	AND R2, R2, x0
	LD R1, COUNTER
	GETC
	DO_WHILE_LOOP
		GETC
		ADD R2, R2, R2
		LD R4, DEC_ZERO
		NOT R4, R4
		ADD R4, R4, #1
		ADD R0, R0, R4
		ADD R2, R2, R0
		ADD R1, R1, #-1
		BRp DO_WHILE_LOOP
	END_DO_WHILE_LOOP
	
	LD R7, BACKUP_R7_3200
	
	RET
	; Local Data
	BACKUP_R7_3200	.BLKW #1
	COUNTER		.FILL	x10
	DEC_ZERO	.STRINGZ	"0"
	START 		.STRINGZ	"Enter a 2's complement 16-bit binary number start with b and no spaces.\n"

;=================================================
; subroutine : SUB_PRINT_BIN_3400
; Input (R2) : pass the value from the input
; Postcondition : the subroutine prints the binary number from array
; Return value : void
;=================================================

.ORIG x3400

ST R2, BACKUP_R2_3400
ST R7, BACKUP_R7_3400

ADD R4, R2, #0
LD R2, I				; Main iterator
LD R3, J				; Space iterator
FOR_LOOP
	ADD R2, R2, #0
	BRnz END_FOR_LOOP	; Check if i <= 0 (exit)
	
	ADD R4, R4, #0
	IF_POSITIVE			; Check if R1 positive and jump to print 0
		BRzp PRINT_ZERO
	ELSE				; Else print 1
		LEA R0, ASCIIONE
		PUTS
		ADD R4, R4, R4	; Bitshift left
		ADD R2, R2, #-1	; Decrement main index
		BRz PRINT_NEWLINE
		ADD R3, R3, #-1 ; Decrement new space index
		BRz PRINT_SPACE
		BR END_IF		; Restart for loop
		
	PRINT_ZERO			; Positive branch
		LEA R0, ASCIIZERO
		PUTS
		ADD R4, R4, R4
		ADD R2, R2, #-1
		BRz PRINT_NEWLINE
		ADD R3, R3, #-1
		BRz PRINT_SPACE
	END_IF	
	BR FOR_LOOP

	; Print fucntions
	PRINT_NEWLINE
		LEA R0, NEWLINE
		PUTS
		BR END_FOR_LOOP
		
	PRINT_SPACE
		LEA R0, SPACE
		PUTS
		LD R3, J		; Reload space index
		BR FOR_LOOP		; Restart for loop
			
END_FOR_LOOP ; End loop

LD R2, BACKUP_R2_3400
LD R7, BACKUP_R7_3400

RET
;---------------	
;Data
;---------------
BACKUP_R2_3400	.BLKW	#1
BACKUP_R7_3400	.BLKW	#1
I			.FILL    x10     ; Where i = 16; i > 0; --i (newline)
J			.FILL    x4		; Where j = 4; j > 0; --j (space)
NEWLINE		.STRINGZ "\n"
SPACE       .STRINGZ " "
ASCIIONE    .STRINGZ "1"
ASCIIZERO   .STRINGZ "0"

.END


