.include "./cs47_proj_macro.asm"
.data
plus: .asciiz "+"
subt: .asciiz "-"
mul: .asciiz "*"
div: .asciiz "/"
hi: .asciiz "hi"
lo: .asciiz "lo"
eq: .asciiz "="
quotion: .asciiz "quotion "
remainder: .asciiz "remainder "
newline:	.asciiz  "\n"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:

	beq $a2, '+', add_logical
	
	beq $a2, '-', sub_logical
	
	beq $a2, '*', mul_signed
	
	beq $a2, '/', div_signed
	
add_logical:
	li $a2, 0 #add mode $a2 = 0
	j add_sub_logical	
	
sub_logical:
	li $a2, 1 #sub mode $a2 = 1
	j add_sub_logical
add_sub_logical:


#int add_sub(int *a0, int *a1, int *a2){ 
#    int s0 =0; // i =0; index; li 0 in MIPS
#    int v0 = 0; //S =0; li 0 in MIPS    
#    int s1 =0; // carry   
#    int s2 = 0; // y
#    int t0, t1, t2, t3 =0;//temp regs    
#    s1 = *a2  
#    if(s1==1){
#        *a1 = ~ *a1; //sub
#    }    
#    while(s0<32){
#        extract_nth_bit(&t0, *a0, s0); //t0
#        extract_nth_bit(&t1, *a1, s0); //t1        
#        t2 = t0 ^ t1;
#        s2 = t2 ^ s1; //y = A^B^Ci  
#        t3  = t0 & t1;
#        s1 = s1 & t2;
#        s1 = t3 | s1; //carry = (AB) + Ci(A^B)     
#        if(s2!=0){
#            insert_one_to_nth_bit(&v0, s0, s2, 1); //s[i] = y
#        }       
#        ++s0;       
#    }
#    return v0;    
#}
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $t2, 20($sp)
	sw $t3, 24($sp)
	sw $t4, 28($sp)
	sw $s2, 32($sp)

	
	li $s0, 0 # i = 0, index
	li $v0,0 #result
	li $t4, 1
	
	move $s1, $a2
	
	beqz $s1, add_sub_logical_while_loop # if a2 == 0 -> add mode
	not $a1, $a1 # if a2 == 1 -> sub mode
	
	add_sub_logical_while_loop:
		beq $s0, 32, add_sub_logical_exit
		extract_nth_bit($t0, $a0, $s0)
		extract_nth_bit($t1, $a1, $s0)
		
		xor $t2, $t0, $t1
		xor $s2, $t2, $s1 # y = a^b^cin 
		
		
		and $t3, $t0, $t1
		and $s1, $s1, $t2
		or $s1, $t3, $s1 #carry = (AB) + Ci(A^B) 
		
		
		bnez $s2, insert_y_to_Si
		addi $s0, $s0, 1
		j add_sub_logical_while_loop

		insert_y_to_Si:  #s[i] = y
		
			insert_one_to_nth_bit($v0, $s0, $s2, $t4)
			addi $s0, $s0, 1
			j add_sub_logical_while_loop
		
	add_sub_logical_exit:
		move $v1, $s1 # extension: Upgrade add_logical to return final carryout in $v1
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $t0, 12($sp)
		lw $t1, 16($sp)
		lw $t2, 20($sp)
		lw $t3, 24($sp)
		lw $t4, 28($sp)
		lw $s2, 32($sp)
		addi $sp, $sp, 36
		j exit
	

twos_complement:
#int twos_complement(int a0){
#    a0  = ~a0;
#    int a1 = 1;
#    int a2 = 0;   
#   return  add_Logical(&a0, &a1, &a2); 
#}
	addi $sp, $sp, -24
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	sw $s2, 16($sp)
	sw $t2, 20($sp)
	not $a0, $a0
	li $a1, 1
	jal add_logical # ~a0 + 1
	
	lw $t2, 20($sp)
	lw $s2, 16($sp) 	
	lw $ra, 12($sp) 	
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp) 	
	addi $sp, $sp, 24
	j exit	
twos_complement_if_neg:	
#int twos_complement_if_neg(int a0){   
#    if(a0<0)
#        return  twos_complement(a0);   
#}	
	move $v0, $a0 # if a0 != 0 -> no change
	bltz $a0, twos_complement
	j exit
	
