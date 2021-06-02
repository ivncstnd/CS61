;=================================================
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Lab: lab 3, ex 4
; Lab section: 023
; TA: Shirin Shirazi
; 
;=================================================

.ORIG x3000

	; Instruction
	LD R1, ARRPTR
	
	READ_INPUT_LOOP
		GETC
		OUT
		STR R0, R1, #0				; Store character into array
		ADD R1, R1, #1				; Increment pointer
		ADD R0, R0, -x0A			; Check if entered char is a newline
		BRnp READ_INPUT_LOOP
	END_READ_INPUT_LOOP
	
	AND R2, R2, x00					; Set a null to the end of array
	STR R2, R1, #0
	
	LD R1, ARRPTR					; Reset pointer
	
	PRINT_OUTPUT_LOOP	
		LDR R0, R1, #0				; Load R0 with contents from R1
		ADD R2, R0, #0

		OUT							; Print
		ADD R2, R0, #0				; Store R2 with R0's print
		
		ADD R1, R1, #1				; Increment pointer
		ADD R2, R2, #0				; Check if current char is null
		BRnp PRINT_OUTPUT_LOOP
	END_PRINT_OUTPUT_LOOP
		
	HALT
		
	; Local Data
	ARRPTR	.FILL		x4000		; Current array pointer
	
.END
