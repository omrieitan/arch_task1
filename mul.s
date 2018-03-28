%define num1_ptr r13
%define num2_ptr rbx
%define mul_carry r9
%define links_count1 r12
%define links_count2 r11
%define result_ptr r8
%define digit1 rax
%define digit2 r10
%define result_curr r14
%define add_carry r15

section .text
global _multiply
extern printf

_multiply:
    push rbp                                    ; Save caller state
    mov rbp, rsp
    
    mov qword num1_ptr, [rdi+24]      	        ; get num1
    mov num2_ptr, [rsi+24]        		; get num2
    mov result_ptr, [rdx+24]         		; get result
    mov result_curr, [rdx+24]
    mov links_count1, [rdi]           		; number of links of num1
    mov links_count2, [rsi]           		; number of links of num2
    mov add_carry, 0
    mov mul_carry, 0
    

    num2_loop:
        mov digit2, [num2_ptr+16]		;get the number from the link of the secound number
    
        num1_loop:
            mov digit1, [num1_ptr+16]		;get the number from the link of the first number
            mul digit2
            add digit1,mul_carry
            mov mul_carry, 0
            cmp digit1,10
            jge mul_carry_handle                ; carry -> handle the addition of the carry
            jmp insert_new_digit                ; no carry -> add addtion carry and mul resualt, and add to resulat
        
        get_next_num1_digit:
            mov num1_ptr, qword [num1_ptr+8]	; get next link of first number
	    mov result_ptr, qword [result_ptr+8]; get next link of result number
	    jmp end_of_num1_check
	    
        end_of_num1_check:                      ; reached the end of iteration over num1
            cmp num1_ptr,0                      
            je handle_end_of_num1               ; call fucntion to handle the case were we need to add a add/mull carry
            jmp num1_loop_end
            
    
        num1_loop_end:                          ; decreasing counters
            dec links_count1                    
            cmp links_count1,0
            jnz num1_loop
    
    
    num2_loop_end:                              ; prepere next digit of num2
        mov num2_ptr, qword[num2_ptr+8]
        cmp num2_ptr, 0 
        je handle_end_of_num2                   ; check if we have reached the end of num2
        jmp prepere_for_next_iteration`         ; if not, prepere for next iteration
        
    prepere_for_next_iteration:
        mov qword num1_ptr, [rdi+24]            ; reset num1 to first digit
        mov result_curr, [result_curr+8]        ; start add from the next digit
        mov result_ptr, result_curr             ; get new starting digit for addtion
        mov mul_carry, 0                        ; mul carry = 0
        mov add_carry, 0                        ; add carry = 0
        mov links_count1, [rdi]                 ; reset links_count1

        dec links_count2                        ; decreasing counters
        cmp links_count2,0
        jnz num2_loop
        jmp end
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        
    insert_new_digit:
        add qword [result_ptr+16], digit1
        add qword [result_ptr+16], add_carry
        mov add_carry, 0
        cmp qword [result_ptr+16], 10
        jge add_carry_handle 
        jmp get_next_num1_digit
        
        
    handle_end_of_num1:
        add qword [result_ptr+16], mul_carry
        cmp qword [result_ptr+16], 10
        jge add_one_at_the_end
        jmp num1_loop_end
        
    
    mul_carry_handle:
        mov rcx, 10
        idiv rcx
        add [result_ptr+16], rdx
        mov mul_carry, digit1
        cmp qword [result_ptr+16], 10
        jge add_carry_handle
        jmp get_next_num1_digit
    
    add_carry_handle:
        sub qword [result_ptr+16], 10
        mov add_carry, 1
        jmp get_next_num1_digit
        
    add_one_at_the_end:
        mov result_ptr, qword [result_ptr+8]
        add qword [result_ptr+16], 1
        mov result_ptr, qword[result_ptr]
        jmp num1_loop_end
        
    add_one_at_the_end_and_exit:
        mov result_ptr, qword [result_ptr+8]
        add qword [result_ptr+16], 1
        jmp end
        
    handle_end_of_num2:
        add qword [result_ptr+16], mul_carry
        cmp qword [result_ptr+16], 10
        jge add_one_at_the_end_and_exit
        jmp end
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                
    
    end:
    mov [rbp-8], digit1

    pop rbp                                     ; Restore caller state
    ret