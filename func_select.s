# 212300982 Matan Shneider

    .section .rodata
    .align 8
.L10:
    .quad .L1 # case 50: pstrlen
    .quad .L6 # case 51: default
    .quad .L2 # case 52: replaceChar
    .quad .L3 # case 53: pstrijcpy
    .quad .L4 # case 54: swapCase
    .quad .L5 # case 55: pstrijcmp
    .quad .L6 # case 56: default
    .quad .L6 # case 57: default
    .quad .L6 # case 58: default
    .quad .L6 # case 59: default
    .quad .L1 # case 60: pstrlen

pslen:  .string     "first pstring length: %d, second pstring length: %d\n"
onchar: .string     "old char: %c, new char: %c, first string: %s, second string: %s\n"
ijcopy: .string     "length: %d, string: %s\n"
swap:   .string     "length: %d, string: %s\n"
ijcmp:  .string     "compare result: %d\n"
errmsg: .string     "invalid option!\n"
charformin: .string " %c"
intformin:  .string "%d"

    .text
    .global func_select
    .type   func_select, @function
func_select:
        # create new frame and save "calle save" registers
    push    %rbp
    movq    %rsp, %rbp
    push    %r14
    push    %r15
    xor     %r14, %r14
    xor     %r15, %r15
        
        # switch table
    leaq    -50(%rdi), %rsi
    cmpq    $0, %rsi
    jb      .L6
    cmp     $10, %rsi
    ja      .L6
    jmp     *.L10(,%rsi,8)
    
.L1:    #pstrlen
    movq    %r12, %rdi
    call    pstrlen         #call pstrlen for the first pstring
    movq    %rax, %rsi
    movq    %r13, %rdi
    call    pstrlen         #call pstrlen for the second pstring
    movq    %rax, %rdx
    mov     $pslen, %rdi
    call    printf          #print the results
    jmp     stop

.L2:    #replaceChar
    subq    $16, %rsp       #allocating space for the old char (1 for char + 15 to align to 16)
    movq    $charformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf           #scan the old char
    movzbl  (%rsp), %r14
    subq    $16, %rsp       #allocating space for the new char (1 for char + 15 to align to 16)
    movq    $charformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf           #scan the old char
    movzbl  (%rsp), %r15
    movq    %r12, %rdi
    movq    %r14, %rsi
    movq    %r15, %rdx
    call    replaceChar     #call replaceChar with the first pstring
    movq    %rax, %r12
    movq    %r13, %rdi
    movq    %r14, %rsi
    movq    %r15, %rdx
    call    replaceChar     #call replaceChar with the second pstring
    movq    %rax, %r13
    movq    $onchar, %rdi
    movq    %r14, %rsi
    movq    %r15, %rdx
    leaq    1(%r12), %rcx
    leaq    1(%r13), %r8
    call    printf          #print the results
    jmp     stop

.L3:    #pstrijcpy
    subq    $16, %rsp       # allocating space for i (int)
    movq    $intformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf           #scan i
    movzbl  (%rsp), %r14
    subq    $16, %rsp       # allocating space for j (int)
    movq    $intformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf           #scan j
    movzbl  (%rsp), %r15
    movq    %r12, %rdi
    movq    %r13, %rsi
    movq    %r14, %rdx
    movq    %r15, %rcx
    call    pstrijcpy       #call pstrijcpy
    movq    %rax, %r12
    movq    %r12, %rdi
    call    pstrlen
    movq    %rax, %rsi
    movq    $ijcopy, %rdi
    leaq    1(%r12), %rdx
    call    printf
    movq    %r13, %rdi
    call    pstrlen
    movq    %rax, %rsi
    movq    $ijcopy, %rdi
    leaq    1(%r13), %rdx
    call    printf          #print the result
    jmp     stop

.L4:    #swapCase
    movq    %r12, %rdi
    call    swapCase        #call swapCase for the first pstring
    movq    %rax, %r12
    movq    %r12, %rdi
    call    pstrlen
    movq    %rax, %rsi
    movq    $swap, %rdi
    leaq    1(%r12), %rdx
    call    printf          #print the result for the first string
    movq    %r13, %rdi
    call    swapCase        #call swapCase for the second pstring
    movq    %rax, %r13
    movq    %r13, %rdi
    call    pstrlen
    movq    %rax, %rsi
    movq    $swap, %rdi
    leaq    1(%r13), %rdx
    call    printf          #print the result for the first string
    jmp     stop

.L5:    #strijcmp
    subq    $16, %rsp       # allocating space for i (int)
    movq    $intformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf           #scan i
    movzbl  (%rsp), %r14
    subq    $16, %rsp       # allocating space for j (int)
    movq    $intformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf           #scan j
    movzbl  (%rsp), %r15
    movq    %r12, %rdi
    movq    %r13, %rsi
    movq    %r14, %rdx
    movq    %r15, %rcx
    call    pstrijcmp       #call pstrijcmp
    movq    $ijcmp, %rdi
    movq    %rax, %rsi
    movq    $0, %rax
    call    printf          #print the result
    jmp     stop
    
.L6:    #default case
    movq    $errmsg, %rdi
    movq    $0, %rax
    call    printf          #print error message

stop:
    pop     %r15
    pop     %r14
    movq    %rbp, %rsp
    pop     %rbp
    ret
 