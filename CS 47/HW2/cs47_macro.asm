#<------------------ MACRO DEFINITIONS ---------------------->#
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
	
