; Yuqian Cai
; Program 2

section .data
    str1 db 'Hello,', 0
    str2 db ' COMP228!', 0
    concatenated db 256 dup(0) ; Buffer large enough for both strings and operations

section .bss
    finalLength resd 1 ; To store the final length of the concatenated string

section .text
global _start

_start:
    ; Concatenate str1 and str2 into 'concatenated' and convert to uppercase
    call concatenate_and_uppercase

    ; Calculate the length of the concatenated string
    call calculate_length

    ; Reverse the concatenated and uppercased string
    call reverse_string

    ; Print the final string
    mov edx, [finalLength]       ; Length of the final string
    mov ecx, concatenated        ; Pointer to the final string
    mov ebx, 1                   ; STDOUT
    mov eax, 4                   ; sys_write
    int 0x80

    ; Exit the program
    mov eax, 1                   ; sys_exit
    xor ebx, ebx                 ; Status 0
    int 0x80

; Subroutines

concatenate_and_uppercase:
    ; Handles concatenation of str1 and str2 into 'concatenated' and conversion to uppercase
    mov esi, str1              ; Point ESI (source index) to the start of str1
    mov edi, concatenated      ; Point EDI (destination index) to the start of the 'concatenated' buffer
    call process_string          ; Process str1
    lea esi, [str2]              ; Point ESI to the start of str2
    ; No need to adjust EDI as it's already at the end of the first part of 'concatenated'
    call process_string          ; Process str2
    mov [edi], al                ; store the byte from AL to [EDI]
    inc edi                      ; increment EDI
    ret

process_string:
    ; Processes each string, converting to uppercase and storing in 'concatenated'
    mov al, [esi]                ; load the byte from [ESI] to AL (lower 8 bits of the EAX register)
    inc esi                      ; increment the address in esi by one byte
    test al, al                  ; Check if it's the null terminator
    jz .done                     ; If so, we're done with this string
    cmp al, 'a'                  ; compare pointed to by al at this address against ACII char 'a'
    jb .store                    ; If it's below 'a', it's not a lowercase letter
    cmp al, 'z'                  ; compare pointed to by al at this address against ACII char 'z'
    ja .store                    ; If it's above 'z', it's not a lowercase letter
    sub al, 20h                  ; Convert lowercase to uppercase
.store:
    mov [edi], al            ; store the byte from AL to [EDI]
    inc edi                  ; increment the address in edi by one byte
    jmp process_string
.done:
    ret

calculate_length:
    ; Calculates the length of the 'concatenated' string
    lea esi, [concatenated]      ; Point ESI to the start of 'concatenated'
    xor ecx, ecx                 ; Zero ECX to use as a counter
.find_end:
    mov al, [esi]                ; load the byte from [ESI] to AL
    inc esi  
    test al, al                  ; Check if it's the null terminator
    jz .store_length             ; If so, we've found the end
    inc ecx                      ; Increment our counter
    jmp .find_end
.store_length:
    mov [finalLength], ecx       ; Store the length
    ret

reverse_string:
    ; Reverses the 'concatenated' string in place
    mov esi, concatenated        ; Start of the string (source)
    mov edi, concatenated        ; Will be adjusted to point to the end of the string (destination)
    mov ecx, [finalLength]       ; Length of the string (counter)
    add edi, ecx                 ; Move EDI to the end of the string
    dec edi                      ; Adjust for zero-based index
.reverse_loop:
    cmp esi, edi                 ; Compare pointers
    jge .done_reversing          ; If they meet or pass each other, we're done (jge: Jump if Greater or Equal)
    mov al, [esi]                ; Swap the characters pointed to by ESI and EDI
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi                      ; Move ESI towards the end
    dec edi                      ; Move EDI towards the start
    jmp .reverse_loop
.done_reversing:
    ret
