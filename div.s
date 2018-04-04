section .text
global _add
extern add_carry
extern compare_for_div

_divide:
    push rbp                    	 ; Save caller state
    mov rbp, rsp
    
    mov r10, [rdi+24]       		 ; num1
    mov rbx, [rsi+24]       		 ; num2
    mov r11, [rdx+24]                    ; ans
    mov r15, [rcx+24]                    ; num2 copy
    mov r9, 0
    xor rax, rax
    
    main_loop_div:
    
    call compare_for_div
    cmp rax, 0
    jl end_div
    jmp inc_count
    
    loop1:
        mov r12, [rbx+16]       	; get num of the last link
        mov r8, [r15+16]
        add r8, r9
        add qword r12, r8
        cmp qword r12, 10
        jge have_carry
        jmp no_carry
        
        have_carry:
            sub r12, 10
            mov r9, 1
            jmp next
        no_carry:
            mov r9, 0
        
        next:
        mov qword [r15+16], r12
        mov r15, qword [r15+8] 		;move to next link
        mov rbx, qword [rbx+8] 		;move to next link
        loop loop1
        
        cmp r9, 1
        je last_carry
        jmp end_add
        last_carry:
        call add_carry
        
    end_add:
    jmp main_loop_div
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    inc_count:
        mov r14, [r11+16]
        add r14, 1
        cmp qword r14, 10
        jge count_carry
        jmp end_inc
        
        count_carry:
        sub r14, 10
        mov r9, 1
        mov r11, qword [r11+8]
        jmp inc_count
        
        end_inc:
        xor r9,r9
        mov r11, [rdx+24]
        jmp loop1
        
    
    end_div:
    
    mov [rbp-8], rax
    pop rbp                     	; Restore caller state
    ret
    