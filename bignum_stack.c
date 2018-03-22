#include <stdio.h>
#include <stdlib.h>
#include <memory.h>


typedef struct link {
    struct link * next;
    struct link * prev;
    int used;
    int digits[18];
} link;

typedef struct bignum {
    long number_of_digits;
    int sign;
    link *head;
    link *last;
} bignum;

struct stack {
    bignum* arr[1024];
    int top;
};
typedef struct stack STACK;
STACK s; // the instance of stack we'll be using

extern int _add (bignum, bignum); // todo in ASM
extern int _substract (bignum, bignum); // todo in ASM
extern int _multiply (bignum, bignum); // todo in ASM
extern int _divide (bignum, bignum); // todo in ASM

void push(bignum* toPush);
bignum*  pop(void);
int isEmpty(void);
void print_bignum(bignum *bn);
void print_stack(void);

int main() {
    s.top = -1; // init stack
    while(1) {
        char c;
        c = (char) getchar();
        bignum* bn= (bignum*) malloc(sizeof(bignum));
        bn->number_of_digits = 0;
        bn->head = (link*) malloc(sizeof(link));
        bn->head->used=0;
        bn->last = bn->head;

        if(c == '*'){
            // todo multiply
        }
        else if(c == '/'){
            // todo devide
        }
        else if(c == '+'){
            // todo add
        }
        else if(c == '-'){
            // todo subtract
        }
        else if(c == 'p'){
            // todo print stack
        }
        else if(c == 'c'){
            // todo clear stack
        }
        else if(c == 'q'){
            // todo quit
        }
        else if(c == '_')
            bn->sign = 1;
        else { // if c is a number (0-9)
            bn->sign = 0;
            bn->head->digits[0] = c - '0' ;
            bn->head->used++;
            bn->number_of_digits ++;
        }
        while(c!='\n') {
            c = (char) getchar();
            if(c == ' ' || c=='\n'){
                push(bn);
                break;
            }
            if(bn->last->used == 18){
                link* newLink = (link*) malloc(sizeof(link));
                newLink->used =1;
                newLink->prev = bn->last;
                newLink->digits[bn->last->used-1] = c - '0';
                bn->last = newLink;
                bn->number_of_digits ++;
            }
            else{
                bn->last->digits[bn->last->used-1] = c - '0';
                bn->last->used ++;
                bn->number_of_digits ++;
            }

        }
        if(c == '\n')
            break;
    }
    printf("stack size: %d\n",s.top+1);
    while(!isEmpty()){
        print_stack();
        pop();
    }
    return 0;
}

void push (bignum* toPush) {
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

bignum* pop () {
    bignum *num;
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

void print_bignum(bignum *bn){
    link* curr = bn->head;
    while(curr != 0) {
        for (int i = 0; i < curr->used; i++) {
            printf("%d", curr->digits[i]);
        }
        if (curr->used == 18)
            curr = curr->next;
        else
            break;
    }

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

