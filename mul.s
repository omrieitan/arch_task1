%define num1_ptr r13
%define num2_ptr rbx
%define carry r9
%define links_count1 r12
%define links_count2 r11
%define result_ptr r8
%define digit1 rax
%define digit2 r10
%define result_curr r14

section .text
global _multiply

_multiply:
    push rbp                                    ; Save caller state
    mov rbp, rsp
    
    push rdx
    push rbx
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14

    
    mov qword num1_ptr, [rdi+24]      	        ; get num1
    mov num2_ptr, [rsi+24]        		; get num2
    mov result_ptr, [rdx+24]         		; get result
    mov result_curr, [rdx+24]
    mov links_count1, [rdi]           		; number of links of num1
    mov links_count2, [rsi]           		; number of links of num2
    mov carry, 0
    mov rcx, 10
    
    
    
    num2_loop:
        mov digit2, [num2_ptr+16]		;get the number from the link of the secound number
    
        num1_loop:
            mov digit1, [num1_ptr+16]		;get the number from the link of the first number
            mul digit2
            add digit1,carry
            add digit1, qword[result_ptr+16]
            jmp carry_handle                     ; carry -> handle the addition of the carry
        
        get_next_num1_digit:
            mov num1_ptr, qword [num1_ptr+8]	; get next link of first number
	    jmp end_of_num1_check
	    
        end_of_num1_check:                      ; reached the end of iteration over num1
            cmp num1_ptr,0                      
            je handle_end_of_num1               ; call fucntion to handle the case were we need to add a add/mull carry
            jmp num1_loop_end
            
        num1_loop_end:                          ; decreasing counters
            dec links_count1
            mov result_ptr, qword [result_ptr+8]; get next link of result number
            cmp links_count1,0
            jnz num1_loop
    
    
    num2_loop_end:                              ; prepere next digit of num2
        mov num2_ptr, qword[num2_ptr+8]
        cmp num2_ptr, 0 
        je handle_end_of_num2                   ; check if we have reached the end of num2
        jmp prepere_for_next_iteration          ; if not, prepere for next iteration
        
    prepere_for_next_iteration:
        mov qword num1_ptr, [rdi+24]            ; reset num1 to first digit
        mov result_curr, [result_curr+8]        ; start add from the next digit
        mov result_ptr, result_curr             ; get new starting digit for addtion
        mov carry, 0                            ; carry = 0
        mov links_count1, [rdi]                 ; reset links_count1

        dec links_count2                        ; decreasing counters
        cmp links_count2,0
        jnz num2_loop
        jmp end
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCTIONS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        
    handle_end_of_num1:
        cmp carry, 0
        jg add_at_the_end
        jmp num1_loop_end
        
    
    add_at_the_end:
        mov result_ptr, qword [result_ptr+8]
        mov qword [result_ptr+16], carry
        mov result_ptr, qword[result_ptr]
        mov carry, 0
        jmp num1_loop_end
        
        
    carry_handle:
        idiv rcx                                ; operate divition: digit1=digit1/10 and rdx=remeinder
        mov [result_ptr+16], rdx
        mov carry, digit1                       ; store carry
        jmp get_next_num1_digit
    
        
    add_at_the_end_of_num2:
        mov digit1, qword[result_ptr+16]
        idiv rcx
        mov [result_ptr+16], rdx
        mov result_ptr, qword [result_ptr+8]
        add qword [result_ptr+16], digit1 
        jmp end
        
    handle_end_of_num2:
        add qword [result_ptr+16], carry
        cmp qword [result_ptr+16], 10
        jge add_at_the_end_of_num2
        jmp end
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                
    
    end:
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbx
    pop rdx
    
    mov [rbp-8], digit1
    
    

    pop rbp                                     ; Restore caller state
    ret