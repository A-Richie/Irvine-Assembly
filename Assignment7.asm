Title Assignment 7

COMMENT !
*****************
This program takes a user input to fill an array. Then sorts the inputs/array
in descending order.
date: 11/27/2021
*****************
!

include irvine32.inc
; ===============================================
.data
  
  userArray dword 40 dup(?) 

  ;Instructions to array are 80+ characters. Instructions in 2 parts
  userInstructionStr1 byte "Enter up to 40 unsigned dword integers. ", 0
  userInstructionStr2 byte "To end the array, enter 0.", 0
  promptUserStr byte "After each element press enter:", 0
  initalArrayStr byte "Inital array:", 0
  descendingArrayStr byte "Array sorted in descending order:", 0

;=================================================
.code
main proc

	mov edx, offset userInstructionStr1		;Prints instructions for user
	call writeString
	mov edx, offset userInstructionStr2
	call writeString
	call crlf
	mov edx, offset promptUserStr
	call writeString
	call crlf
								
	xor eax, eax				;Clears all registers
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	sub esp, 4					;Make room for return value
	push offset userArray

	call enter_elem
	
    pop eax						;Saves lengthOf array to eax --> push it
								;later for two different procedures

	mov edx, offset initalArrayStr
	call writeString
	call crlf
	xor edx, edx
	
	push eax
	push offset userArray		;Push address of array to stack

	call crlf
	call print_arr				;Prints original array (through procedure)

	call crlf
	call crlf

	mov edx, offset descendingArrayStr	;Print sorted decending string
	call writeString
	call crlf
	xor edx, edx				;Clears edx from address of the string

	push eax					;Push array length
	
	push offset userArray		;Push address of array to stack
	call sort_arr				;Sorts array

	push eax					;Push array length
	push offset userArray		;Push address of array to stack

	call crlf
	call print_arr				;Prints DESCENDING array (through procedure)

	call crlf

   exit
main endp

; ================================================
; int enter_elem(arr_addr)
;
; Input:
;   ARR_ADDRESS THROUGH THE STACK
; Output:
;   ARR_LENGTH THROUGH THE STACK
; Operation:
;   Fill the array and count the number of elements
;
enter_elem proc
	push ebp					;Keeps track of arguments
	mov ebp, esp				;Make ebp point to what esp points to
	push eax					;Push values to stack --> don't lose values
	push ebx
	push esi
	mov esi, [ebp + 8]			;Store ADDRESS of array in esi

	comment !
		C++ EQUIVALENT CODE FOR THE LOOP
		int index = 0			<-- index for array
		while(index < arrayLength)
		{
			cin >> input;
			if(input == 0)
			{
				break;
			}
			array[index] = input;
			index++;
		}
	!
	
	;Loops through 40 times OR until user inputs 0
	while01:		
		cmp ebx, 40				;Compare the counter register (EBX) with 40
		je endWhile01			;Exit loop if it's > 40.

		call readDec			;Read input --> store in eax
		call crlf
		cmp eax, 0				;Compare input with 0. If zero don't add to
		je endWhile01			;the array. End the loop

		mov [esi], eax			;Put user input into array
		inc ebx
		
		add esi, TYPE DWORD		;Increment esi by 4 (esi & array are dwords)
		jmp while01				;Go back to start of loop
	endWhile01:
	
	mov [ebp + 12], ebx			;Saves return value to stack
	pop esi
	pop ebx
	pop eax
	pop ebp
	ret 4
enter_elem endp

; ================================================
; void print_arr(arr_addr, arr_len)
;
; Input:
;   arr_addr through the stack
;	arr_len  through the stack
; Output:
;   None (no return value. Prints array)
; Operation:
;  print out the array
;

print_arr proc
	push ebp					;Keeps track of arguments
	mov ebp, esp				;Make ebp point to what esp points to

	push eax					;Push registers before altering them
	push ecx
	push esi

	mov esi, [ebp + 8]			;Store ADDRESS of array in esi
	mov ecx, [ebp + 12]			;Store length of array in ecx

	comment !
	C++ equivalent code for print loop
		int index = 0;
		while(counter > 0)
		{
			cout << array[index] << " ";
			index++;
		}
		 
	!
	
	LoopPrint:
		
		mov eax, [esi]			
		call writeDec			;Prints array value
		mov al, ' '				;Prints a space
		call writeChar
		add esi, TYPE DWORD		;Increment esi by 4
	Loop LoopPrint  

	pop esi
	pop ecx
	pop eax
	pop ebp
	ret 8
print_arr endp

