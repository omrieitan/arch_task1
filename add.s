section .text
global _add

_add:
    push rbp                    ; Save caller state
    mov rbp, rsp

    mov rax, [rdi+16]        ; Copy function args to registers: leftmost...
    ;mov rbx, rsi        ; Next argument...
    
    
    ;add rax,rbx         ; sum 2 arguments
    mov dword [rbp-8], rax
    
    pop rbp                     ; Restore caller state
    ret
