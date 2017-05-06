#----------------------------------------------------------------------#
#$regD : will contain 0x0 or 0x1 depending on nth bit being 0 or 1
#$regS: Source bit pattern
#$regT: Bit position n (0-31)
.macro extract_nth_bit($regD, $regS, $regT)
srav $regD, $regS, $regT
andi $regD, $regD, 1

.end_macro

#----------------------------------------------------------------------#
#$regD : This the bit pattern in which 1 to be inserted at nth position
#$regS: Value n, from which position the bit to be inserted (0-31)
#$regT: Register that contains 0x1 or 0x0 (bit value to insert)
#$maskReg: Register to hold temporary mask
.macro insert_one_to_nth_bit($regD, $regS, $regT, $maskReg)
li $maskReg, 1
sllv $maskReg, $maskReg, $regS #shifting 0x1 for $regS amount
not $maskReg, $maskReg # invert
and $regD, $regD, $maskReg #Mask $regD with $maskReg.
sllv $regT, $regT, $regS #Now, shift left register $regT by amount in $regS
or $regD, $regT, $regD #logically OR this resultant pattern to $regD
.end_macro
.text
.globl test

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

mul_unsigned:
#s0,s1,s2,s3,t0,t1,t2,t3,t4,t5,t6,ra

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
#        s2 = s2 >> t3; //L = L >> 1       
#        
#        extract_nth_bit(&t6, s1, t4); //H[0]
#        insert_one_to_nth_bit(&s2, t5, t6, t3); //L[31] = H[0]        
#        s1 = s1 >> t3; //H = H >> 1        
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
	sw $t3, 28($sp)
	sw $t4, 32($sp)
	sw $t5, 36($sp)
	sw $t6, 40($sp)
	sw $ra, 44($sp)
	
	li $s0, 0 # I =0
	li $s1, 0 # H =0
	move $s2, $a1 #L = MPLR multiplier
	move $s3, $a0 #M = MCND multipliplicand 
	li $t3, 1
	li $t4, 0
	li $t5, 31
	li $t6, 0
	j mul_unsigned_while
	
	mul_unsigned_while: 
		beq $s0, 32, mul_unsigned_end
		extract_nth_bit($t0, $s2, $t4)
		move $a0, $t0 # prepare for replicator
		jal bit_replicator
		move $t1, $v0 # R = {32(L[0])}
		
		and $t2, $s3, $t1 #X = M & R
		add $s1, $s1, $t2 #H = H + X
		srlv $s2, $s2, $t3 # L = L >> 1    
		extract_nth_bit($t6, $s1, $t4) #H[0]
		insert_one_to_nth_bit($s2, $t5, $t6, $t3) #L[31] = H[0] 
		
		srlv $s1, $s1, $t3 # H = H >> 1     
		
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
	lw $t3, 28($sp)
	lw $t4, 32($sp)
	lw $t5, 36($sp)
	lw $t6, 40($sp)
	lw $ra, 44($sp)
	addi $sp, $sp, 48
	j exit	
exit:
	
	jr $ra
test:


li $a0, 2
li $a1, 1

jal mul_unsigned
j non

non:


