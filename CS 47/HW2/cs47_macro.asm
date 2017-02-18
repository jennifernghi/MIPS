#<------------------ MACRO DEFINITIONS ---------------------->#

#----------------Question 1------------------#
	# read an int from stdio
	.macro read_int($arg)
	li $v0, 5  # code for read int
	syscall    # read int from stdio and store back in $v0
	move $arg, $v0 # move the value in $v0 to desired register
	.end_macro 
	
	#print int value stored in $arg register
	.macro print_reg_int($arg)
	li $v0, 1 # code for print int
	move $a0, $arg # move value store in $ arg to $a0
	syscall #print int value stored in $a0
	.end_macro 
	
#----------------Question 2------------------#

	.macro print_hi_lo($strHi,$strEqual, $strComma, $strLo)
	mfhi $t3 # move hi value from hi register to $t3
	mflo $t4 # move hi value from hi register to $t4
	
	print_str($strHi)    # print string Hi
	print_str($strEqual) # print string = 
	print_reg_int($t3)   # print value of hi
	print_str($strComma) # print string ,
	
	print_str($strLo)    # print string Lo
	print_str($strEqual) # print string = 
	print_reg_int($t4)   # print value of lo
	.end_macro 
	
	# swap value of hi and lo
	.macro swap_hi_lo($temp1,$temp2)
	
	mfhi $temp1 # $temp1 now have the value of hi
	mflo $temp2 # $temp2 now have the value of lo
	
	# swap
	
	mthi $temp2 # move the value of temp 2 to hi
	mtlo $temp1 # move the value of temp 1 to lo
	
	.end_macro 
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_int
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro
	
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
