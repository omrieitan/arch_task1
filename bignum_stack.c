#include <stdio.h>
#include <stdlib.h>


/**
 * LINK for bignum implementation
 *     two sides in order to maintain a connection to the rest of the links
 *     array of integer, of size 18 to hold the number. 18 is the maximal digit number that
 *     can be held in a long variable.
 *     used: an integer to determine how match cells in the array are we using
 */
typedef struct link { // sizeof = 96 bit
    struct link * next;
    struct link * prev;
    int used;
    int digits[18];
} link;

/**
 *  BIGNUM data structure for holding big integers
 *      number_of_digits: long to hold the number of digits in the big integer
 *      sign: the bit sign 0 for positive and 1 for negative
 *      head and last pointers : holding the first and last chunks of the number
 */
typedef struct bignum { // sizeof = 32 bit
    long number_of_digits;
    int sign;
    link *head;
    link *last;
} bignum;


/**
 * ****external asm function for arithmetic operations****
 * SUPPORTED ops:
 * '+' : addition of two numbers
 * '-' : subtraction of two numbers
 * '*' : multiplication of two numbers
 * '/' : division of two numbers
 */
extern int _add (bignum*, bignum*); // todo in ASM
extern int _substract (bignum*, bignum*); // todo in ASM
extern int _multiply (bignum*, bignum*); // todo in ASM
extern int _divide (bignum*, bignum*); // todo in ASM


/**
 * bigNum Stack
 *  SUPPORTED ops:
 *  * void push(@Pamram bignum* toPush); - push element into the stack
 *  * bignum*  pop(void); -pop the top element of the stack
 *  * int isEmpty(void); -check if the stack is empty
 *  * void print_bignum(@Pamram bignum *bn); -print the whole stack, and empty the stack
 *  * void clear_stack(void); - pop all elements from stack
 */
void push(bignum* toPush);
bignum*  pop(void);
int isEmpty(void);
void print_bignum(bignum *bn);
void print_stack(void);
void clear_stack(void);

struct stack {
    bignum* arr[1024];
    int top;
};
typedef struct stack STACK;
STACK s; // the instance of stack we'll be using



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
            continue;// todo multiply
        }
        else if(c == '/'){
            continue;// todo devide
        }
        else if(c == '+'){
            continue;//printf("%i\n",_add(pop(),pop())); todo add
        }
        else if(c == '-'){
            continue;// todo subtract
        }
        else if(c == 'p'){
            print_stack();
        }
        else if(c == 'c'){
            clear_stack();
        }
        else if(c == 'q')
            break;

        else if(c == '_')
            bn->sign = 1;
        else { // if c is a number (0-9)
            bn->sign = 0;
            bn->head->digits[0] = c - '0' ;
            bn->head->used++;
            bn->number_of_digits ++;
        }
        while(c!='\n') { // append digits into current bignum
            c = (char) getchar();
            if(c == ' ' || c=='\n'){
                push(bn);
                break;
            }
            if(bn->last->used == 18){ // if last link is full
                link* newLink = (link*) malloc(sizeof(link));
                newLink->used =1;
                newLink->prev = bn->last;
                bn->last->next = newLink;
                newLink->digits[0] = c - '0';
                bn->last = newLink;
                bn->number_of_digits ++;
            }
            else{ // if last link has space left
                bn->last->digits[bn->last->used] = c - '0';
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

/*******************************************************************
 * BIGNUM stack implementation**************************************
 * *****************************************************************
 */

/**
 * PUSH
 * pushes the bigNum into the stack
 * @param bigNum pointer
 */
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

/**
 * POP
 * return the top element of the stack and removes it.
 * @return bigNum pointer
 */
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


/**
 * isEmpty
 * @return 1 for stack being empty 0 otherwise
 */
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

void clear_stack(){
    while(!isEmpty())
        pop();
}