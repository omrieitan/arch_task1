#include <stdio.h>
#include <stdlib.h>
#include <memory.h>


typedef struct bignum {
    long number_of_digits;
    char *digit;
    char sign;
} bignum;

struct stack {
    bignum arr[1024];
    int top;
};
typedef struct stack STACK;
STACK s; // the instance of stack we'll be using

extern int _add (bignum, bignum); // todo in ASM
extern int _substract (bignum, bignum); // todo in ASM
extern int _multiply (bignum, bignum); // todo in ASM
extern int _divide (bignum, bignum); // todo in ASM

void push(bignum toPush);
bignum  pop(void);
int isEmpty(void);
void print_bignum(bignum bn);
void print_stack(void);
bignum new_bignum(char*, char);

int main() {
    s.top = -1; // init stack
    while(1) {
        int size = 10;
        char* str;
        str = (char*) calloc(size,sizeof(char));
        char c;
        char sign;
        c = (char) getchar();
        if(c == '_')
            sign = '1';
        else
            sign = '0';
        int t = 0;
        int cnt = 0;
        while(c!='\n') {
            if(cnt > size)
                str = (char*) realloc(str,2*cnt); // inc size if needed

            str[t] = (char) (c - '1');
            c = (char) getchar();
            if(c == ' '){
//                printf("str: ");
//                for(int i=0;i<strlen(str);i++)
//                    printf("%d",str[i]);
//                printf("\n");
                push(new_bignum(str, sign));
                break;
            }
            if(c == '*'){
                // todo multiply
            }
            if(c == '/'){
                // todo devide
            }
            if(c == '+'){
                // todo add
            }
            if(c == '-'){
                // todo subtract
            }
            if(c == '_'){
                // todo minus
            }
            if(c == 'p'){
                // todo print stack
            }
            if(c == 'c'){
                // todo clear stack
            }
            if(c == 'q'){
                // todo quit
            }
            t++;
            cnt++;
        }
        if(c == '\n') {
            push(new_bignum(str, sign));
            break;
        }
    }
    printf("stack size: %d\n",s.top+1);
    while(!isEmpty()){
        print_stack();
        pop();
    }
    return 0;
}

void push (bignum toPush) {
    if (s.top == (1024 - 1))
    {
        printf ("Stack is Full\n");
        return;
    }
    else
    {
        s.top = s.top + 1;
        s.arr[s.top] = toPush;
    }
}

bignum pop () {
    bignum num;
    if (s.top == - 1)
    {
        printf ("ERROR: Stack is Empty!\n");
        exit(1);
    }
    else
    {
        num = s.arr[s.top];
        s.top = s.top - 1;
    }
    return(num);
}

int isEmpty(){
    return s.top == -1;
}

void print_bignum(bignum bn){
    if(*(bn.digit)>9) {
        printf(bn.digit);
        return;
    }
    for(int i= 0; i < bn.number_of_digits; i++)
        printf("%c",*(i+bn.digit) + '1');
}

void print_stack(){
    if(isEmpty()) {
        printf("Stack is Empty.\n");
        return;
    }
    printf ("elements in stack: ");
    for(int i=s.top; i>=0; i--) {
        print_bignum(s.arr[i]);
        printf (" ");
    }
    printf ("\n");
}

bignum new_bignum(char* bn, char sign){
    bignum newNum;
    newNum.digit = bn;
    newNum.number_of_digits = strlen(bn);
    return newNum;
}

