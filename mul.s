section .text
global _multiply
extern printf

_multiply:
    push rbp                    ; Save caller state
    mov rbp, rsp

    mov rax, [rdi+24]        ; get num1
    mov rbx, [rsi+24]        ; get num2
    mov r8, [rdx+24]         ; get result
    mov rcx, [rdi]           ; number of links of num1
    mov r9, 0                ; mul carry
    mov r10, 0               ; add carry
    mov r11, [rsi]           ; number of links of num2
    
    
    main_loop:
        mov ax, [rax+16]
        mov cx, [rbx+16]
        mul cx
        mov [r8+16], ax
        ;cmp qword rdx, 10
        ;jge mul_carry
        
        mul_carry:
           ; mov ax, 10
           ; div cx
           ; mov [r8+16], cx
        
    mov [rbp-8], rax

    pop rbp                     ; Restore caller state
    ret