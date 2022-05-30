; 10/28/2021
; Program gets user input and saves it to an array. Then calculates the
; mean and sum. Then it displays the array and shifts the values inside
; the array

include irvine32.inc

.data

; string variables
enterStr byte "Please enter a number: ", 0
sumStr byte "The sum is: ", 0
meanStr byte "The mean is: ", 0
spaceStr byte " ", 0
remainderStr byte "/", 0
ogArrayStr byte "The original array: ", 0
rotationStr byte "After a rotation: ", 0

; non string variables
arr dword 10 DUP(?)
sumVal dword ?
count dword 0
roationFront dword 0
switches dword ?

.code
main proc
	
	;INPUT INFORMATION

	; sets ecx for a loop
	mov ecx, LENGTHOF arr 

	; moves address of array to esi so it's a pointer
	mov esi, offset arr

	; subs ebx for sum calculations (so it's known ebx is 0)
	sub ebx, ebx

	; This loop gets user input
	loopInput:

		; prompts user to enter a number and reads input
		mov edx, offset enterStr
		call writeString
		; subs eax so future iterations don't have previous values in eax
		sub eax, eax
		call readDec

		; moves user input from eax into the array
		mov [esi], eax

		; adds input value to running total (uses ebx because faster)
		add ebx, eax
		
		; increments counter (used to calculate mean)
		inc count

		; increments pointer to next dword location
		add esi, type arr

		loop loopInput


	; SUM AND MEAN INFORMATION


	; moves running total into a variable
	mov sumVal, ebx

	; displays text for sum 
	mov edx, offset sumStr
	call writeString

	;displays sum VALUE (sum found with running total in loopInput)
	sub eax, eax
	mov eax, sumVal
	call writeDec

	call crlf

	;Calculation for mean (clears any random values)
	sub eax, eax
	sub edx, edx
	sub ebx, ebx
	mov eax, sumVal

	; Quotient: EAX Remainder: EDX
	div count			

	; saves edx in ebx so edx can call writestring
	mov ebx, edx		

	; output mean strings
	mov edx, offset meanStr
	call writeString

	; pulls from eax and writes value for the mean
	call writeDec		
	
	; makes a space between remainder and quotient
	mov edx, offset spaceStr
	call writeString
	
	; prints remainder for the mean
	mov eax, ebx
	call writeDec
	mov edx, offset remainderStr
	call writeString

	mov eax, LengthOf arr
	call writeDec

	call crlf


	; ORIGINAL ARRAY INFORMATION


	; prints the text saying it's the original array
	mov edx, offset ogArrayStr
	call writeString

	; moves space string in edx so it can be used in the loop
	sub edx, edx
	mov edx, offset spaceStr
	
	; moves address of array to esi (resets esi)
	mov esi, offset arr

	; set ecx = length of array (for original loop)
	mov ecx, LengthOf arr
	sub eax, eax

	; prints out values for the array before any rotations
	originalArray:
		
		; move into eax because writedec takes eax
		mov eax, [esi]

		call writeDec

		call writeString

		; increments pointer (points to dword AFTER the array)
		add esi, type arr

		Loop originalArray


	; INFORMATION ABOUT ROTATIONS


	; calculate values for future loops
	mov ecx, LENGTHOF arr
	dec ecx
	mov switches, ecx
	
	; Sub registers to use later (EBX = holds ecx | EAX = holds values)
	sub ebx, ebx
	sub eax, eax

	; prints new line
	call crlf

	;Rotates values in array 
	rotationArray:
		
		; moves and prints string to say it's after a rotation into edx 
		mov edx, offset rotationStr
		call writeString

		; puts pointer to last dword in the array (from dword after array)
		sub esi, type arr
		
		; saves ecx value for main loop
		mov ebx, ecx
		 
		; changes ecx's value to be the correct amount for switching values
		mov ecx, switches

		; Indivudual roations --> changes values inside EACH rotation
		individualRotations:
			
			; holds value closer to end of array in eax
			mov eax, [esi]

			; make pointer point to element before it
			sub esi, type arr

			; saves value in edx (value closer to start)
			mov edx, [esi]

			; moves value closer to end into closer to front location
			xchg eax, [esi]

			; moves farther into array and puts the previous value into
			; the farther location in the array (completes exchange)
			add esi, type arr
			xchg edx, [esi]

			; moves pointer back to 
			sub esi, type arr
			Loop individualRotations
		
		; moves in quantity of array elements into ecx for output loop
		mov ecx, LengthOf arr

		; move address of array to esi to reset it to start
		mov esi, offset arr

		; prints array after the rotation has been completed
		printLoop:

			; move into eax because writedec takes eax
			mov eax, [esi]

			call writeDec

			; writes a space
			mov edx, offset spaceStr
			call writeString

			; increments pointer (points to dword AFTER the array)
			add esi, type arr

			Loop printLoop

		; makes a new line
		call crlf

		; resets ecx to continue the main loop
		mov ecx, ebx
	
		; decreses amount of switches in the array that need to be made
		dec switches

		Loop rotationArray

	exit
main endp
end main

comment !
 My output:

	Please enter a number: 2
	Please enter a number: 3
	Please enter a number: 4
	Please enter a number: 5
	Please enter a number: 6
	Please enter a number: 7
	Please enter a number: 8
	Please enter a number: 9
	Please enter a number: 0
	Please enter a number: 10
	The sum is: 54
	The mean is: 5 4/10
	The original array: 2 3 4 5 6 7 8 9 0 10
	After a rotation: 10 2 3 4 5 6 7 8 9 0
	After a rotation: 10 0 2 3 4 5 6 7 8 9
	After a rotation: 10 0 9 2 3 4 5 6 7 8
	After a rotation: 10 0 9 8 2 3 4 5 6 7
	After a rotation: 10 0 9 8 7 2 3 4 5 6
	After a rotation: 10 0 9 8 7 6 2 3 4 5
	After a rotation: 10 0 9 8 7 6 5 2 3 4
	After a rotation: 10 0 9 8 7 6 5 4 2 3
	After a rotation: 10 0 9 8 7 6 5 4 3 2

	E:\Project32_VS2019\Debug\Project.exe (process 14484) exited with code 0.
	Press any key to close this window . . .

!