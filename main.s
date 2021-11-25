// ------------------------------------------------------------------------------
// Runs on 64-bit Linux only.
// To assemble, run:
//     
//     export var=123; as -defsym VAR=$var main.s -o main_a2.o && ld main_a2.o -o main_a2 && ./main_a2; echo $status
//
// Set $var to desired value
// ------------------------------------------------------------------------------

    .global    _start
    .section   .text
getSwitches: 
    mov     %edi, %eax
    and     $1, %eax
    shr     $1, %edi
    je      .L7
    xor     %edx, %edx
    xor     %esi, %esi
.L5:
    mov     %edi, %ecx
    add     $1, %edx
    shr     $1, %edi
    and     $1, %ecx
    xor     %ecx, %eax
    add     %eax, %esi
    mov     %ecx, %eax
    cmp     $30, %edx
    jg      .L8
    test    %edi, %edi
    jne     .L5
.L8:
    cmp     $31, %edx
    setne   %dl
    and     %edx, %eax
    add     %esi, %eax
    ret
.L7:
    mov     $1, %edx
    xor     %esi, %esi
    and     %edx, %eax
    add     %esi, %eax
    ret

_start: 
    mov       input, %edi
    call      getSwitches
    mov       %rax, output

    mov       $60, %rax                 # system call for exit
    xor       %rdi, %rdi                
    mov       output, %rdi           # exit code with result to be displayed easily
    syscall                           # invoke operating system to exit

    .section   .data
input: .int    VAR
output: .int   0
