%define num1_ptr r13
%define num2_ptr rbx
%define mul_carry r9
%define add_carry r10
%define links_count1 r12
%define links_count2 r11
%define result_ptr r8
%define digit1 rax
%define digit2 rcx
%define result_curr r14

section .text
global _multiply
extern printf

_multiply:
    push rbp                                    ; Save caller state
    mov rbp, rsp
    
    mov qword num1_ptr, [rdi+24]      	        ; get num1
    mov num2_ptr, [rsi+24]        		; get num2
    mov result_ptr, [rdx+24]         		; get result
    mov links_count1, [rdi]           		; number of links of num1
    xor mul_carry, mul_carry                    ; mul carry
    xor add_carry, add_carry              	; add carry
    mov links_count2, [rsi]           		; number of links of num2
    mov result_curr, result_ptr                 
    
    main_loop:
    
    inner_loop:
        
        continue_calc:
            mov digit1, [num1_ptr+16]		;get the number from the link of the first number
            mov digit2, [num2_ptr+16]		;get the number from the link of the secound number
            mul digit2  	      		;digit1=digit1*digit2
            add digit1, mul_carry    		;add previus mul carry
            mov qword [result_ptr+16], digit1   ;store resualt in result num
            cmp digit1, 10		        ;check if there is a carry from the mul op
            jge has_mul_carry
            jmp get_next_digit1            

        has_mul_carry:
            mov digit2, 10
	    idiv digit2 	       		;digit1=digit1/digit2, remeinder in rdx
            mov [result_ptr+16], rdx     	;store resualt in result num
            mov mul_carry, digit1         	;save mul carry into mul_carry
	    jmp get_next_digit1

	get_next_digit1:
	    mov num1_ptr, qword [num1_ptr+8]	;get next link of first number
	    mov result_ptr, qword [result_ptr+8];get next link of result number

	    
        end_of_number_check:
        cmp num1_ptr,0
        je inner_end
        jmp go_back
        
        go_back:
            dec links_count1
            cmp links_count1,0
            jnz inner_loop
	     
        inner_end:
            mov qword [result_ptr+16], mul_carry
    
    get_next_digit2:
        
        end_of_number2_check:
            cmp num2_ptr,0
            je end
        
        
        mov num2_ptr, qword [num2_ptr+8]
        mov qword num1_ptr, [rdi+24]
        mov result_curr, [result_curr+8]
        mov result_ptr, result_curr
    
        dec links_count2
        cmp links_count2,0
        jnz main_loop
    
    end:
    mov [rbp-8], digit1

    pop rbp                                     ; Restore caller state
    ret