twos_complement_64bit:
#void twos_complement_64bit(int a0, int a1, int *v0, int *v1){
#    a0 = ~ a0;
#    int t0 = ~a1;
#    a1 =1;
    
#    *v0 = add_Logical(a0, a1, 0, v1); 

#    a0 = t0;
#    t0 = *v0;
#    a1 = *v1;
    
#    *v1 = add_Logical(a0, a1, 0, v1);
#    *v0 = t0;   
#}
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $t0, 12($sp)
	
	not $a0, $a0 # $a0 = ~a0
	not $a1, $a1
	move $t0, $a1 # $t0 = ~a1
	li $a1, 1	#a1 = 1
	jal add_logical # $v0 = ~a0 +1 ->> lo
			#$v1 = final carry
	move $a0, $t0 #$a0 = ~a1
	move $t0, $v0 # $t0 = ~a0 +1 ->> lo
	move $a1, $v1 #$a1 = final carry
	jal add_logical  #$v0 = ~a1 + final carry --> hi
	move $v1, $v0 # $v1 = hi 2's complemented 
	move $v0, $t0 # $v0 = lo 2's complemented 
	

	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $t0, 12($sp)
	addi $sp, $sp, 16
	j exit

bit_replicator:
#int bit_replicator(int bit){
#    if(bit==0){
#        return 0x00000000;
#    }else{
#        return 0xFFFFFFFF;
#    }
#}	
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	beq  $a0, 0, replicator0
	beq  $a0, 1, replicator1
	
	replicator0:
		li $v0, 0x00000000
		j end_bit_replicator
	
	replicator1:	
		li $v0, 0XFFFFFFFF
		j end_bit_replicator
		
	end_bit_replicator:
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		j exit

mul_signed:
#void mul_signed(int a0,  int a1, int *v0, int *v1){
#int s0 = a0; //N1 - Multiplicand
#    int s1 = a1; //N2 - multiplier
#    int t2, t3;
#    
#    extract_nth_bit(&t2, a0, 31);
#    extract_nth_bit(&t3, a1, 31);
#        
#    int s2 = t2 ^ t3; //S
#    //Make N1 two's complement if negative
#    s0 = twos_complement_if_neg(a0, &s0);
#    
#    //Make N2 two's complement if negative
#    s1 = twos_complement_if_neg(a1, &s1);
#    
#    //Call unsigned multiplication using N1, N2. Say the result is Rhi, Rlo
#    mul_unsigned(s0,  s1, v0, v1);
#    int t0 = *v0;
#    int t1 = * v1;   
#    if(s2==1){
#        twos_complement_64bit(t0, t1,  v0,  v1);
#        //v0: lo ; v1: hi
#    }   
#}
	addi $sp, $sp, -28
	sw $s0, 0($sp)
	sw $s1, 4($sp)	
	sw $s2, 8($sp)	
	sw $ra, 12($sp)	
	sw $t4, 16($sp)
	sw $a0, 20($sp)
	sw $a1, 24($sp)
	
	li $t4, 31	

	move $s0, $a0 # N1
	move $s1, $a1 # N2
	extract_nth_bit($t2, $a0, $t4)
	extract_nth_bit($t3, $a1, $t4)
	xor $s2, $t2, $t3 # s2 = t2 ^ t3
	jal twos_complement_if_neg # a0 is still a0
	move $s0, $v0 # return from twos_complement_if_neg, twos_complement of N1
	move $a0, $s1 # a0 = s1 prepare for twos_complement_if_neg
	jal twos_complement_if_neg
	move $s1, $v0 # return from twos_complement_if_neg, twos_complement of N2
	
	#prepare for mul_unsigned
	move $a0, $s0 # a0 = N1
	move $a1, $s1 # a1 = N2
	jal mul_unsigned
	move $a0, $v0 # lo result
	move $a1, $v1 # hi result
	
	beqz  $s2, mul_signed_end # if s2 ==0, just quit
	jal twos_complement_64bit # if s2 ==1
																																																																																																											
	mul_signed_end:
		lw $s0, 0($sp)
		lw $s1, 4($sp)	
		lw $s2, 8($sp)	
		lw $ra, 12($sp)	
		lw $t4, 16($sp)
		lw $a0, 20($sp)
		lw $a1, 24($sp)
		addi $sp, $sp, 28
		j exit
	
