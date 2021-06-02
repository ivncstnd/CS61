;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 5, ex 1
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instructions
	LD R1, Array_PTR
	LD R2, SIZE
	LD R3, START
	DO_WHILE_LOOP
		STR R3, R1, #0
		ADD R1, R1, #1
		ADD R3, R3, R3	; Bit-shift input number to the left to double
		ADD R2, R2, #-1
		BRp DO_WHILE_LOOP
		
	LD R1, Array_PTR
	LD R2, SIZE
	DO_PRINT_LOOP
		LD R6, SUB_PRINT_BIN
		JSRR R6
		ADD R1, R1, #1	
		ADD R2, R2, #-1
		BRp DO_PRINT_LOOP
	
	HALT
	; Local Data
	START			.FILL	x1
	SIZE			.FILL	#10
	Array_PTR		.FILL	x4000
	SUB_PRINT_BIN	.FILL	x3200
	
;=================================================
; subroutine : SUB_PRINT_BIN_3200
; Input (R4) : pass the value from the array
; Postcondition : the subroutine prints the binary number from array
; Return value : void
;=================================================

.ORIG x3200

ST R2, BACKUP_R2_3200
ST R7, BACKUP_R7_3200

LDR R4, R1, #0
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

LD R2, BACKUP_R2_3200
LD R7, BACKUP_R7_3200

RET
;---------------	
;Data
;---------------
BACKUP_R2_3200	.BLKW	#1
BACKUP_R7_3200	.BLKW	#1
I			.FILL    x10     ; Where i = 16; i > 0; --i (newline)
J			.FILL    x4		; Where j = 4; j > 0; --j (space)
NEWLINE		.STRINGZ "\n"
SPACE       .STRINGZ " "
ASCIIONE    .STRINGZ "1"
ASCIIZERO   .STRINGZ "0"


.ORIG x4000
	.BLKW	#10
		
.END
