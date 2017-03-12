.include "./cs47_macro.asm"
# called inside multiplication($multiplicant, $multiplier) macro
.macro getLSB($value)
.text 	
	#get the least significant bit and store it in $v1
	andi $v1, $value, 1
	
.end_macro 

#-------------------------------------------------------------

# called inside factorial($arg) -> perform multiplication
.macro multiplication($multiplicant, $multiplier)

.text 
	addi $sp $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $t0, 16($sp)
	sw $t1, 20($sp)
	
	
	#multiplicant
	move $s0, $multiplicant
	
	#multiplier
	move $s1, $multiplier
	
	
	#product
	addiu $s2, $zero, 0
	
	#LSB
	addiu $s3, $zero, 0
	
	addiu $t0, $zero, 1 # start point
	addiu $t1, $zero, 32 # end point
	
	j for
	
for:	
	# i > 32 quit for loop
	bgt $t0, $t1, ENDFOR
	
	#get LSB of multiplier
	getLSB($s1)

	#store LSB into $s3
	addiu $s3, $v1, 0
	
	#if LSB == 0, jump to IFLSB0
	beq  $s3, 0, IFLSB0
	
	#ELSE
	
	addu $s2, $s2, $s0 # add multiplicant to product and place the result in product register
	
	sll $s0, $s0, 1 # shift multiplicant left 1 bit
	srl $s1, $s1, 1 # shift multiplier right 1 bit
	j ENDIF
	
	
IFLSB0:
	
	sll $s0, $s0, 1 # shift multiplicant left 1 bit
	srl $s1, $s1, 1 # shift multiplier right 1 bit
	j ENDIF

ENDIF:
	# i++
	addiu $t0, $t0, 1
	j for

ENDFOR:
	# store final result in Sv0
	addiu $v1, $s2, 0
	
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $t0, 16($sp)
	lw $t1, 20($sp)
	addi $sp $sp, 24
.end_macro 

#-----------------------------------------------------

#find factorial($arg)
.macro factorial($arg)
#int factorial(int x){
	#    unsigned long int result =1;
	#    for(unsigned int i = 1; i<=x; i++){
	#        result *= i;
	#    }   
	#    return result;
	#}

.text
	#save $t0, $a0
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $a1, 4($sp)
	sw $t1, 8($sp)


	#parameter x	
	addu $a1, $arg, $zero

	# $t0 <- result
	#result = 1 
	addiu $t0, $zero, 1
	
	# i=1
	addiu $t1, $zero , 1
	
	j loop
	
	

loop:	
	# if i>x -> end loop
	bgt $t1, $a1, end
	
	# perform multiplication and store result in $v1
	multiplication($t0, $t1)
	
	#overwrite result
	move $t0, $v1
	
	#i++
	addiu $t1, $t1, 1 
	
	
	j loop	


end:
	# move result to $s0
	move $s0, $t0
	
	#restore $t0, $a1, $t1
	
	lw $t0, 0($sp)
	lw $a1, 4($sp)
	lw $t1, 8($sp)
	addi $sp, $sp, 12


	
.end_macro 


.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"
.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	
	#call factorial macro
	factorial($t0)
	

	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit
	

	
	
	

