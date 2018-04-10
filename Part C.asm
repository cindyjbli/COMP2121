;
; Lab02.asm
;
; Created: 23/03/18 2:21:40 PM
; Author : cindy
;
/*
Implement a superior string-checking function named checkstring that can check all characters in
the string match an arbitrary predicate, by calling a function to check each character. The function
used for checking must be passed as a function pointer.
The C signature for checkstring would be:
int checkstring(char *str, function *predicate);
(where ‘function *’ is the address of a function).
An example predicate would be:
int isdigit(char c)
{
 return c >= '0' && c <= '9 ';
}
checkstring would be called using:
checkstring("12345678", &isdigit);
checkstring should take the pointer to the string in Z, and the pointer to the predicate function in Y.
It should return 1 in r16 if all characters match the predicate, otherwise it should return 0 in r16.
To get full marks, this should be demonstrated with at least two different predicate functions, and
several input strings.
*/


.include "m2560def.inc"

//storing the result of checkstring in r16
//storing the result of the predicate function in r17
//storing the character in r18

.cseg
	rjmp start
	string1:	.db "abcd", 0
	string2:	.db "123412", 0
	string3:	.db "1j2h3ss3f34", 0
	string4:	.db "!@#*$&*(@ |", 0

	.equ true = 1
	.equ false = 0
	.equ digit0 = 48
	.equ digit9 = 57
	.equ lowerA = 97
	.equ lowerZ = 122

	.def char = r18
	.def f_result = r17
	.def cs_result = r16

start:
//checking if function works
	ldi char, 0xDD
	ldi f_result, 0xCD
	ldi cs_result, 0xAA


	ldi YL, low(RAMEND)				
	ldi YH, high(RAMEND)

	out SPL, YL			//the stack pointer to point to the highest SRAM address
	out SPH, YH

//--------------------------------------TEST CASES------------------------------------------
	ldi ZL, low(string1<<1)		//test string1 against isLower
	ldi ZH, high(string1<<1)
	ldi XL, low(isLower)
	ldi XH, high(isLower)
	call checkString

	ldi ZL, low(string1<<1)		//test string1 against isDigit
	ldi ZH, high(string1<<1)
	ldi XL, low(isDigit)
	ldi XH, high(isDigit)
	call checkString

	ldi ZL, low(string2<<1)		//test string2 against isLower
	ldi ZH, high(string2<<1)
	ldi XL, low(isLower)
	ldi XH, high(isLower)
	call checkString

	ldi ZL, low(string2<<1)		//test string2 against isDigit
	ldi ZH, high(string2<<1)
	ldi XL, low(isDigit)
	ldi XH, high(isDigit)
	call checkString

	ldi ZL, low(string3<<1)		//test string3 against isLower
	ldi ZH, high(string3<<1)
	ldi XL, low(isLower)
	ldi XH, high(isLower)
	call checkString

	ldi ZL, low(string3<<1)		//test string3 against isDigit
	ldi ZH, high(string3<<1)
	ldi XL, low(isDigit)
	ldi XH, high(isDigit)
	call checkString
	
	ldi ZL, low(string4<<1)		//test string4 against isLower
	ldi ZH, high(string4<<1)
	ldi XL, low(isLower)
	ldi XH, high(isLower)
	call checkString

	ldi ZL, low(string4<<1)		//test string4 against isDigit
	ldi ZH, high(string4<<1)
	ldi XL, low(isDigit)
	ldi XH, high(isDigit)
	call checkString
	
//------------------------------------------------------------------------------------------
	

end:
	rjmp end


//---------------------------------------checkString function-------------------------------

checkString:
//prologue
	push YL
	push YH
	push char
	push f_result
	in YL, SPL
	in YH, SPH
	ldi cs_result, true

//operation
loop:
	lpm char, Z+
	cpi char, 0
	breq epilogue
	
	push ZL
	push ZH
	mov ZL, XL
	mov ZH, XH
	icall 
	pop ZH
	pop ZL
	
	cpi f_result, false
	breq invalid
	
	rjmp loop

invalid:
	ldi cs_result, false
	rjmp epilogue
	

//epilogue
epilogue:
	out SPH, YH
	out SPL, YL
	pop f_result
	pop char
	pop YH
	pop YL
	ret


//----------------------------------------predicate function isDigit------------------------

isDigit:
//prologue
	push YL
	push YH
	in YL, SPL
	in YH, SPH

	ldi f_result, true
//operation
	cpi char, digit9 + 1
	brge invalidID
	cpi char, digit0
	brlt invalidID
	rjmp epilogueID

	invalidID:
		ldi f_result, false
		rjmp epilogueID
//epilogue
	epilogueID:
		out SPL, YL
		out SPH, YH
		pop YH
		pop YL
		ret


//------------------------------predicate function isLower----------------------------------
isLower:
//prologue
	push YL
	push YH
	in YL, SPL
	in YH, SPH

	ldi f_result, true
//operation
	cpi char, lowerZ + 1
	brge invalidIL
	cpi char, lowerA
	brlt invalidIL
	rjmp epilogueIL

	invalidIL:
		ldi f_result, false
		rjmp epilogueIL
//epilogue
	epilogueIL:
		out SPL, YL
		out SPH, YH
		pop YH
		pop YL
		ret

//------------------------------------------------------------------------------------------




	