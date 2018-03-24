section .text
global _subtract
extern sub_borrow

_subtract:
    push rbp                    ; Save caller state
    mov rbp, rsp

    mov rax, [rdi+24]        ; Copy function args to registers: leftmost...
    mov rbx, [rsi+24]        ; Next argument...
    mov rcx, [rdi]           ; get counter
    mov r9, 0
    
    loop1:
        mov rdx, [rax+16]       ; get num of the last link
        mov r8, [rbx+16]
        sub rdx, r9
        sub qword rdx, r8
        cmp qword rdx, 0
        jl have_borrow
        jmp no_borrow
        
        have_borrow:
            add rdx, 10
            mov r9, 1
            jmp next
        no_borrow:
            mov r9, 0
        
        next:
        mov qword [rax+16], rdx
        mov rax, qword [rax+8] ;move to next link
	mov rbx, qword [rbx+8]
        loop loop1
        
        cmp r9, 1
        je last_borrow
        jmp end_sub
        last_borrow:
        call sub_borrow
        
    end_sub:
    mov [rbp-8], rax

    pop rbp                     ; Restore caller state
    ret