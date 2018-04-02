%define num1_ptr [rdi]
%define num2_ptr [rsi]
%define mul_ptr [rdx]
%define power_ptr [rcx]
%define ans_ptr [r8]
%define curr_power r9


section .text
global _divide
extern _multiply
extern _subtract
extern _add

_divide:
    push rbp                                    ; Save caller state
    mov rbp, rsp
    
    mov curr_power, [rcx]
    
    main_loop:
        
        
        
        mov rdi, qword mun2_ptr
        mov rsi, qword power_ptr
        mov rdx, qword mul_ptr
        call _multiply
        jmp compare
        
        num1_is_bigger:
            mov [curr_power+16], 0
            mov curr_power, [curr_power]
            mov [curr_power+16], 1
            jmp main_loop
        
        mul_is_bigger:
            mov [curr_power+16], 0
            mov curr_power, [curr_power+8]
            mov [curr_power+16], 1
            
            jmp init_mul
            mul_ready:
            mov rdi, qword mun2_ptr
            mov rsi, qword power_ptr
            mov rdx, qword mul_ptr
            call _multiply
            
            mov rdi, qword mun1_ptr
            mov rsi, qword mul_ptr
            call _subtract
            
            mov rdi, qword ans_ptr
            mov rsi, qword mul_ptr
            call _add
            
            jmp init_mul2
            mul_ready2:
            mov [curr_power+16], 0
            mov curr_power, [rcx]
            mov qword [curr_power+16], 1 
            jmp main_loop
            
            
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


compare:
    mov r10, qword [rdi]  ; num of links in num1
    mov r11, qword [rdx+8] ; head of mul_ptr
    comp_loop1:
        mov r12, qword [r11+16]
        cmp r12, 0
        jne mul_is_bigger
        mov r11, qword [r11]
        dec r10
        cmp r10, 0
        jnz comp_loop1
    
    mov r10, qword [rdi]  ; num of links in num1
    mov r11, qword [rdx+8] ; head of mul_ptr
    mov r12, qword [rdi+8] ;  head of num1
    comp_loop2:
        cmp qword [r11+16], qword [r12+16]
        jg mul_is_bigger
        jl num1_is_bigger
        
        mov r11, qword [r11]
        mov r12, qword [r12]
        dec r10
        cmp r10, 0
        jnz comp_loop2
    jmp num1_is_bigger
        

init_mul:
    mov r10, qword [mul_ptr]  ; num of links in mul_ptr
    mov r11, qword [mul_ptr+8] ; head of mul_ptr
    
    mul_loop:
        mov qword [r11+16], 0
        mov r11, [r11+8]
        dec r10
        cmp r10, 0
        jnz mul_loop
    jmp mul_ready
    
    
init_mul2:
    mov r10, qword [mul_ptr]  ; num of links in mul_ptr
    mov r11, qword [mul_ptr+8] ; head of mul_ptr
    
    mul_loop:
        mov qword [r11+16], 0
        mov r11, [r11+8]
        dec r10
        cmp r10, 0
        jnz mul_loop
    jmp mul_ready2
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                
    
    end:

    pop rbp                                     ; Restore caller state
    ret