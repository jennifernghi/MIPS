.include "./cs47_proj_macro.asm"
.data
plus: .asciiz "+"
subt: .asciiz "-"
mul: .asciiz "*"
div: .asciiz "/"
hi: .asciiz "hi"
lo: .asciiz "lo"
eq: .asciiz "="
quotion: .asciiz "quotion"
remainder: .asciiz "remainder"
newline:	.asciiz  "\n"
i: .asciiz  "i: "
y: .asciiz  " y"
carry: .asciiz  " carry"
v0: .asciiz  " v0 "
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
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	beq $a2, 43, add_or_sub
	
	beq $a2, 45, add_or_sub
	
	beq $a2, 42, domultiplication
	
	beq $a2, 47, dodivide
	
	
add_or_sub:
	addi $sp, $sp, -32
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $t2, 20($sp)
	sw $t3, 24($sp)
	sw $t4, 28($sp)

	
	li $s0, 0 # i = 0, index
	li $v0,0 #result
	li $t4, 1
	
	#get the correct mode: 1 fo subtraction, 0 for addition
	extract_nth_bit($s1, $a2, $t4) # get the bit at position 1 of a2
	not $s1, $s1
	andi $s1, $s1, 1
	
	beqz $s1, add_or_sub_while_loop
	not $a1, $a1
	
	add_or_sub_while_loop:
		beq $s0, 32, add_or_sub_end
		extract_nth_bit($t0, $a0, $s0)
		extract_nth_bit($t1, $a1, $s0)
		
		xor $t2, $t0, $t1
		xor $s2, $t2, $s1 # y = a^b^cin 
		
		
		and $t3, $t0, $t1
		and $s1, $s1, $t2
		or $s1, $t3, $s1
		
		
		bnez $s2, insert
		addi $s0, $s0, 1
		j add_or_sub_while_loop

		insert:
		
			insert_one_to_nth_bit($v0, $s0, $s2, $t4)
			addi $s0, $s0, 1
			j add_or_sub_while_loop
		
	add_or_sub_end:
		
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $t0, 12($sp)
		lw $t1, 16($sp)
		lw $t2, 20($sp)
		lw $t3, 24($sp)
		lw $t4, 28($sp)

		addi $sp, $sp, 32
	
domultiplication:
	
	j exit
dodivide:	
	
	j exit		
	
exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
