section .text
global _add

_add:
    push rbp                    ; Save caller state
    mov rbp, rsp

    mov rax, [rdi+24]        ; Copy function args to registers: leftmost...
    mov rbx, [rsi+24]        ; Next argument...
    mov rcx, [rdi]           ; get counter

    loop1:
        mov rdx, [rax+24]       ; get num of the last link
        mov r8, [rbx+24]
        adc qword rdx, r8
        mov qword [rax+24], rdx

        mov rax, qword [rax+8] ;move to next link
	mov rbx, qword [rbx+8]
        loop loop1

    mov [rbp-8], rax

    pop rbp                     ; Restore caller state
    ret