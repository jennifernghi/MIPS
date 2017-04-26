.include "./cs47_proj_macro.asm"
.data
plus: .asciiz "+"
sub: .asciiz "-"
mul: .asciiz "*"
div: .asciiz "/"
hi: .asciiz "hi"
lo: .asciiz "lo"
quotion: .asciiz "quotion"
remainder: .asciiz "remainder"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	beq $a2, 43, doadd
	
	beq $a2, 45, dosubtract
	
	beq $a2, 42, domultiplication
	
	beq $a2, 47, dodivide
	
	
	
doadd:
	add $v0, $a0, $a1
	j exit
	
dosubtract:
        
        sub $v0, $a0, $a1
        j exit
domultiplication:
	mul $v0 $a0, $a1  #$v0: lo
	mfhi $v1 #$v1: hi
	j exit
dodivide:	
	div $a0, $a1 
	mfhi $v1 # remainder
	mflo $v0 # quotion 
	j exit		
	
exit:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra