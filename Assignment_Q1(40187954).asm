;Yuqian Cai (40187954)

section .data
     number1 dd 81          ; last two digits of my phone number
     number2 dd 54          ; last two digits of my student number
     result     dd 0           ; Variable to store the (+-*/) oprations of the two numbers
     buffer  db 11 dup(0)   ; Buffer to store the ASCII char

section .text
global _start

_start:
    ; Calculate the sum of the two numbers and store it in 'result'
    mov eax, [number1]     ; Load the first number into eax
    add eax, [number2]     ; Add the second number to eax
    mov [result], eax         ; Store the result in 'result'
    call Convert_Print
  
    
    ; Calculate the substraction of the two numbers and store it in 'result'
    mov eax, [number1]     ; Load the first number into eax
    sub eax, [number2]     ; Sub the second number to eax
    mov [result], eax         ; Store the result in 'result'
    call Convert_Print
   
    
    ; Calculate the multiplication of the two numbers and store it in 'result'
    mov eax, [number1]     ; Load the first number into eax
    imul eax, [number2]     ; Sub the second number to eax
    mov [result], eax         ; Store the result in 'result'
    call Convert_Print
  
    ; Calculate the division of the two numbers and store it in 'result'
    ; Check if number2 is zero to avoid division by zero error
    mov eax, [number2]
    test eax, eax
    jz exit_program ; If number2 is zero, exit to avoid division by zero
    ; Prepare for division
    mov eax, [number1] ; Load the first number into EAX
    xor edx, edx       ; Clear EDX for unsigned division, or use CDQ if signed division is needed
    div dword [number2] ; Divides EDX:EAX by number2, quotient in EAX, remainder in EDX
    mov [result], eax  ; Store the quotient in 'result'
    call Convert_Print
   
    ; Exit the program
    mov eax, 1             ; Syscall: sys_exit
    xor ebx, ebx           ; Status: 0
    int 0x80

;SubRoutine

; Convert the sum to ASCII char and store in buffer
Convert_Print:    
    mov eax, [result]         ; Load the sum in the register
    lea edi, [buffer + 9]  ; Point edi to the second to last byte
    
    convert_loop:
    xor edx, edx           ; Clear edx for division
    mov ebx, 10            ; Set divisor to 10
    div ebx                ; Divide eax by 10. Result in eax, remainder in edx
    add dl, '0'            ; Convert remainder to ASCII
    dec edi                ; Move buffer pointer backwards (decrement)
    mov [edi], dl          ; Store ASCII char in buffer
    test eax, eax          ; Check if the quotient is 0
    jnz convert_loop       ; If not, continue loop
    
; Print the number
    print:
    mov eax, 4             ; Syscall: sys_write
    mov ebx, 1             ; File descriptor: stdout
    mov ecx, edi           ; Pointer to the 1st char in the buffer
    mov edx, 10            ; Number of chars to print
    sub edx, edi           ; Adjust count based on where we stored the
    add edx, buffer        ; Correct the count
    int 0x80               ; Make syscall
    ret

    
exit_program:
    ; Exit the program
    mov eax, 1         ; Syscall: sys_exit
    xor ebx, ebx       ; Status: 0
    int 0x80    
