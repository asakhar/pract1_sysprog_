; ------------------------------------------------------------------------------
; Runs on 64-bit Linux only.
; To assemble, run and output binary number:
;     
;     export var=0b01010010001; nasm -felf64 main.asm -g -DVAR=$var && ld main.o -o main -g && ./main; echo $status; echo "print(f\"{int(bin($var)[2:]):032}\")" | python3
;
; Set $var to desired value
; ------------------------------------------------------------------------------

    global    _start
    section   .text
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
    mov       edi, [input]
    call      getSwitches
    mov       [output], rax

    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                
    mov       rdi, [output]           ; exi.wordt code with result to be displayed easily
    syscall                           ; invoke operating system to exit

    section   .data
input: dd    VAR
output: dd   0