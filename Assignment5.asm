;Program asks user to input two signed numbers and calculates and displays the
;sum and difference. Then clears the screen. The program does this 3 times.

include irvine32.inc

.data
input_message byte "Please enter an integer: ", 0
sum_message byte "The sum of two integers: ", 0
diff_message byte "The difference of two integers: ", 0
wait_message byte "Press any key... ", 0

;x coordinate close to center of screen
center_x_cord byte 35

;y coordinate close to center of screen
center_y_cord byte 10

.code
main proc
	
	mov ecx, 3
	LoopThrough:
		
		;Clears out any random values
		xor eax, eax
		xor ebx, ebx

		;Saves initial location for the y cordinate to the stack
		movzx eax, center_y_cord
		push eax
		
		;Saves value of ecx to stack --> value will be lost in calculations
		push ecx

		;Gets two inputs (signed values)
		mov edx, offset input_message
		call Input
		mov ebx, eax
		call Input

		;Displays the sum
		mov edx, offset sum_message
		call DisplaySum

		;Displays the difference
		mov edx, offset diff_message
		call DisplayDiff

		;Displays wait message
		mov edx, offset wait_message
		call WaitForKey

		;Pops ecx --> correct the value of ecx (for the loop)
		pop ecx		

		;Corrects for y offset after the program
		pop eax
		mov center_y_cord, al
		
		Loop Loopthrough

	exit
main endp



;	----------------Locate Procedure----------------
;	Moves cursor near middle of console window. Then moves to the next line
;	when called again
;	Uses: center_y_cord, center_x_cord, call gotoxy inc_center_y_cord

Locate proc
	;saves edx because Gotoxy uses register edx
	mov ecx, edx

	;puts values in dh and dl
	mov dl, center_x_cord
	mov dh, center_y_cord

	;moves cursor
	call Gotoxy			
	
	;returns original value of edx into edx
	mov edx, ecx
	
	;moves y cordinate down
	inc center_y_cord			
   
    ;Exits procedure
	ret
Locate endp


;	----------------Input Procedure----------------
;	Prompts user to enter a signed integer
;	Receives: edx (offset of message to prompt user input)
;	Returns: eax (integer entered by user)

Input proc

	;Calls locate procedure to move to middle of screen
	call Locate

	;Writes address of message to prompt user to the screen
	call writeString

	;Saves value of user input to EAX
    call readInt

	;Prints a new line & exits procedure
    call crlf

	ret
Input endp

;	----------------DisplaySum Procedure----------------
;	Calculates & displays sum of two signed ints
;	Receives: eax, ebx (the signed integers locations) 
;			  edx (offset of message of displaying sum)

DisplaySum proc	
	;Moves cursor to correct spot
	call Locate

	;Saves eax so it won't be lost
	mov ecx, eax
    
	;Calculates sum
	add eax, ebx

	;Displays message
	call writeString

	;Displays value
	call writeInt
	
	;moves eax's value back from temporary register
	mov eax, ecx

	;New line & exits procedure
	call crlf
    ret
DisplaySum endp

;	----------------DisplayDiff Procedure----------------
;	Calculates & displays difference of two signed ints
;	Receives: eax, ebx (the signed integers locations) 
;			  edx (offset of message of displaying difference)
;	

DisplayDiff proc
	;Moves cursor to correct spot
	call Locate

	;Saves eax so it won't be lost
	mov ecx, eax
    
	;Calculates difference
	sub eax, ebx

	;Displays message
	call writeString

	;Displays value
	call writeInt

	;Moves eax's value back from temporary register
	mov eax, ecx

	;New line & exits procedure
	call crlf
    ret
DisplayDiff endp

;	----------------WaitForKey Procedure----------------
;	Displays wait_message and waits for user type a character
;	Receives: edx (offset of message displaying press any key)
;	Returns: nothing 

WaitForKey proc
	;Moves cursor close to middle of the screen
	call Locate

	;Displays the waiting message 
	call writeString

	;Gets a single character from the user (so program can move to next loop)
	call readChar
   
    ;Clears the screen
	call ClrScr

	;Exits procedure
	ret
WaitForKey endp

end main

comment !

	Please enter an integer: 6
    Please enter an integer: 7
    The sum of two integers: +13
    The difference of two integers: +1
    Press any key...    

!