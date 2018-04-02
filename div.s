%define num1_ptr rdi
%define num2_ptr rsi
%define mul_ptr rdx
%define power_ptr rcx
%define ans_ptr r8
%define curr_power r9


section .text
global _divide
extern _multiply
extern _subtract
extern _add

_divide:
    push rbp                                    ; Save caller state
    mov rbp, rsp
    
    mov curr_power, qword [power_ptr+24]
    
    main_loop:
        jmp comp_nums
        
        continue_loop:
        push num1_ptr
        push num2_ptr
        
        mov rdi, num2_ptr                 
        mov rsi, power_ptr
        mov rdx, mul_ptr
        call _multiply
        pop num2_ptr
        pop num1_ptr
        jmp compare
        
        num1_is_bigger:
            mov qword [curr_power+16], 0              ;shift left the power curr_power=curr_power*10
            mov curr_power, qword [curr_power+8]
            mov qword [curr_power+16], 1
            jmp main_loop
        
        mul_is_bigger:
            mov qword [curr_power+16], 0
            mov curr_power, qword [curr_power]
            mov qword [curr_power+16], 1
            
            jmp init_mul
            mul_ready:
            push num1_ptr
            push num2_ptr
            mov rdi, num2_ptr  ;move paramters into calling positions for function
            mov rsi, power_ptr
            mov rdx, mul_ptr
            call _multiply  ; mul_ptr = num2_ptr * power_ptr
            pop num2_ptr
            pop num1_ptr
            
            push num1_ptr
            push num2_ptr
            mov rdi, num1_ptr               ;move paramters into calling positions for function
            mov rsi, mul_ptr
            call _subtract                  ; num1_ptr = num1_ptr - mul_ptr
            pop num2_ptr
            pop num1_ptr
            
            push num1_ptr
            push num2_ptr
            mov rdi, ans_ptr                ;move paramters into calling positions for function
            mov rsi, mul_ptr
            call _add                       ; ans_ptr = ans_ptr + mul_ptr
            pop num2_ptr
            pop num1_ptr
            
            
            jmp init_mul2
            mul_ready2:
            mov qword [curr_power+16], 0
            mov curr_power, power_ptr
            mov qword [curr_power+16], 1 
            jmp main_loop
            
            
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


comp_nums:
    mov r10, qword [num1_ptr]  ; num of links in num1
    mov r11, qword [num1_ptr+8] ; head of num1
    mov r12, qword [num2_ptr+8] ;  head of num2
    nums_loop:
        mov r13, qword [num1_ptr+16]
        mov r14, qword [num2_ptr+16]
        cmp r13, r14
        jg continue_loop
        jl end
        
        mov r11, qword [r11]
        mov r12, qword [r12]
        dec r10
        cmp r10, 0
        jnz nums_loop
    jmp continue_loop

compare:
    mov r10, qword [rdi] ; num of links in num1
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
        mov r13, qword [r11+16]
        mov r14, qword [r12+16]
        cmp r13, r14
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
    
    mul_loop2:
        mov qword [r11+16], 0
        mov r11, [r11+8]
        dec r10
        cmp r10, 0
        jnz mul_loop2
    jmp mul_ready2
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                
    
    end:

    pop rbp                                     ; Restore caller state
    ret