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
    
    // printf("add_sub: final carry: %d\n", s1);
    
    *v1 = s1;
    return v0;
    
}

int twos_complement(int a0, int *v1){
    a0  = ~a0;
    int a1 = 1;
    int a2 = 0;
    
   return  add_Logical(a0, a1, a2, v1);
    
    
}

int twos_complement_if_neg(int a0, int *v1){
    
    if(a0 < 0){
      
        return  twos_complement(a0, v1);
    }
    
    
}

void twos_complement_64bit(int a0, int a1, int *v0, int *v1){
     printf("---------------------------twos_complement_64bit--------------------------\n");
    a0 = ~ a0;
    int t0 = ~a1;
    a1 =1;
    
    *v0 = add_Logical(a0, a1, 0, v1);
    a0 = t0;
    t0 = *v0;
    a1 = *v1;
    
   
    *v1 = add_Logical(a0, a1, 0, v1);
    *v0 = t0;
    printf("v0 = %d\n", *v0);
    printf("v0 = %d\n", *v1);
    
    printf("---------------------------END twos_complement_64bit--------------------------\n");
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
    printf("--------------------------- mul_unsigned---------------------------\n");
    int s0 =0; //i =0
    int s1 =0; //H =0
    int s2 = a1; //L = MPLR multiplier
    int s3 = a0; //M = MCND multipliplicand
     int t3 =1;
    int t4 =0;
    int t5 = 31;
    int t6 = 0;
    
    while(s0<32){
         printf("---------------s0 = %d------------------\n", s0);
        int t0; // store L[0]
        extract_nth_bit(&t0, s2, t4);
        printf("t0: %d\n", t0);
        int t1 = bit_replicator(t0); // R = {32(L[0])}
        printf("t1: %d\n", t1);
        int t2 = s3 & t1; //X = M & R
         printf("t2: %d\n", t2);
       
        
        s1 = s1 + t2; //H = H + X
         printf("s1: %d\n", s1);
        s2 = s2 >> t3; //L = L >> 1
         printf("s2: %d\n", s2);
        
        extract_nth_bit(&t6, s1, t4); //H[0]
         printf("t6: %d\n", t6);
        insert_one_to_nth_bit(&s2, t5, t6, t3); //L[31] = H[0]
         printf("%s s2: %d\n", "l[31]=h[0]", s2);
        
        s1 = s1 >> t3; //H = H >> 1
        printf("s1: %d\n", s1);
        ++s0; //++i
        
    }
    
    *v0 = s2; //v0 = lo
    *v1 = s1; // v1 = hi
    
    printf("Final v0: %d\n", *v0);
    printf("Final v1: %d\n", *v1);
    printf("---------------------------done mul_unsigned---------------------------\n");
}

void mul_signed(int a0,  int a1, int *v0, int *v1){
    printf("---------------------------START mul_SIGNED---------------------------\n");
    
    int s0 = a0; //N1 - Multiplicand
    int s1 = a1; //N2 - multiplier
    
    //Make N1 two's complement if negative
    s0 = twos_complement_if_neg(a0, &s0);
    
    //Make N2 two's complement if negative
    s1 = twos_complement_if_neg(a1, &s1);
    
    //Call unsigned multiplication using N1, N2. Say the result is Rhi, Rlo
    mul_unsigned(s0,  s1, v0, v1);
    
    
    int t0 = *v0;
    int t1 = * v1;
    
    printf("t0 = %d\n", t0);
    printf("t1 = %d\n", t1);
    
    
    int t2, t3;
    
    extract_nth_bit(&t2, a0, 31);
    extract_nth_bit(&t3, a1, 31);
    
    printf("t2 = %d\n", t2);
    printf("t3 = %d\n", t3);
    
    int s2 = t2 ^ t3; //S
    printf("s2 = %d\n", s2);
    
    if(s2==1){
        twos_complement_64bit(t0, t1,  v0,  v1);
        //v0: lo ; v1: hi
    }
    
     printf("---------------------------done mul_SIGNED---------------------------\n");
    
}
// ao, a1, *v0, *v1
void div_unsigned(int a0,  int a1, int *v0, int *v1){
    printf("--------------------------- div_unsigned---------------------------\n");
    
    int s0=0; //i = 0
    int s1 = a0;//Q
    int s2 = a1;//D
    int s3 =0;//R
    int t2 = 31;
    int t3 =1;
    int t7;// dont need this in mips
    int t8 = 0;
    while(s0<32){
         printf("---------------s0 = %d------------------\n", s0);
        s3 = s3 << 1;
        printf("s3: %d\n", s3);
        
        int t0;
        extract_nth_bit(&t0, s1, t2); // Q[31]
          printf("t0: %d\n", t0);
        
        insert_one_to_nth_bit(&s3, 0, t0 , 1); // R[0] = Q[31]
          printf("s3: %d\n", s3);
        
        s1 = s1 << 1;
          printf("s1: %d\n", s1);
        printf("t1 = s3 - s2 = %d - %d = ", s3, s2);
        int t1 = sub_Logical (s3, s2, 1, &t7);//S
          printf(" %d\n", t1);
        
    
        if(t1 < 0){
           
            ++s0;
        }else{
        
        printf("t1 >= 0: %d\n");
        s3 =t1;
        printf("s3: %d\n", s3);
        insert_one_to_nth_bit(&s1, 0, 1 , 1); //Q[0] = 1
        printf("s1: %d\n", s1);
        
        ++s0;
        }
        
    }
    
    *v0 = s1;
    *v1 = s3;
      printf("final v0: %d\n", *v0);
      printf("final v1: %d\n", *v1);
    
    printf("---------------------------done div_unsigned---------------------------\n");
}

