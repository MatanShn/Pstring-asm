# 212300982 Matan Shneider

    .section .rodata
intformin:  .string     "%d"
strformin:  .string     "%s"

    .text
    .global run_main
    .type   run_main, @function
run_main:
        # create new frame and save "calle save" registers
    push    %rbp
    movq    %rsp, %rbp
    push    %r12
    push    %r13
    
        # scan the first string
    subq    $272, %rsp              # allocating space for the pstring (1 for length + 255 for string + 15 to align to 16)
    movq    $intformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf                   # scan length
    movq    $strformin, %rdi
    leaq    1(%rsp), %rsi
    movq    $0, %rax
    call    scanf                   # scan string
    movq    %rsp, %r12
    
        # scan the second string
    subq    $272, %rsp              # allocating space for the pstring (1 for length + 255 for string + 15 to align to 16)
    movq    $intformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf                   # scan length
    movq    $strformin, %rdi
    leaq    1(%rsp), %rsi
    movq    $0, %rax
    call    scanf                   # scan string
    movq    %rsp, %r13
    
    subq    $16, %rsp               # allocating space for the option (int)
    movq    $intformin, %rdi
    leaq    (%rsp), %rsi
    movq    $0, %rax
    call    scanf                   # scan option
        # call func_select and pass the option
    movq    (%rsp), %rdi
    call    func_select
    
    pop     %r13
    pop     %r12
    movq    %rbp, %rsp
    pop     %rbp
    
    ret
