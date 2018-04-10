;
; Lab02.asm
;
; Created: 23/03/18 2:21:40 PM
; Author : cindy
;


; Replace with your application code

/*
Part B – Function Calls (4 Marks)
The following code calls a function named checkalpha twice to evaluate if two strings contains only
alpha characters (a-z and A-Z).

Complete the code by adding the stack initialization code and writing an implementation of
checkalpha. The above code should not be modified apart from adding the stack initialization code.
checkalpha should take a pointer to the string in the Z register, and return in r16 either 1 (if the
string was alpha-only) or 0 (if the string contained non-alpha characters).
The C signature for checkalpha would be:
int checkalpha(char *str);

*/

.include "m2560def.inc"


.cseg
	rjmp start
	validstring:	.db "abcdABCD", 0
	invalidstring:	.db "74(*&Q#$^}{:?<>", 0

start:

; !!! Insert stack initialization code here !!!
	.equ TRUE = 1
	.equ FALSE = 0
	.equ upperA = 65
	.equ upperZ = 91
	.equ lowerA = 97
	.equ lowerZ = 123



	ldi YL, low(RAMEND)
	ldi YH, high(RAMEND)
	out SPL, YL
	out SPH, YH


; end of stack initialisation

	ldi ZL, low(validstring << 1)
	ldi ZH, high(validstring << 1)
	call checkalpha
	mov r20, r16
	

; r20 should be 1


	ldi ZL, low(invalidstring << 1)
	ldi ZH, high(invalidstring << 1)
	call checkalpha
	mov r21, r16


; r21 should be 0


halt:
	rjmp halt

//function
checkalpha:
	//prologue
	push YL
	push YH
	push r17
	in YL, SPL
	in YH, SPH
	ldi r16, TRUE

function:
	lpm r17, Z+
	cpi r17, 0
	breq epilogue
	cpi r17, upperA
	brlt invalid
	cpi r17, lowerZ
	brge invalid
	cpi r17, upperZ
	brge checklower
	rjmp function

checklower:
	cpi r17, lowerA
	brlt invalid
	rjmp function

invalid:
	ldi r16, FALSE
	rjmp epilogue

epilogue:
	out SPH, YH
	out SPL, YL
	pop r17
	pop YH
	pop YL
	ret