mul_unsigned:
#void mul_unsigned(int a0,  int a1, int *v0, int *v1){
#    int s0 =0; //i =0
#    int s1 =0; //H =0
#    int s2 = a1; //L = MPLR multiplier
#    int s3 = a0; //M = MCND multipliplicand  
#    int t3 =1; 
#    int t4 =0;
#    int t5 = 31; 
#    int t6 = 0;
#    while(s0<32){
#       
#        int t0; // store L[0]
#        extract_nth_bit(&t0, s2, t4);
#        int t1 = bit_replicator(t0); // R = {32(L[0])}
#        int t2 = s3 & t1; //X = M & R
#               
#        s1 = s1 + t2; //H = H + X
#        s2 = s2 >> 1; //L = L >> 1       
#        
#        extract_nth_bit(&t6, s1, t4); //H[0]
#        insert_one_to_nth_bit(&s2, t5, t6, t3); //L[31] = H[0]        
#        s1 = s1 >> 1; //H = H >> 1        
#        ++s0; //++i       
#    }   
#    *v0 = s2; //v0 = lo
#    *v1 = s1; // v1 = hi
#}
	addi $sp, $sp, -48
	sw $s0, 0($sp)	
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)	
	sw $t5, 28($sp)
	sw $t6, 32($sp)
	sw $ra, 36($sp)
	sw $a0, 40($sp)
	sw $a1, 44($sp)
	
	
	li $s0, 0 # I =0
	li $s1, 0 # H =0
	move $s2, $a1 #L = MPLR multiplier
	move $s3, $a0 #M = MCND multipliplicand 
	li $t5, 31
	
	j mul_unsigned_while
	
	mul_unsigned_while: 
		beq $s0, 32, mul_unsigned_end
		extract_nth_bit($t0, $s2, $zero)
		move $a0, $t0 # prepare for replicator
		jal bit_replicator
		
		move $t1, $v0 # R = {32(L[0])}
		
		and $t2, $s3, $t1 #X = M & R
		add $s1, $s1, $t2 #H = H + X
		srl $s2, $s2, 1 # L = L >> 1    
		extract_nth_bit($t6, $s1, $zero) #H[0]
		insert_one_to_nth_bit($s2, $t5, $t6, $t7) #L[31] = H[0] 
		
		srl $s1, $s1, 1 # H = H >> 1     
		
		addi $s0, $s0, 1
		j mul_unsigned_while
	

	mul_unsigned_end:
	move $v0, $s2 #v0 = L
	move $v1, $s1 #v1 = H
	lw $s0, 0($sp)	
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $t0, 16($sp)
	lw $t1, 20($sp)
	lw $t2, 24($sp)
	lw $t5, 28($sp)
	lw $t6, 32($sp)
	lw $ra, 36($sp)
	lw $a0, 40($sp)
	lw $a1, 44($sp)
	addi $sp, $sp, 48
	j exit	
	
