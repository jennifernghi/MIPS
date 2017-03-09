//
//  iterativeFibonacci.c
//  
//
//  Created by Jennifer Nghi Nguyen on 3/9/17.
//
//

#include <stdio.h>
int fibonacci(int x);
int main(void){
    printf("%lu", fibonacci(10));
}

int fibonacci(int x){
    unsigned long int result =1;
    for(unsigned int i = 1; i<=x; i++){
        result *= i;
    }
    
    return result;
}
