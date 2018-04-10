;
; Lab02.asm
;
; Created: 23/03/18 2:21:40 PM
; Author : cindy
;


; Replace with your application code


/* 
Part A – Reverse String (2 Marks)
Implement a program that loads a null-terminated string from program memory and pushes it onto
the stack, then writes out the reversed string into data memory. The stack pointer must be
initialized before use.
Eg "abc",0 will be stored in RAM as "cba",0
*/

.def counter = r16				
.set size = 5					//size of string is 5 (not including null terminator)

.dseg 
	reversed: .byte size +1		//allocate space for string of size 5 + 1 for null terminator

.cseg							//starting program memory segment
	string:	.db "hello",0		//load null terminated string into program memory


start: 
	clr counter							//make sure r16 is 0
	ldi YL, low(reversed)			//store address of reversed into Y
	ldi YH, high(reversed) 

	ldi ZL, low(string << 1)		//load address of string into Z pointer
	ldi ZH, high(string << 1)

	ldi XL, low(RAMEND - size)			//allocate space to store *size bytes 
	ldi XH, high(RAMEND - size)	

	out SPH, XH					//adjust stack pointer to point to new stack top
	out SPL, XL

store:
	lpm r17, Z+						//load character from prog mem into r17, increment Z pointer
	cpi r17, 0						//check if it is the null character
	breq reverse					//finish STORE if it is end of string
	push r17						//push r17 onto stack, SP will decrement here, so string will be stored onto stack "backwards"
	rjmp store						//go back and repeat loop

reverse:
	//in SPH, XH					//adjust X to stack pointer placement
	//in SPL, XL
	
	cpi counter, size				//check that counter is less than size (ie we are not at the end of the string yet)
	brge stringEnd					//otherwise branch 
	pop r17							//pop top of stack into r17, string has been reversed while being store on stack, can be directly popped and will be reversed already
	st Y+, r17						//store r17 into data memory, increase Y
	inc counter						//increment counter
	rjmp reverse					//go back and loop

stringEnd:
	clr r17							//make sure r17 is 0
	st Y, r17						//store null terminator 
	rjmp end

end:
	rjmp end