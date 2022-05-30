; This program inputs values for num1, num2, num3 and calculates the result of 
; the expression 
; ( (num1 ^ 3) * num2 + 5 * ( num2 ^ 2) ) / num3.
; 10/14/2021

INCLUDE Irvine32.inc

.data
str1 byte "num1 = ", 0
str2 byte "num2 = ", 0
str3 byte "num3 = ", 0
str4 byte "((num1 ^ 3) * num2 + 5 * ( num2 ^ 2)) / num3 = ", 0
str5 byte " R ", 0
num1 dword ?
num2 dword ?
num3 dword ?

.code
main PROC

	;Input part:
	
	;asks for user input
	mov edx, offset str1
	call writeString

	;reads user input
	call readDec
	mov num1, eax

	;asks for user input (for num2)
	mov edx, offset str2
	call writeString

	;reads user input (for num2)
	call readDec
	mov num2, eax

	;asks for user input (for num3)
	mov edx, offset str3
	call writeString

	;reads user input (for num3)
	call readDec
	mov num3, eax

	;Calculation part: 


	; (num1 ^ 3) (inside ebx)
	mov eax, num1
	mul eax
	mul num1
	mov ebx, eax

	; ( num2 ^ 2) (inside ecx)
	mov eax, num2
	mul eax
	mov ecx, eax

	; (num1 ^ 3) * num2 (overrides ebx)
	mov eax, ebx
	mul num2
	mov ebx, eax

	; 5 * ( num2 ^ 2) (overrides ecx)
	mov eax, 5
	mul ecx
	mov ecx, eax

	; (num1 ^ 3) * num2 + 5 * ( num2 ^ 2))
	; 	Has value for top of division in ebx then moves to eax
	add ebx, ecx
	mov eax, ebx

	; does division and moves remainder into ebx for later use
	mov ebx, num3
	div ebx
	mov ebx, edx

	;Output

	;Displayes expression and quotient 
	mov edx, offset str4
	call writeString
	call writeDec

	;displays remainder
	mov edx, offset str5
	call writeString
	mov eax, ebx
	call writeDec

	comment !
	Output/Result:
		num1 = 1
		num2 = 2
		num3 = 3
		((num1 ^ 3) * num2 + 5 * ( num2 ^ 2)) / num3 = 7 R 1
	!

	exit
main ENDP
END main