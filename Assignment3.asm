; This program inputs values for num1, num2, num3 and calculates the result of 
; the expression 
; ( (num1 ^ 3) * num2 + 5 * ( num2 ^ 2) ) / num3
; 10/14/2021

INCLUDE Irvine32.inc

.data
num1Str byte "num1 = ", 0
num2Str byte "num2 = ", 0
num3Str byte "num3 = ", 0
outputStr byte "((num1 ^ 3) * num2 + 5 * ( num2 ^ 2)) / num3 = ", 0
remainderStr byte " R ", 0
num1 word ?
num2 word ?
num3 word ?

.code
main PROC

	;Input part:
	
	;asks for user input
	mov edx, offset num1Str
	call writeString

	;reads user input
	call readDec
	mov num1, ax

	;asks for user input (for num2)
	mov edx, offset num2Str
	call writeString

	;reads user input (for num2)
	call readDec
	mov num2, ax

	;asks for user input (for num3)
	mov edx, offset num3Str
	call writeString

	;reads user input (for num3)
	call readDec
	mov num3, ax

	;Calculation part: 


	; (num1 ^ 3) (inside bx)
	mov ax, num1
	mul ax
	mul num1
	sub ebx, ebx
	mov bx, ax

	; ( num2 ^ 2) (inside cx)
	mov ax, num2
	mul ax
	sub ecx, ecx
	mov cx, ax

	; (num1 ^ 3) * num2 (overrides bx)
	mov ax, bx
	mul num2
	mov bx, ax

	; 5 * ( num2 ^ 2) (overrides cx)
	mov ax, 5
	mul cx
	mov cx, ax

	; (num1 ^ 3) * num2 + 5 * ( num2 ^ 2))
	; 	Has value for top of division in bx then moves to ax
	add bx, cx
	mov ax, bx

	; does division and moves remainder into cx and quotient into bx
	sub edx, edx
	mov bx, num3
	div bx
	mov bx, ax
	mov cx, dx
	

	;Output

	;Displayes expression and quotient 
	mov edx, offset outputStr
	call writeString
	sub eax, eax
	mov ax, bx
	call writeDec

	;Displays remainder character
	mov edx, offset remainderStr
	call writeString
	
	;Clears eax again so it doesn't display quotient in ax
	;Then displays remainder value
	sub eax, eax	
	mov ax, cx
	call writeDec

	comment !
	Output/Result/Console:
		num1 = 1
		num2 = 2
		num3 = 3
		((num1 ^ 3) * num2 + 5 * ( num2 ^ 2)) / num3 = 7 R 1
	!

	exit
main ENDP
END main