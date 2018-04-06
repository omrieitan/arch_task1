#include <stdio.h>
#include <stdlib.h>

/**
 * LINK for bignum implementation
 *     two sides in order to maintain a connection to the rest of the links
 *     array of integer, of size 18 to hold the number. 18 is the maximal digit number that
 *     can be held in a long variable.
 *     used: an integer to determine how match cells in the array are we using
 */
typedef struct link { // sizeof = 24 bit
    struct link * next;
    struct link * prev;
    int num;
} link;

/**
 * BIGNUM data structure for holding big integers
 *     number_of_digits: long to hold the number of digits in the big integer
 *     sign: the bit sign 0 for positive and 1 for negative
 *     head and last pointers : holding the first and last chunks of the number
 */
typedef struct bignum { // sizeof = 32 bit
    long number_of_links;
    int sign;
    link *head;
    link *last;
} bignum;

void equalize_links(bignum* bn1, bignum* bn2);
void add_carry(bignum* bn);
void sub_borrow(bignum* bn);
int compare_bignum(bignum* bn1, bignum* bn2);
void subtract(bignum* num1, bignum* num2);
void free_bigNum(bignum * bn);
bignum* init_mul_result(long length_num1,long length_num2);
int is_zero(bignum* bn1);
void add_zero(bignum* bn1,bignum* bn2);
void delete_zeros(bignum * bn);
void _div_c(bignum *num1,bignum *num2,bignum * mul_ptr,bignum * power ,bignum * ans);
bignum* init_mul_ptr(long length);
int compare_for_div(bignum * bn1,bignum * bn2);
bignum* copy_bignum(bignum* bn);
void div_helper(bignum *num1,bignum *num2,bignum * F);

/**
 * ****external asm function for arithmetic operations****
 * SUPPORTED ops:
 * '+' : addition of two numbers
 * '-' : subtraction of two numbers
 * '*' : multiplication of two numbers
 * '/' : division of two numbers
 */
extern void _add (bignum*, bignum*);
extern void _subtract (bignum*, bignum*);
extern void _multiply (bignum*, bignum*,bignum*);
extern void _divide (bignum*, bignum*, bignum*, bignum*);