void div_signed(int a0,  int a1, int *v0, int *v1){
    printf("---------------------------START mul_SIGNED---------------------------\n");
    /*
     N1 = $a0, N2 = $a1
     
     – Make N1 two's complement if negative
     
     – Make N2 two's complement if negative
     
     – Call unsigned Division using N1, N2. Say the result is Q and R
     
     – Determine sign S of Q
     
     ● Extract $a0[31] and $a1[31] bits and xor between them. The xor
     
     result is S.
     
     ● If S is 1, use the 'twos_complement' to determine two's complement
     
     form of Q.
     
     – Determine sign S of R
     
     ● Extract $a0[31] and assign this to S
     
     ● If S is 1, use the 'twos_complement' to determine two's complement
     
     form of R.
     */
    int s0 = a0; //N1 - Dividend
    int s1 = a1; //N2 - Divisor
    int s2 = 0;
    int t0, t1;
    int t2, t3;
    int t4,t5;
    
    printf("s0: %d\n ", s0);
    printf("s1: %d\n ", s1);
    extract_nth_bit(&t2, a0, 31);
    extract_nth_bit(&t3, a1, 31);
    s2 = t2 ^ t3;
    
    s0 = twos_complement_if_neg(a0, &s0);
    
    s1 = twos_complement_if_neg(a1, &s1);
    
    
    div_unsigned(s0,  s1, v0, v1);
    
    t0 = *v0;
    t1 = *v1;
    printf("v0: %d\n ", t0);
    printf("v1: %d\n ", t1);
    
    if(s2==1){
        *v0 = twos_complement(t0, &t3); //quotient
    }
    
    if(t2==1){
       * v1 = twos_complement(t1, &t4);//remainder
    }
   
   
    
    printf("final v0: %d\n ", *v0);
    printf("final v1: %d\n ", *v1);

  
    printf("---------------------------done mul_SIGNED---------------------------\n");
    
}
int main(void){
    
    //unsigned int a0 = -7;
    //int a1 = -11;
    //int a2 = '+';
    
    //int v1 =0;//final carry
    //int v0 =0;
    /*int v0 = twos_complement_if_neg(a0, &v1);*/
   // printf("complement of %d: %d, final carry %d\n", a0, v0, v1);
    
    
    //twos_complement_64bit(a0, a1, &v0, &v1);
    
    //printf("complement of %d: %d, complement of %d: %d\n", a0, v0, a1, v1);
    
    int a0 = -26;
    int a1 = 64;
    int v0 =0; int v1;
    int quotient=0;
    int remainder = 0;
    div_signed(a0, a1, &quotient, &remainder);
    printf("%d / %d: qo = %d, re = %d \n", a0, a1, quotient, remainder);
    
   // printf("%d - %d: %d \n", a0, a1, sub_Logical(a0, a1, 1, &v1));
    
}

