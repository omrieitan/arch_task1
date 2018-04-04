section .text
global _divide
extern add_carry
extern compare_for_div

_divide:
    push rbp                    	 ; Save caller state
    mov rbp, rsp
    
    mov r10, [rdi+16]       		 ; num1 head
    mov rbx, [rsi+24]       		 ; num2 last
    mov r11, [rdx+24]                    ; ans last
    mov r15, [rcx+24]                    ; num2 copy last
    mov r9, 0
    xor rax, rax
    
    main_loop_div:
    mov rbx, [rsi+24]
    mov r15, [rcx+24]
    jmp compare_div
    
    loop1:
        mov r12, [rbx+16]       	; get num of the last link
        mov r8, [rbx+16]
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
        mov qword [rbx+16], r12
        mov rbx, qword [rbx+8] 		;move to next link
        mov rbx, qword [rbx+8] 		;move to next link
        cmp rbx, 0
        je end_add
        
        cmp r9, 1
        je last_carry
        jmp end_add
        last_carry:
        call add_carry
        
    end_add:
    jmp main_loop_div
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    inc_count:
        inc qword [r11+16]
        cmp qword [r11+16], 10
        jge count_carry
        jmp end_inc
        
        count_carry:
        sub qword [r11+16], 10
        mov r11, qword [r11+8]
        jmp inc_count
        
        end_inc:
        mov r11, [rdx+24]
        jmp loop1
        
    compare_div:
        mov rbx, [rsi+16]  ; num2 head
        
        mov r12, [r10+16]
        mov r13, [rbx+16]
        cmp r12, r13
        jl end_div
        jg num1_is_bigger
        
        mov r10, [r10]
        mov rbx, [rbx]
        cmp rbx, 0
        je  inc_count
        jmp compare_div
        
        num1_is_bigger:
            mov rbx, [rsi+24]
            jmp inc_count
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;end;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    end_div:
    
    mov [rbp-8], rax
    pop rbp                     	; Restore caller state
    ret
    