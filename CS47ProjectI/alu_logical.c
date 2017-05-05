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

int au_logic(int * a0, int *a1, int *a2){
    
    if(*a2 == '+')
    {
        return add_Logical(a0, a1, a2);
    }else if(*a2 == '-'){
        return sub_Logical(a0, a1, a2);
    }
    
}

int add_Logical (int  a0, int a1, int a2, int *v1){
    a2 = 0;
    return add_sub(a0, a1, a2, v1);
}

int sub_Logical (int  a0, int a1, int a2, int * v1){
    a2 = 1;
    return add_sub(a0, a1, a2, v1);
}
int add_sub(int a0, int a1, int a2, int * v1){
    
    //reg save: ra, s0, s1, t0, t1, t2, t3, t4
    
    int s0 =0; // i =0; index; li 0 in MIPS
    int v0 = 0; //S =0; li 0 in MIPS
    
    int s1 =0; // carry
    
    int s2 = 0; // y
    int t0, t1, t2, t3 =0;//temp regs
    
    s1 = a2;
    
    if(s1==1){
        a1 = ~ a1; //sub
    }
    
    while(s0<32){
        extract_nth_bit(&t0, a0, s0); //t0
        extract_nth_bit(&t1, a1, s0); //t1
        
        t2 = t0 ^ t1;
        s2 = t2 ^ s1; //y = A^B^Ci
        
        t3  = t0 & t1;
        s1 = s1 & t2;
        s1 = t3 | s1; //carry = (AB) + Ci(A^B)
        
        if(s2!=0){
            insert_one_to_nth_bit(&v0, s0, s2, 1); //s[i] = y
        }
        
        ++s0;
        
    }
    
     printf("add_sub: final carray: %d\n", s1);
    
    *v1 = s1;
    return v0;
    
}

int twos_complement(int a0, int *v1){
    a0  = ~a0;
    int a1 = 1;
    int a2 = 0;
     printf("twos_complement\n");
    
   return  add_Logical(a0, a1, a2, v1);
    
    
}

int twos_complement_if_neg(int a0, int *v1){
    
    if(a0<0){
        printf("twos_complement_if_neg\n");
        return  twos_complement(a0, v1);
    }
    
    
}

void twos_complement_64bit(int a0, int a1, int *v0, int *v1){
    int t0 =0;
    a0 = ~ a0;
    t0 = ~a1;
    a1 =1;
    *v0 = add_Logical(a0, a1, 1, v1);
    
    a1 = t0;
   
    int a3 = *v1;
    
    *v1 = add_Logical(a1, a3, 1, &t0);
}

int bit_replicator(int bit){
    if(bit==0){
        return 0x00000000;
    }else{
        return 0xFFFFFFFF;
    }
}
/**
 *
 */
void mul_unsigned(int a0,  int a1, int *v0, int *v1){
    int s0 =0; //i =0
    int s1 =0; //H =0
    int s2 = a1; //L = MPLR multiplier
    int s3 = a0; //M = MCND multipliplicand
    

    
    while(s0<32){
        int t4 =0;
        int t5 = 31;
        int t0; // store L[0]
        extract_nth_bit(&t0, s2, t4);
        int t1 = bit_replicator(t0); // R = {32(L[0])}
        int t2 = s3 & t1; //X = M & R
        int t3 =1;
        
        s1 = s1 + t2; //H = H + X
        s2 = s2 >> t3; //L = L >> 1
        
        int t6 = 0;
        extract_nth_bit(&t6, s1, t4); //H[0]
        insert_one_to_nth_bit(&s2, t5, t6, t3); //L[31] = H[0]
        
        s1 = s1 >> t3; //H = H >> 1
        
        ++s0; //++i
        
    }
    
    *v0 = s2; //v0 = lo
    *v1 = s1; // v1 = hi
}
int main(void){
    
    //unsigned int a0 = -7;
    //int a1 = -11;
    //int a2 = '+';
    
    //int v1 =0;//final carry
    //int v0 =0;
    /*int v0 = twos_complement_if_neg(a0, &v1);
    printf("complement of %d: %d, final carry %d\n", a0, v0, v1);*/
    
    
    //twos_complement_64bit(a0, a1, &v0, &v1);
    
    //printf("complement of %d: %d, complement of %d: %d\n", a0, v0, a1, v1);
    
    int a0=9;
    int a1=9;
    
    int lo=0;
    int hi = 0;
    mul_unsigned(a0, a1, &lo, &hi);
    printf("%d * %d: lo = %d, hi = %d \n", a0, a1, lo, hi);
}

