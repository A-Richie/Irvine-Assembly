;What program Does: The program takes a user input and calculates then 
;                   displays all the prime numbers between the input value
;                   and 1 (not including 1 and the user input)
;Date: 11/14/2021

include irvine32.inc
.data
promptUser byte "Please enter a number: ", 0
primeNumStr byte "Primes found until the given number: ", 0
pressKeyStr byte "Press any key to continue...", 0
spaceStr byte " ", 0
userInput dword ?       ;Saves user input
outerLoop dword 2      ;Used for incrementing main procedure's while loop

.code
main proc
                                    
	mov edx, offset promptUser   ;Prompt user to input a number
	call writeString

    call readDec                 ;Reads user input. Stores input in EAX AND
    mov userInput, eax           ;userInput variable
           
    call crlf       
    mov edx, offset primeNumStr  ;Prints string saying how many prime numbers
    call writeString             ; are found
    call crlf
    call crlf

	comment ^
    While loop C++ equivalent for following assembly while loop
        while(outerLoop < input)
        {
            int primeFlag = 0;

            isPrime(input)

            if (flag == 0)
            {
                cout << outerLoop << " "; 
            }
            outerLoop++;
        }
    ^

    while01:                     ;While loop goes from 1 to userInput
        mov eax, userInput 

        cmp outerLoop, eax       ;Checks (outerLoop < input)
        jae endWhile01           ;Exit while loop if outerLoop > input value
       
        xor ecx, ecx             ;Resets primeFlag at the start of each loop
        inc ecx                  ;1 is prime. If not prime it's reset to 0

        mov eax, outerLoop       ;Move value of the outter loop to eax
        call isPrime             ;isPrime checks if outerLoop val is prime

        xor edx, edx            

        mov eax, outerLoop

        cmp ecx, 1               ;Check is flag == 1 ?
        jne else01

        mov eax, outerLoop       ;If flag = 1
        call writeDec            ;Prints the prime number (outerLoop value)

        mov edx, offset spaceStr ;Prints a space between prime numbers
        call writeString 

        else01:
        inc outerLoop            ;Increment outter loop -> no infinite loop 
        
        jmp while01              ;Go to start of while loop
    endWhile01:

    mov edx, offset pressKeyStr ;Print statment to press a key after the
    call writeString            ;program checks for all prime values

	exit
main endp


;	----------------isPrime Procedure----------------
;	Checks if number is prime
;	Receives: Recives number (outerLoop value) (through register EAX)
;	Returns: Returns 1 (is prime) 0 (not prime) through ECX

isPrime proc   
    mov ebx, 2          ;Put ebx in stack (while loop pops ebx at start)
    push ebx            ;of each iteration

    comment *
     While loop C++ equivalent for while loop and if statment
        while(innerLoop <= (outerLoop/2))
        {
            if(outerLoop % innerLoop == 0)
            {
                flag = 1;
                break;
            }
            innerLoop++;
        }
    *

    while02:            ;While loop checks if the while loop from the main
                        ;procedure is a prime number
    xor edx, edx        ;Clears any miscellaneous values
    push eax            ;Save eax in stack -> div changes eax

    mov ecx, 2          ;Checks (innerLoop <= (outerLoop/2))
    div ecx             ;Q: EAX R: EDX (reminder isn't needed here)
    pop edx             ;Save value in edx temperarily so ebx gets correct val
    pop ebx             ; EBX => inner loop value
    xor ecx, ecx        ;Reset ECX to 1  
    inc ecx
    cmp ebx, eax
    ja endWhile02       ;End loop if innerLoop > (outerLoop/2)
                        
    xor eax, eax        ;Resets all registers except ebx and eax                
    mov eax, edx        ;EAX = outerLoop value
    xor edx, edx        ;EBX = InnerLoop (procedure's while value)

    push eax            ;Save eax in stack (while loop pops at start)
                    
    div ebx             
    pop eax             ;If statment check if loop values are divisible
    cmp edx, 0          ;If(outerLoop % innerLoop == 0)
    jne else02          ;If not prime leave the procedure
            
    xor ecx, ecx        ;Reset Ecx value --> 0 for not prime
    jmp endWhile02

    else02:
    inc ebx             ;Increment & loop back to start of inner loop
    push ebx            ;Put value to stack -> while loop pop at start
    jmp while02
    endWhile02:                        
    ret                 ;Exits procedure
isPrime endp

end main


comment !

	Sample run:

    Please enter a number: 50

    Primes found until the given number:

    2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 Press any key to continue...

!