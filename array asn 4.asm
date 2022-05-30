;10/28/21
;This program creates an array of 10 elements with numbers inputted by the
;user. The array will be printed and then used to calculate the sum and
;average of the array. The elements in the array will also rotate with its
;values outputted on to the terminal. 

include irvine32.inc
.data
 messageP byte "Please enter a number: ", 0
 messageSum byte "Array sum: ", 0
 messageAve byte "Array average: ", 0
 messageRem byte "/", 0
 messageArr byte "Original array: ", 0
 messageRot byte "Rotated array: ", 0
 arr byte 10 dup(?)        ;Initialize array to have 10 elements


.code
main proc
   mov ecx, lengthof arr  ;Initialize counter register with 10 for 10 loops
   mov edi, offset arr    ;Let edi hold arr's offset
   sub eax, eax           ;Zero out eax register

arrFill:
   mov edx, offset messageP ;Move msg prompt to edx
   call writeString         ;Display prompt message
   call readDec             ;Read from input
   mov [edi], al            ;Place inputted number into array element
   add edi, type arr        ;Change array address by data type offset(2 bytes)
   loop arrFill             ;Loop arrFill section for 10 times.

   mov edi, 0
   mov edi, offset arr      ;Reset edi with array offset
   sub eax, eax             ;Empty eax register

   mov ecx, lengthof arr    ;Reset loop counter
calcSum:
   add al, [edi]            ;Add elements to eax register
   add edi, type arr        ;Change offset by 2 bytes
   loop calcSum             ;Loop for all elements

   mov edx, offset messageSum  ;Move sum message to edx
   call writeString            ;Write sum message to terminal
   call writeDec               ;Write sum in eax
   call Crlf

   mov edx, offset messageAve   ;Move average message to edx
   call writeString             ;Write aveMsg to terminal
   mov bl, lengthof arr        ;Move array length to ebx
   div bl                      ;Divide sum by length of array(10)
   mov bl, ah                    ;Moving remainder to bl
   sub ah, ah                    ;Zero out ah
   call writeDec                ;Write quotient to terminal
   mov al, ' '                  ;Put space
   call writeChar               ;Write space
   mov al, bl                   ;Move remainder to eax
   call writeDec                ;Write remainder to terminal
   mov edx, offset messageRem   
   call writeString              ;Display remainder sign
   mov al, lengthof arr         
   call writeDec                 ;Display array size
   call Crlf

   mov edx, offset messageArr   ;Move array message to edx
   call writeString             ;Print arrMsg

   sub eax, eax

   mov edi, offset arr
   mov ecx, lengthof arr
arrPrint:
   mov al, [edi]
   call writeDec 
   mov al, ' '
   call writeChar
   add edi, type arr
   loop arrPrint




main endp
end main


;Please enter a number: 2
;Please enter a number: 3
;Please enter a number: 4
;Please enter a number: 5
;Please enter a number: 6
;Please enter a number: 7
;Please enter a number: 8
;Please enter a number: 9
;Please enter a number: 0
;Please enter a number: 10
;Array sum: 54
;Array average: 5 4/10
;Original array: 2 3 4 5 6 7 8 9 0 10
;Press any key to close this window . . .
