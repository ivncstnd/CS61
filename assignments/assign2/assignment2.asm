;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Ivan Castaneda
; Email: icast016@ucr.edu
; 
; Assignment name: Assignment 2
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

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
	GETC					; Get first number
	OUT						; Print
	ADD R1, R0, #0			; Move to register 1
	LD R0, newline			; Load newline
	OUT						; Print

	GETC					; Repeat for second number
	OUT						
	ADD R2, R0, #0			
	LD R0, newline			
	OUT						

	ADD R0, R1, #0			
	OUT						
	LEA R0, subtracts		; Load subtraction sign
	PUTS					
	ADD R0, R2, #0			
	OUT						
	LEA R0, equals			; Load equal sign
	PUTS					

	LD R5, HEX_30			; Load R5 with #48 for ASCII -> Dec
	NOT R5, R5				; Invert #48 to -48
	ADD R3, R2, R5			; Load R3 with second input - 48
	NOT R3, R3				; Invert second input to a negative
	ADD R4, R1, R5			; Load R4 with first input - 48
	ADD R4, R4, #1			; Readjust by adding #1
	ADD R4, R4, R3			; Complete the operation 

	BRn IF_NEGATIVE_BRANCH	; If resultant is < 0
	
	NOT R5, R5				; Reverse the previous invert
	ADD R4, R4, R5			; Revert to ASCII
	ADD R0, R4, #0
	OUT						; Print resultant
	LD R0, newline
	OUT

	HALT					; Stop execution of program


	IF_NEGATIVE_BRANCH		; When branching, always place new branch at
							; the end of the program, NEVER after the 
							; condition.
							
	NOT R4, R4				; Invert resultant
	ADD R4, R4, #1			; Add 1 to comply with 2's complement
	
	NOT R5, R5				
	ADD R4, R4, R5			
		
	LEA R0, negative		
	PUTS					
	ADD R0, R4, #0
	OUT						
	LD R0, newline
	OUT
		
	HALT
	
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'		; newline character - use with LD followed by OUT
equals .STRINGZ " = "	; equal sign string
subtracts .STRINGZ " - " ; substraction sign 
negative .STRINGZ "-"	; negative  difference
HEX_30 .FILL x30		; Dec #48 for ASCII switching
;---------------	
;END of PROGRAM
;---------------	
.END