; ================================================
; void sort_arr(arr_addr, arr_len)
;
; Input:
;   arr_addr through the stack
;	arr_len  through the stack
; Output:
;    None (no return value)
; Operation:
;   sort the array
;

sort_arr proc																			
    push ebp					;Keeps track of arguments
	mov ebp, esp				;Make ebp point to what esp points to
	push eax					;Save original register values to stack
	push ebx
	push ecx
	push edx
	push esi

	mov esi, [ebp + 8]			;Store ADDRESS of array in esi
	mov ecx, [ebp + 12]			;Store length of array in ecx

	xor edx, edx
	
	comment *
		C++ Equivalent for the loop
		int temp = 0;
		int outer = 0;
		int inner = 0;
        while(outer < length)
        {
            inner = outer + 1;
            while( inner < length)
            {
                call compare_and_swap(x, y)
                inner++;
            }
            outer++;
        }

	*

	mov eax, edx
	inc eax

	outerLoop:
	cmp edx, ecx
	jae endOuterLoop		;Quit if edx > ecx
	
	push edx				;Push outerLoopCounter
	push esi				;Push location comparison location outerLoop use
	mov edx, esi			;Push original location (can't use esi twice
							;						inside the innerLoop)
		innerLoop:
			
			cmp eax, ecx		;if innerLoop >= length. Leave
			jae endInnerLoop

			
			push eax				;Save innerLoop
			push edx				;Push x address
			
			add esi, TYPE DWORD		;Increment by 4
			
			push esi				;Push "y_addr"
			
			call compare_and_swap

			pop eax					;Return outerLoop
			inc eax					;Incremment by one for the while loop
					
		jmp innerLoop
		endInnerLoop:

	pop esi							;Returns to correct location for X
	add esi, TYPE DWORD				;Increments X's location by one
	pop edx							;Return outerLoop value
	inc edx							;Increment outerLoop
	xor eax, eax					;Reset innerLoop value

	jmp outerLoop
	endOuterLoop:

	pop esi
	pop edx
	pop ecx						;Return original values from procedure
	pop ebx
	pop eax
	pop ebp
	ret 8
sort_arr endp

; ===============================================
; void compare_and_swap(x_addr, y_addr)
;
; Input:
;   x_addr through the stack
;	y_addr through the stack
; Output:
;   Nothing
; Operation:
;  compare and call SWAP ONLY IF Y < X 
;

compare_and_swap proc
	push ebp					;Keeps track of arguments
	mov ebp, esp				;Make ebp point to what esp points to

	push esi					;Save values to pop later
	push edx
	push eax
	push ebx
	push ecx

	mov esi, [ebp + 8]			;X's address
	mov edx, [ebp + 12]			;Y's address
			
	mov ebx, [esi]				;[esi + 4]'s value Y's value
	mov eax, [edx]				;[Esi] value X's Value

	
	comment !
	C++ equivalent code for an if statment
	if (number[outer] < number[inner])
	{
			swap(x_addr, y_addr)
	}	
	!

	cmp eax, ebx
	jae out01				;Jump / don't do anything if x >= y

	push esi				;Push paramaters to stack for swap procedure
	push edx

	call swap				;Call swap procedure 

	out01:

	pop ecx
	pop ebx
	pop eax
	pop edx
	pop esi						;Return original values
	pop ebp
	ret 8
compare_and_swap endp

; =================================================
; void swap(x_addr, y_addr)
;
; Input:
;   x_addr through the stack
;	y_addr  through the stack
; Output:
;   Nothing
; Operation:
;  swap the two inputs
;

swap proc
	push ebp				;Keeps track of arguments
	mov ebp, esp			;Make ebp point to what esp points to
	
	push esi				;Perseve values
	push eax
	push ebx
	push ecx
	push edx

	mov esi, [ebp + 8]		;X's address
	mov edx, [ebp + 12]		;Y's address
	
	mov eax, [edx]			;[Esi] value X's Value
	mov ebx, [esi]			;[esi + 4]'s value Y's value

	push ecx				;Saves ECX value

	mov ecx, eax			;Swaps values inside registers
	mov eax, ebx
	mov ebx, ecx

	mov [esi], ebx			;Moves swapped values to array
	mov [edx], eax

	pop ecx					;Return ecx value --> arrayLength

	pop edx
	pop ecx
	pop ebx
	pop eax
	pop esi
	pop ebp
	ret 8
swap endp

end main


comment *
	Example run

	Enter up to 40 unsigned dword integers. To end the array, enter 0.
	After each element press enter:
	666

	69

	24

	1

	34

	2

	84

	0

	Inital array:

	666 69 24 1 34 2 84

	Array sorted in descending order:

	666 84 69 34 24 2 1

*