    .section .rodata
errmsg: .string     "invalid input!\n"
    .text
    .global pstrlen
    .global replaceChar
    .global pstrijcpy
    .global swapCase
    .global pstrijcmp

    .type   pstrlen, @function
pstrlen:
        #the function put in %rax the length of the given pstring
    xor     %rax, %rax
    mov     (%rdi), %al
    ret
    
    .type   replaceChar, @function
replaceChar:
        #the function replace every appearance of the old char (rsi) with the new one (rdx)
    push    %rbx
    movq    $0, %rcx
    movq    %rdi, %rax
    mov     (%rdi),%cl      #put the length of the string in the loop variable (rcx)
    add     $1, %rdi
repLoop:
    xor     %rbx, %rbx
    mov     (%rdi), %bl
    cmp     %rsi, %rbx      #check if the current char (rdi) is the old char
    jne     nextchr
    mov     %rdx, %rbx      #replace the old char with the new one
    mov     %bl, (%rdi)
nextchr:
    add     $1, %rdi        #move forword to the next char
    loop    repLoop
    pop     %rbx
    ret 
    
    .type   pstrijcpy, @function
pstrijcpy:
        #the function copy the substring in range i-j of the second string to the same position in the first string
    push    %rbx
    movq    %rdi, %rax
        #check if the range is in bounds
    cmp     %rdx, %rcx
    jl      ofbcpy
    cmp     (%rdi), %cl
    jge     ofbcpy
    cmp     (%rsi), %cl
    jge     ofbcpy
    cmp     $0, %rdx
    jl      ofbcpy
    add     $1, %rdi
    add     $1, %rsi
        #move to the start of the substring
    add     %rdx, %rdi
    add     %rdx, %rsi
    sub     %rdx, %rcx      #set the loop variable
    add     $1, %rcx
cpyLoop:
    xor     %rbx, %rbx
    mov     (%rsi), %bl
    mov     %bl, (%rdi)     #replace between the characters
    add     $1, %rdi
    add     $1, %rsi
    loop    cpyLoop
    jmp     endcpy
ofbcpy:
    push    %rax
    movq    $errmsg, %rdi
    movq    $0, %rax
    call    printf          #print error message
    pop     %rax
endcpy:
    pop     %rbx
    ret
    
    .type   swapCase, @function
swapCase:
        #the function replace every lowercase char in the string with her uppercase and vice versa
    movq    %rdi, %rax
    xor     %rcx, %rcx
    mov     (%rdi), %cl     #set the loop variable
    add     $1, %rdi
swapLoop:
    xor     %rdx, %rdx
    mov     (%rdi), %dl
    cmp     $90, %dl        #copmare the cuurent char with Z
    jle     AB
    cmp     $122, %dl       #compare the current char with z
    jle     ab
    jmp     notAa
AB:     #uppercase
    cmp     $65, %dl
    jl      notAa
    add     $32, (%rdi)     #add 32 to make it lowercase
    jmp     notAa
ab:     #lowercase
    cmp     $97, %dl
    jl      notAa
    sub     $32, (%rdi)     #sub 32 to make it uppercase
notAa:
    add     $1, %rdi        #move to the next char
    loop    swapLoop
    ret

    .type   pstrijcmp, @function
pstrijcmp:
        #the function compare between the substring in range i-j of the second string
        #to the same substring in the first string
    push    %rbx
    xor     %rax ,%rax
        #check if the range is in bounds
    cmp     %rdx, %rcx
    jl      ofbcmp
    cmp     (%rdi), %cl
    jge     ofbcmp
    cmp     (%rsi), %cl
    jge     ofbcmp
    cmp     $0, %rdx
    jl      ofbcmp
    add     $1, %rdi
    add     $1, %rsi
        #move to the start of the substring
    add     %rdx, %rdi
    add     %rdx, %rsi
    sub     %rdx, %rcx
    add     $1, %rcx
cmpLoop:
    xor     %rbx, %rbx
    mov     (%rsi), %bl
    cmp     %bl, (%rdi)     #compare the current chars in the substring
    jg      before
    jl      after
    jmp     equal
before:     #first substring appears before the second substring
    movq    $1, %rax
    jmp     endcmp
after:      #first substring appears after the second substring
    movq    $-1, %rax
    jmp     endcmp
equal:      #the current chars are equal
    add     $1, %rdi
    add     $1, %rsi
    loop    cmpLoop
        #first substring equal to the second substring
    mov     $0, %rax        
    jmp     endcmp
ofbcmp:
    movq    $errmsg, %rdi
    movq    $0, %rax
    call    printf          #print error message
    movq    $-2, %rax
endcmp:
    pop     %rbx
    ret
