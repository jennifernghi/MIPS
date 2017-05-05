# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#

#print int value stored in $arg register
.macro print_reg_int($arg)
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $v0, 4($sp)
	li $v0, 1 # code for print int
	move $a0, $arg # move value store in $ arg to $a0
	syscall #print int value stored in $a0
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	addi $sp, $sp, 8
.end_macro 
	

# Macro : print_str
# Usage: print_str(<address of the string>)
.macro print_str($arg)
        addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $v0, 4($sp)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string 
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	addi $sp, $sp, 8       
.end_macro
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