div_signed:
#void div_signed(int a0,  int a1, int *v0, int *v1){
#    int s0 = a0; //N1 - Dividend
#    int s1 = a1; //N2 - Divisor
#    int s2 = 0;
#    int t0, t1;
#    int t2, t3;    
#    extract_nth_bit(&t2, a0, 31); // t2 = a0[31]
#    extract_nth_bit(&t3, a1, 31);    // t3 = a1[31] 
#     s2 = t2 ^ t3;    
#    s0 = twos_complement_if_neg(s0, &s0);    
#    s1 = twos_complement_if_neg(s1, &s1);    
#    div_unsigned(s0,  s1, v0, v1);
#    if(s2==1){
#        *v0 = twos_complement(*v0, &t0); //quotient
#    }
#    if(t2==1){
#       * v1 = twos_complement(*v1, &t1);//remainder
#    }
#}
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t4, 20($sp)
	sw $s0, 24($sp)
	sw $s1, 28($sp)
	sw $s2, 32($sp)
	
	move $s0, $a0
	move $s1, $a1
	li $t4, 31
	extract_nth_bit($t2, $a0, $t4) # t2 = a0[31]
	extract_nth_bit($t3, $a1,  $t4)  # t3 = a1[31] 
	xor $s2, $t2, $t3 #  s2 = t2 ^ t3;   
	
	jal twos_complement_if_neg # negate N1 if neg
	move $s0, $v0
	
	move $a0, $s1
	jal twos_complement_if_neg # negate N2 if neg
	move $s1, $v0
	
	#prepare for div_unsigned
	move $a0, $s0 
	move $a1, $s1
	
	jal div_unsigned
	
	move $s0, $v0 # quotion
	move $s1, $v1 # remainder
	
	
	jal sign_quotient # correct the sign of quotient
	
	jal sign_remainder # correct the sign of remainder
	
	j div_signed_end
	
	sign_quotient:
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		beqz $s2, sign_quotient_end #s2 ==0 -> return;
		#otherwise, twos_complement(quotient)
		move $a0, $s0
		jal twos_complement
		move $s0, $v0
		
		j sign_quotient_end
		
		sign_quotient_end:
			move $v0, $s0
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			j exit
			
	sign_remainder:
		addi $sp, $sp, -8
		sw $ra, 0($sp)
		sw $v0, 4($sp)
		beqz $t2, sign_remainder_end # if $t2 == 0 -> return;
		#otherwise, twos_complement(remainder)
		move $a0, $s1
		jal twos_complement
		move $s1, $v0
		
		
		j sign_remainder_end
		
		sign_remainder_end:
			move $v1, $s1
			lw $ra, 0($sp)
			lw $v0, 4($sp)
			addi $sp, $sp, 8
			j exit
	
	div_signed_end:
		
		lw $ra, 0($sp)
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $t2, 12($sp)
		lw $t3, 16($sp)
		lw $t4, 20($sp)
		lw $s0, 24($sp)
		lw $s1, 28($sp)
		lw $s2, 32($sp)
		addi $sp, $sp, 36
		j exit
div_unsigned:
#void div_unsigned(int a0,  int a1, int *v0, int *v1){
#    
#    int s0=0; //i = 0
#    int s1 = a0;//Q
#    int s2 = a1;//D
#    int s3 =0;//R
#    int t2 = 31;
#    int t3 =1;
#    int t7;// dont need this in mips
#    
#    while(s0<32){
#        s3 = s3 << 1;
#        int t0;
#        extract_nth_bit(&t0, s1, t2); // Q[31]
#        insert_one_to_nth_bit(&s3, 0, t0 , t3); // R[0] = Q[31]        
#        s1 = s1 << 1;
#        int t1 = sub_Logical (s3, s2, t3, &t7);//S        
#        if(t1 < 0){
#            ++s0;
#        }else{
#
#        s3 =t1;
#        insert_one_to_nth_bit(&s1, 0, 1 , 1); //Q[0] = 1
#        printf("s1: %d\n", s1);        
#        ++s0;
#        }       
#    }    
#    *v0 = s1;
#    *v1 = s3;
#}	
	addi $sp, $sp, -44
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)	
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	sw $t2, 24($sp)
	sw $t3, 28($sp)
	sw $a0, 32($sp)
	sw $a1, 36($sp)
	sw $ra, 40($sp)
	
	
	li $s0, 0 # i = 0
	move $s1, $a0 # Q = a0 = Dividend
	move $s2, $a1 # D = a1 = divisor	
	li $s3, 0 # R
	li $t2, 31 
	li $t3, 1
	
	div_unsigned_while:
		beq $s0, 32, div_unsigned_end
		sll $s3, $s3, 1
		extract_nth_bit($t0, $s1, $t2) # Q[31]
		insert_one_to_nth_bit($s3, $zero, $t0 , $t8) # R[0] = Q[31] 
		sll $s1, $s1, 1
		#int t1 = sub_Logical (s3, s2, t3, &t7);//S        
		move $a0, $s3
		move $a1, $s2
		jal sub_logical
		move $t1, $v0
		
		blt $t1, 0, S_le_0
		move $s3, $t1
		insert_one_to_nth_bit($s1, $zero,$t3 , $t8)
		addi $s0, $s0, 1
		j div_unsigned_while
	S_le_0:
		addi $s0, $s0, 1
		j div_unsigned_while
		
	div_unsigned_end:
		move $v0, $s1 # v0 = Q
		move $v1, $s3 # v1 = R
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)	
		lw $t0, 16($sp)
		lw $t1, 20($sp)
		lw $t2, 24($sp)
		lw $t3, 28($sp)
		lw $a0, 32($sp)
		lw $a1, 36($sp)
		lw $ra, 40($sp)
		addi $sp, $sp, 44
		j exit
	
	
exit:
	
	jr $ra
