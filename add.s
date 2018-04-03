section .text
global _add
extern add_carry

_add:
    push rbp                    	 ; Save caller state
    mov rbp, rsp
    
    push rdx
    push rcx
    push rbx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14

    mov rax, [rdi+24]       		 ; Copy function args to registers: leftmost...
    mov rbx, [rsi+24]       		 ; Next argument...
    mov rcx, [rdi]          		 ; get counter
    mov r9, 0
    
    loop1:
        mov rdx, [rax+16]       	; get num of the last link
        mov r8, [rbx+16]
        add r8, r9
        add qword rdx, r8
        cmp qword rdx, 10
        jge have_carry
        jmp no_carry
        
        have_carry:
            sub rdx, 10
            mov r9, 1
            jmp next
        no_carry:
            mov r9, 0
        
        next:
        mov qword [rax+16], rdx
        mov rax, qword [rax+8] 		;move to next link
	mov rbx, qword [rbx+8]
        loop loop1
        
        cmp r9, 1
        je last_carry
        jmp end_add
        last_carry:
        call add_carry
        
    end_add:
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbx
    pop rcx
    pop rdx
    
    mov [rbp-8], rax

    pop rbp                     	; Restore caller state
    ret