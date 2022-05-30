;What program Does: Creates a two dimensional array from user inputs. Then
;					finds the sum of a user selected row
;Date: 12/1/21

include irvine32.inc
.data
numElementStr byte "Enter how many elements in your array: ", 0
numElementErr byte "Error: Please enter a value of at most 40.", 0
numRowStr byte "Enter the row size: ", 0
typeArrayStr byte "Enter the type of your array.", 0
typeOneStr byte "1 for byte.", 0
typeTwoStr byte "2 for word.", 0
typeThreeStr byte "4 for doubleword.", 0
enterElementStr byte "Enter an element in your array, ", 0
selectRowStr byte "Enter row number that you want me to sum: ", 0
sumStr byte "The sum is: ", 0
pressKeyStr byte "Press any key to continue...", 0

;Uses a different array based on what user selects
userArray dword 40 dup(?)

.code
main proc

	mov edx, offset numElementStr			
	call writeString
	call readInt
	mov ecx, eax							;Gets number of elements

	comment *
		Error handling for enter number of elements
		while(arrSize > 40)
		{
			cout << "Error: Please enter a value at most 40"
			cin >> 
		}
	*
	
	while01:
		cmp ecx, 40
		jbe endWhile01
		mov edx, OFFSET numElementErr
		call writeString
		call crlf
		mov edx, offset numElementStr			
		call writeString
		call readInt
		mov ecx, eax							;Gets number of elements
		jmp while01
	endWhile01:

	mov edx, offset numRowStr				
	call writeString
	call readInt
	mov ebx, eax							;Gets the row size

	mov edx, offset typeArrayStr
	call writeString
	call crlf
	mov edx, offset typeOneStr
	call writeString
	call crlf
	mov edx, offset typeTwoStr
	call writeString
	call crlf
	mov edx, offset typeThreeStr
	call writeString
	call crlf
	call readInt							;Gets data type for 2D array

	comment !
	C++ Equivalent for getting user input

	if(dataType == 1)
	{
		mov ebx, offset Array
		while(index < length)
		{
			cout << "Enter an element in your array, ";
			cin >> input;
			userArray[index] = input;
		}
	}
	else if (dataType == 2)
	{
		mov ebx, offset Array
		while(index < length)
		{
			cout << "Enter an element in your array, ";
			cin >> input;
			userArray[index] = input;
		}
	}
	else
	{
		mov ebx, offset Array
		while(index < length)
		{
			cout << "Enter an element in your array, ";
			cin >> input;
			userArray[index] = input;
		}
	}
	!

	push eax							;Saves values before changing inside
	push ebx							;the loop
	push ecx
	push edx
	xor edx, edx

	cmp eax, 1							;if user does not want bytes --> jump
	ja else01				
	
	mov ebx, offset userArray
	inputByteLoop:							;Gets user input. Store in array
		mov edx, offset enterElementStr		;		(type byte)
		call writeString
		call readInt
		mov [EBX], al
		add EBX, type byte
	Loop inputByteLoop
	
	jmp out01

	else01:								;if user does not want words --> jump
	cmp eax, 2
	ja else02

	mov ebx, offset userArray
	inputWordLoop:						;Gets user input. Store in array
		mov edx, offset enterElementStr	;		(type word)
		call writeString
		call readInt
		mov [EBX], ax
		add EBX, type word
	Loop inputWordLoop
									
	jmp out01

	else02:							;User must want dword data type

	mov ebx, offset userArray
	inputDwordLoop:						;Gets user input. Store in array
		mov edx, offset enterElementStr	;		(type dword)
		call writeString				
		call readInt
		mov [EBX], eax
		add EBX, type Dword
	Loop inputDwordLoop

	out01:										;Jump here getting input

	pop edx
	pop ecx										;ECX = Number of elements
	pop ebx										;EBX = Row size
	pop eax										;EAX = Data type

	sub esp, 4									;Create return value space
	mov edx, OFFSET userArray					;Push values for procedure
	push edx
	push ebx
	push eax
	
	mov edx, offset selectRowStr				;Asks for select row
	call writeString
	call readInt

	push eax									;Push row selected
 
	;int calcRowSum (int *array, int rowSize, int type, int rowIndex);
	call calcRowSum
	 
	mov edx, OFFSET sumStr
	call writeString
	pop eax										;Put sum into eax
	call writeInt
	call crlf
	mov edx, offset pressKeyStr
	call writeString


	exit
main endp

;	----------------calcRowSum Procedure----------------
;	Calculates the sum of a user specified row
;	Receives: arrayAddress, rowSize, arrayType, selectedRow
;	Returns: Sum of row
;	Operation: Calculates the sum of a specified row
;	----------------------------------------------------

calcRowSum proc   
	push ebp					;Keeps track of arguments
	mov ebp, esp				;Make ebp point to what esp points to
	push esi
	push ebx
	push ecx
	push eax
	push edx

	xor edx, edx				;EDX = Total
	mov esi, [ebp + 20]			;Address of array
	mov ecx, [ebp + 16]			;ECX = Row size
	mov ebx, [ebp + 12]			;EBX = Data type								
	mov eax, [ebp + 8]			;EAX = Selected row
	
	;rowNumber * rowSize * type + (array_address) --> get first element of
	;												  selected row
	imul ebx
	imul ecx
	add	esi, eax

	comment &
	C++ Equivalent code for while loop
		while(rowSize > 0)
		{
			if(type == 1)
				sumCounter += array[column]

			else if (type == 2)
				sumCounter += array[column]

			else
				sumCounter += array[column]

			column++;
			rowsize--;
		}
	&

	LoopSum:
		cmp bl, 1
		ja type02
			add dl, [esi]
			jmp out02
		type02:
		cmp bx, 2
		ja type04
			add dx, [esi]
			jmp out02
		type04:
			add edx, [esi]
		out02:
		add esi, ebx
	Loop LoopSum

	mov [ebp + 24], edx			;Push sum to stack

	pop edx
	pop eax
	pop ecx
	pop ebx
	pop esi
	pop ebp
	ret 16						;4 * number of paramaters
calcRowSum endp
end main


comment *
Sample output

Enter how many elements in your array: 9
Enter the row size: 3
Enter the type of your array.
1 for byte.
2 for word.
4 for doubleword.
4
Enter an element in your array, -12
Enter an element in your array, 6
Enter an element in your array, 1
Enter an element in your array, 5
Enter an element in your array, 7
Enter an element in your array, 2
Enter an element in your array, -4
Enter an element in your array, 8
Enter an element in your array, 1
Enter row number that you want me to sum: 0
The sum is: -5
Press any key to continue...

*