//578 _86041776670101 * _64213 /
// _5604610 126 / _8532008 * 34256143 *
/**
 * bignum Stack
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

bignum* R;
bignum* Q;

int main() {
    s.top = -1; // init stack
    while(1) {
        char c;
        c = (char) getchar();
        if(c == ' ' || c == '\n')
            continue;
        bignum* bn= (bignum*) malloc(sizeof(bignum));
        bn->number_of_links = 1;
        bn->head = (link*) malloc(sizeof(link));
        bn->last = bn->head;

        if(c == '*'){
            bignum* num2 = pop();
            bignum* num1 = pop();
            bignum* result= init_mul_result(num1->number_of_links,num2->number_of_links);
            equalize_links(num1,num2);
            if(num1->sign != num2->sign)
                result->sign = 1;
            if(is_zero(num1)){
                push(num1);
                //free_bignum(num2);
            }else if(is_zero(num2)){
                push(num2);
                //free_bignum(num1);
            }
            else {
                _multiply(num1, num2, result);
                //delete_zeros(result);
                push(result);
                //free_bigNum(num1);
                //free_bigNum(num2);
            }

            //free_bigNum(bn);
            continue;
        }
        else if(c == '/'){
            bignum* num2 = pop();
            bignum* num1 = pop();
            equalize_links(num1,num2);
            int len=0;
            if(num1->number_of_links%2 == 0)
                len = (int) (num1->number_of_links / 2);
            else
                len = (int) (num1->number_of_links / 2) + 1;
            Q = init_mul_ptr(len);
            R = init_mul_ptr(len);
            bignum* F = init_mul_ptr(len);
            F->last->num = 1;
            if(is_zero(num2)) {
                printf("divide by zero\n");
                push(num2);
            }
            else if(compare_for_div(num1,num2) < 0)
                push(copy_bignum(Q));
            else if(compare_for_div(num1,num2) == 0)
                push(copy_bignum(F));
            else {
                div_helper(num1, num2,F);
                bignum * ans = copy_bignum(Q);
                if(num1->sign ^ num2->sign && is_zero(ans)!=1)
                    ans->sign=1;
                //free_bigNum(num1);
                //free_bigNum(num2);
                //free_bigNum(Q);
                push(ans);
            }
            continue;
        }
        else if(c == '+') {
            bignum *num2 = pop();
            bignum *num1 = pop();
            equalize_links(num1, num2);
            if (is_zero(num1)) {
                push(num2);
                //free_bignum(num1);
            }
            else if (is_zero(num2)) {
                push(num1);
                //free_bignum(num2);
            }
            else if(!num2->sign && num1->sign) {
                num1->sign = 0;
                subtract(num2, num1);
            }
            else if(!num1->sign && num2->sign) {
                num2->sign = 0;
                subtract(num1, num2);
            }
            else {
                _add(num1, num2);
                push(num1);
                //free_bigNum(num2);
            }
            //free_bigNum(bn);
            continue;
        }
        else if(c == '-'){
            bignum* num2 = pop();
            bignum* num1 = pop();
            subtract(num1,num2);

            continue;
        }
        else if(c == 'p'){
            if(s.top == -1)
                printf("stack empty\n");
            else
                print_bignum(s.arr[s.top]);
            printf("\n");
            //free_bigNum(bn);
            continue;
        }
        else if(c == 'c'){
            clear_stack();
            //free_bigNum(bn);
            continue;
        }
        else if(c == 'q') {
            //free_bigNum(bn);
            break;
        }
        else if(c == '_') {
            bn->sign = 1;
            c = (char) getchar();
            bn->head->num = (c - '0');
        }
        else { // if c is a number (0-9)
            bn->sign = 0;
            bn->head->num = (c - '0');
        }
        while(c!='q') { // append digits into current bignum
            c = (char) getchar();
            if(c == ' ' || c=='\n'){
                push(bn);
                break;
            }
            link* newLink = (link*) malloc(sizeof(link));
            newLink->prev = bn->last;
            newLink->num = (c - '0');
            bn->last->next = newLink;
            bn->last = newLink;
            bn->number_of_links ++;
        }
        if(c == 'q') {
            break;
        }
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
        s.arr[s.top]=0;
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
    int zeros = 0;
    link* curr = bn->head;
    if(bn->sign && is_zero(bn) == 0)
        printf("-");
    while(curr != 0) {
        if(zeros > 0 || curr->num!=0 || curr->next == 0) {
            printf("%i", curr->num);
            zeros = 1;
        }
        curr = curr->next;
    }

}

void print_stack(){
    if(isEmpty()) {
        printf("Stack is Empty.\n");
        return;
    }
    for(int i=s.top; i>=0; i--) {
        if(i==0)
            print_bignum(s.arr[i]);
        else{
            print_bignum(s.arr[i]);
            printf (" ");
        }
    }
    printf ("\n");
}

void clear_stack(){
    while(!isEmpty())
        pop();
}

void equalize_links(bignum* bn1, bignum* bn2){
    while(bn1->number_of_links > bn2->number_of_links){
        link* newLink = (link*) malloc(sizeof(link));
        newLink->num = 0;
        bn2->head->prev = newLink;
        newLink->next = bn2->head;
        bn2->head = newLink;
        bn2->number_of_links ++;
    }
    while(bn1->number_of_links < bn2->number_of_links){
        link* newLink = (link*) malloc(sizeof(link));
        newLink->num = 0;
        bn1->head->prev = newLink;
        newLink->next = bn1->head;
        bn1->head = newLink;
        bn1->number_of_links ++;
    }
}

void add_carry(bignum* bn){
    link* newLink = (link*) malloc(sizeof(link));
    newLink->num = 1;
    bn->head->prev = newLink;
    newLink->next = bn->head;
    bn->head = newLink;
    bn->number_of_links ++;
}

void sub_borrow(bignum* bn){
    link* oldLink = bn->head;
    bn->head = bn->head->next;
    free(oldLink);
    bn->number_of_links --;
}

int compare_bignum(bignum* bn1, bignum* bn2){
    int ans = (int) (bn1->number_of_links - bn2->number_of_links);
    equalize_links(bn1,bn2);
    if (ans!=0)
        return ans;
    link* curr1=bn1->head;
    link* curr2 = bn2->head;
    while(curr1!=0 && curr1->num == curr2->num){
        curr1 = curr1->next;
        curr2 = curr2->next;
    }
    if(curr1 == 0)
        return 0;
    return curr1->num - curr2->num;

}

void subtract(bignum* num1, bignum* num2){
    int comp = compare_bignum(num1,num2);
    if (is_zero(num1)) {
        num2->sign=( num2->sign==1) ? 0 :1;
        push(num2);
        //free_bignum(num1);
    }
    else if (is_zero(num2)) {
        push(num1);
        //free_bignum(num2);
    }
    else if (comp > 0 && (num1->sign+num2->sign == 0 || num1->sign+num2->sign == 2)) { // 1 6
        _subtract(num1, num2);
        push(num1);
        //free_bigNum(num2);
    }
    else if(comp < 0 && (num1->sign+num2->sign == 0 || num1->sign+num2->sign == 2)){ // 2 7
        _subtract(num2, num1);
        num2->sign = 1 - num2->sign; // if =1 change to 0 , if =0 change to 1
        push(num2);
        //free_bigNum(num1);
    }
    else if(num1->sign ^ num2->sign){ // 3 4 5 8
        _add(num1, num2);
        push(num1);
        //free_bigNum(num2);
    }
    else if(comp == 0){
        _subtract(num1, num2);
        num1->sign = 0;
        push(num1);
        //free_bigNum(num2);
    }
}

void free_bigNum(bignum * bn){
    link *temp = bn->head;
    for(int i=0; i<bn->number_of_links;i++){
        temp=bn->head;
        bn->head=bn->head->next;
        free(temp);
    }
}

bignum* init_mul_result(long length_num1,long length_num2){
    long length=((length_num1>=length_num2) ? length_num1 : length_num2)*2;
    bignum* result= (bignum*) malloc(sizeof(bignum));
    result->number_of_links = length;
    result->sign=0;
    result->head = (link*) malloc(sizeof(link));
    result->last = result->head;
    result->last->num = 0;
    for(int i=1; i<length;i++){
        link* newLink = (link*) malloc(sizeof(link));
        newLink->num = 0;
        newLink->prev = result->last;
        result->last->next = newLink;
        result->last = newLink;
    }
    return result;
}

int is_zero(bignum* bn1){
    link* curr = bn1->head;
    while(curr!=0) {
        if (curr->num != 0)
            return 0;
        curr = curr->next;
    }
    return 1;
}

void add_zero(bignum* bn1,bignum* bn2){
    link* newLink = (link*) malloc(sizeof(link));
    newLink->num = 0;
    newLink->next = bn1->head;
    bn1->head->prev = newLink;
    bn1->head = newLink;
    bn1->number_of_links++;

    link* newLink2 = (link*) malloc(sizeof(link));
    newLink2->num = 0;
    newLink2->next = bn2->head;
    bn2->head->prev = newLink2;
    bn2->head = newLink2;
    bn2->number_of_links++;

}


void delete_zeros(bignum * bn){
    while(bn->head->num == 0 && bn->number_of_links!=1){
        bn->head=bn->head->next;
        free(bn->head->prev);
        bn->number_of_links--;
    }
}

bignum* init_mul_ptr(long length){
    long new_length = length*2;
    bignum* result= (bignum*) malloc(sizeof(bignum));
    result->number_of_links = new_length;
    result->head = (link*) malloc(sizeof(link));
    result->last = result->head;
    result->last->num = 0;
    for(int i=0; i<new_length;i++){
        link* newLink = (link*) malloc(sizeof(link));
        newLink->num = 0;
        newLink->prev = result->last;
        result->last->next = newLink;
        result->last = newLink;
    }
    return result;
}

void div_helper(bignum *num1,bignum *num2,bignum * F){
    if(compare_for_div(num1,num2) < 0){
        Q = init_mul_ptr(num1->number_of_links/2);
        R = num1;
    }
    else{
        bignum * b1 = copy_bignum(num2);
        _add(b1,num2);
        bignum * f1 = copy_bignum(F);
        _add(f1,F);
        div_helper(num1,b1,f1);
        if(compare_for_div(R,num2) >= 0 ){
            _add(Q,F);
            _subtract(R,num2);
        }
    }
}


int compare_for_div(bignum * bn1,bignum * bn2){
    equalize_links(bn1,bn2);
    link* curr1 = bn1->head;
    link* curr2 = bn2->head;
    while(curr1!=0 && curr1->num == curr2->num){
        curr1 = curr1->next;
        curr2 = curr2->next;
    }
    if(curr1 == 0)
        return 0;
    return curr1->num - curr2->num;
}

bignum* copy_bignum(bignum* bn) {
    bignum* bn_copy = (bignum *) malloc(sizeof(bignum));
    bn_copy->number_of_links = 1;
    bn_copy->head = (link *) malloc(sizeof(link));
    bn_copy->last = bn_copy->head;
    bn_copy->head->num = bn->head->num;

    link *curr = bn->head->next;
    while (curr != 0) {
        link *newLink = (link *) malloc(sizeof(link));
        newLink->num = curr->num;
        newLink->prev = bn_copy->last;
        bn_copy->last->next = newLink;
        bn_copy->last = newLink;
        bn_copy->number_of_links++;

        curr = curr->next;
    }
    return bn_copy;
}