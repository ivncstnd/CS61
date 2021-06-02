;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 023
; TA: Shirin Shirazi
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_ptr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
LD R2, I				; Main iterator
LD R3, J				; Space iterator
FOR_LOOP
	ADD R2, R2, #0
	BRnz END_FOR_LOOP	; Check if i <= 0 (exit)
	
	ADD R1, R1, #0
	IF_POSITIVE			; Check if R1 positive and jump to print 0
		BRzp PRINT_ZERO
	ELSE				; Else print 1
		LEA R0, ASCIIONE
		PUTS
		ADD R1, R1, R1	; Bitshift left
		ADD R2, R2, #-1	; Decrement main index
		BRz PRINT_NEWLINE
		ADD R3, R3, #-1 ; Decrement new space index
		BRz PRINT_SPACE
		BR END_IF		; Restart for loop
		
	PRINT_ZERO			; Positive branch
		LEA R0, ASCIIZERO
		PUTS
		ADD R1, R1, R1
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

HALT
;---------------	
;Data
;---------------
Value_ptr	.FILL    xCB00	; The address where value to be displayed is stored
I			.FILL    x10     ; Where i = 16; i > 0; --i (newline)
J			.FILL    x4		; Where j = 4; j > 0; --j (space)
NEWLINE		.STRINGZ "\n"
SPACE       .STRINGZ " "
ASCIIONE    .STRINGZ "1"
ASCIIZERO   .STRINGZ "0"

.ORIG xCB00			; Remote data
Value .FILL x0100		; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
