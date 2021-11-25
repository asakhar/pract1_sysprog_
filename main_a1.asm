; ------------------------------------------------------------------------------
; Runs on 64-bit Linux only.
; To assemble, run:
;     
;     export var="0b010101010101010"; nasm -felf64 main_a1.asm -g -DVAR=$var && ld main_a1.o -o main_a1 && ./main_a1
;
; Set $var to desired value
; ------------------------------------------------------------------------------

    global    _start
    section   .text
itos: 
    mov ecx, 10
    mov ebx, 12
.L0: 
    mov eax, edi
    mov edx, 0
    div ecx
    add dl, '0'
    add ebx, -1
    mov [number_as_string + ebx], dl
    mov edi, eax
    test eax, eax
    jne  .L0
    mov ecx, 12
    sub ecx, ebx
    mov [str_len], ecx
    mov rax, number_as_string
    add rax, rbx
    ret

getSwitches: 
    mov     eax, edi
    and     eax, 1
    shr     edi, 1
    je      .L7
    xor     edx, edx
    xor     esi, esi
.L5:
    mov     ecx, edi
    add     edx, 1
    shr     edi, 1
    and     ecx, 1
    xor     eax, ecx
    add     esi, eax
    mov     eax, ecx
    cmp     edx, 30
    jg      .L8
    test    edi, edi
    jne     .L5
.L8:
    cmp     edx, 31
    setne   dl
    and     eax, edx
    add     eax, esi
    ret
.L7:
    mov     edx, 1
    xor     esi, esi
    and     eax, edx
    add     eax, esi
    ret

_start: 
    ; call getSwitches with argument from memory @label "input"
    mov       edi, [input]
    call      getSwitches
    ; save the result to memory
    mov       [output], rax

    ; convert input number to sequence of chars
    mov       edi, [input]
    call      itos
    ; syscall write to stdout
    mov       rdi, 1
    mov       rsi, rax
    mov       edx, [str_len]
    mov       rax, 1
    syscall

    ; write the label to separate input and output
    mov       rdi, 1
    mov       rsi, label
    mov       edx, 9
    mov       rax, 1
    syscall

    ; cvt output number to sequence of chars
    mov       edi, [output]
    call      itos
    ; print to stdout
    mov       rdi, 1
    mov       rsi, rax
    mov       edx, [str_len]
    mov       rax, 1
    syscall

    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                
    mov       rdi, 0                  ; exit code 0
    syscall                           ; invoke operating system to exit

    section   .rodata
label: 
    db        10, "Result:", 10
    section   .data
input: 
    dd        VAR
output: 
    dd        0
    section   .bss
number_as_string: 
    resb      12
str_len: 
    resd      1
