section .text
global _multiply
extern printf

_multiply:
    push rbp                    ; Save caller state
    mov rbp, rsp

    mov rax, [rdi+24]        		; get num1
    mov rbx, [rsi+24]        		; get num2
    mov r8, [rdx+24]         		; get result
    mov r12, [rdi]           		; number of links of num1
    mov r9w, 0               		; mul carry
    mov r10w, 0               		; add carry
    mov r11, [rsi]           		; number of links of num2
    
    
    main_loop:
        mov ax, [rax+16]		;get the number from the link of the first number
        mov cx, [rbx+16]		;get the number from the link of the secound number
        mul cx  	      		;ax=ax*cx
	add ax, r9w     		;add previus mul carry
        mov [r8+16], ax			;store resualt in result num
        cmp qword rdx, 10		;check if there is ac carry from the mul op
        jge mul_carry
        jmp get_next_digit

        mul_carry:
	    mov cx, 10
	    idiv cx 	       		;ax=ax/cx, remeinder in dx
            mov [r8+16],dx     		;store resualt in result num
            mov r9w, ax         	;save mul carry into r9w
	    jmp get_next_digit

	get_next_digit:
	    mov rax, qword [rax+8]	;get next link of first number
	    mov r8, qword [r8+8]	;get next link of result number
 
	dec r12
	cmp r12,0
	jnz main_loop
	     
        
    mov [rbp-8], rax

    pop rbp                     ; Restore caller state
    ret
