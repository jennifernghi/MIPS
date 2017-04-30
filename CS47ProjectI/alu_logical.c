//
//  alu_logical.c
//  
//
//  Created by Jennifer Nghi Nguyen on 4/25/17.
//
//

#include <stdio.h>
void extract_nth_bit(int * regD, int regS, int regT) {
    
   * regD = (regS >> regT) & 1;
}

void insert_one_to_nth_bit(int * regD, int regS, int regT, int maskReg) {
    maskReg = 1;//li 1 in mips
    maskReg = maskReg << regS;
    maskReg = ~maskReg;
    * regD = * regD & maskReg;
    regT = regT << regS;
    * regD = regT | *regD;
    
}

int add_sub(int *a0, int *a1, int *a2){
    
    //reg save: ra, s0, s1, t0, t1, t2, t3, t4
    
    int s0 =0; // i =0; index; li 0 in MIPS
    int v0 = 0; //S =0; li 0 in MIPS
    
    int s1 =0; // carry
    
    int s2 = 0; // y
    int t0, t1, t2, t3 =0;//temp regs
    
    // get correct mode 1 for sub; 0 for add
    extract_nth_bit(&s1, *a2, 1);
    s1 = ~ s1;
    s1 = s1&1;
    
    if(s1==1){
        printf("invert of %d", *a1);
        *a1 = ~ *a1; //sub
        printf(" = %d\n", *a1);
    }
    
    while(s0<32){
        extract_nth_bit(&t0, *a0, s0); //t0
        extract_nth_bit(&t1, *a1, s0); //t1
        
        t2 = t0 ^ t1;
        s2 = t2 ^ s1; //y = A^B^Ci
        //printf("y %d = %d\n", s0, s2);
        
        t3  = t0 & t1;
        s1 = s1 & t2;
        s1 = t3 | s1; //carry = (AB) + Ci(A^B)
        //printf("carry %d = %d\n", s0, s1);
        
        if(s2!=0){
            insert_one_to_nth_bit(&v0, s0, s2, 1); //s[i] = y
            printf("v0 %d = %d\n ", s0, v0);
        }
        
        ++s0;
        
    }
    return v0;
    
}

int main(void){
    int a0 = 4;
    int a1 = 2;
    int a2 = 45; // -
    int v0 = add_sub(&a0, &a1, &a2);
    printf("\n \nResult: %d\n",v0);
}

