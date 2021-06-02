;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 023
; TA: Shirin Shirazi
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R1
;=================================================================================

					.ORIG x3000		
;-------------
;Instructions
;-------------

	; output intro prompt
	LD R0, introPromptPtr
	PUTS
	
	; load index count (R3) and sign bit (R4) and stored decimal (R1)
	LD  R3, INDEX
	AND R4, R4, x0
	AND R1, R1, x0
	
	FOR_LOOP
		; if index count is 0, end loop
		ADD R3, R3, #0
		BRz END_FOR_LOOP
		
		; get char and load into R2
		GETC
		ADD R2, R0, #0		
		
		; all char checks happen between R2 (true char) and R5 (char check)
		
		; check if char is newline and end program true
		LD R5, NEWLINE
		NOT R5, R5
		ADD R5, R5, #1
		ADD R6, R2, R5	
		BRz	END_FOR_LOOP
		
		; check if index has been decremented
		ADD R6, R3, #-6
		BRn WHEN_INDEX_DECREMENTED
		
		; if not, check for negative / postive sign
		LD R5, NEGSIGN
		NOT R5, R5
		ADD R5, R5, #1
		ADD R6, R2, R5
		BRz NEG_CONTINUE
		
		LD R5, POSSIGN
		NOT R5, R5
		ADD R5, R5, #1
		ADD R6, R2, R5
		BRz POS_CONTINUE
		
		; if decremented is true
		WHEN_INDEX_DECREMENTED
			; check if char is within 0-9 ascii range
			LD R5, NINE
			NOT R5, R5
			ADD R5, R5, #1
			ADD R6, R2, R5
			BRnz VALID_CHECK
		
		; if all checks fail, load error and reload loop
		OUT
		LD R0, NEWLINE
		OUT
		LD R0, errorMessagePtr
		PUTS
		LD R0, introPromptPtr
		PUTS
		LD R3, INDEX
		AND R4, R4, x0
		BR FOR_LOOP
	END_FOR_LOOP
	
	; if sign bit is toggled 1
	ADD R4, R4, #-1
	BRn POS_NUM
	NOT R1, R1
	ADD R1, R1, #1
	
	; end newline
	POS_NUM
		LD R0, NEWLINE
		OUT
	
	HALT
	
	NEG_CONTINUE
		; output the character, toggle negative flag and decrement index
		OUT
		ADD R4, R4, #1
		ADD R3, R3, -#1
		BR FOR_LOOP
		
	POS_CONTINUE
		; output the character and decrement index
		OUT
		ADD R3, R3, #-1
		BR FOR_LOOP
		
	VALID_CONTINUE
		OUT
		; if loop only decremented once to input sign
		ADD R6, R3, #-6
		BRz DEC_ONE
		ADD R3, R3, #-1
		BR FOR_LOOP
		DEC_ONE
			ADD R3, R3, #-2
			BR FOR_LOOP
	
	NEXT_NUM
		; if loop had been decremented add to R6 to check if valid
		ADD R5, R2, R5
		BRn INVALID_NUM
		
		; if valid, output and multiply R1 by 10, add, and increment 
		OUT
		AND R6, R6, x0
		ADD R6, R6, #9
		AND R2, R2, x0
		ADD R2, R1, #0
		BR MULTIPLY_TEN
		MULTIPLY_TEN
			ADD R1, R1, R2
			ADD R6, R6, #-1
			BRp MULTIPLY_TEN
		ADD R1, R1, R5
		ADD R3, R3, #-1
		BR FOR_LOOP
		
		; if invalid, error and reload loop
		INVALID_NUM
		OUT
		LD R0, NEWLINE
		OUT
		LD R0, errorMessagePtr
		PUTS
		LD R0, introPromptPtr
		PUTS
		LD R3, INDEX
		AND R4, R4, x0
		BR FOR_LOOP
		 
	VALID_CHECK
		; find 2's complement of ascii zero
		LD R5, ZERO
		NOT R5, R5
		ADD R5, R5, #1
		
		; check if loop has been decremented
		ADD R6, R3, #-5
		BRn NEXT_NUM
		
		; if not decremented add to R1 and check if valid first char
		ADD R1, R2, R5
		BRzp VALID_CONTINUE
		
		; if not output the char and reload loop
		OUT
		LD R0, NEWLINE
		OUT
		LD R0, errorMessagePtr
		PUTS
		LD R0, introPromptPtr
		PUTS
		LD R3, INDEX
		AND R4, R4, x0
		BR FOR_LOOP
		
;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xB000
errorMessagePtr		.FILL xB200
INDEX				.FILL x6
NEWLINE				.FILL xA
POSSIGN				.FILL x2B
NEGSIGN				.FILL x2D
ZERO				.FILL x30
NINE				.FILL x39	

;------------
; Remote data
;------------
					.ORIG xB000			; intro prompt
					.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG xB200			; error message
					.STRINGZ	"ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
