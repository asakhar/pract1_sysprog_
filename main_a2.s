// ------------------------------------------------------------------------------
// Runs on 64-bit Linux only.
// To assemble, run and output binary number:
//     
//     export var=123; as -defsym VAR=$var main_a2.s -o main_a1_a2.o -g && ld main_a1_a2.o -o main_a1_a2 -g && ./main_a1_a2
//
// Set $var to desired value
// ------------------------------------------------------------------------------

    .global    _start
    .section   .text
itos: 
    mov $10, %ecx
    mov $12, %ebx
.L0: 
    mov %edi, %eax
    mov $0, %edx
    div %ecx
    add $'0', %dl
    add $-1, %ebx
    mov %dl, number_as_string(,%ebx)
    mov %eax, %edi
    test %eax, %eax
    jne  .L0
    mov $12, %ecx
    subl %ebx, %ecx
    mov %ecx, str_len
    mov $number_as_string, %rax
    add %rbx, %rax
    ret

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
    // call getSwitches with argument from memory @label "input"
    mov       input, %edi
    call      getSwitches
    // save the result to memory
    mov       %rax, output

    // convert input number to sequence of chars
    mov       input, %edi
    call      itos
    // syscall write to stdout
    mov       $1, %rdi
    mov       %rax, %rsi
    mov       str_len, %edx
    mov       $1, %rax
    syscall

    // write the label to separate input and output
    mov       $1, %rdi
    mov       $label, %rsi
    mov       $9, %edx
    mov       $1, %rax
    syscall

    // cvt output number to sequence of chars
    mov       output, %edi
    call      itos
    // print to stdout
    mov       $1, %rdi
    mov       %rax, %rsi
    mov       str_len, %edx
    mov       $1, %rax
    syscall

    mov       $60, %rax 
    // system call for exit
    xor       %rdi, %rdi
               
    mov       $0, %rdi
                 // exit code 0
    syscall                           
    // invoke operating system to exit

    .section   .rodata
label: 
    .string        "\nResult:\n"
    .section   .data
number_as_string: 
    .string      "000000000000"
input: 
    .int        VAR
output: 
    .int        0
    .section   .bss
str_len: 
    .int
