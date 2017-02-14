# This is a skeleton MIPS assembly file that will read in a number of 
# integers and place them in an array.  It also shows you how to allocate
# space on the heap. 
# You will not need many of these functions for assignment 3, but it
# provides a good overview of how different syscalls are used.
	
		.data			# Various Text Prompts
newline:	.asciiz "\n" 
prompt:	        .asciiz "Please enter the number of entries:" 
prompt2:	.asciiz "number:"
doh:	        .asciiz "The number of entries must be larger than zero!\n"

		.text   
		.globl main

main:		jal print_prompt	# prompt the user, then read how many
					#   values will be input for the array
		bgtz $v0, good_data     # report error if less than zero
		li $v0, 4		# routine to print out error message
		la $a0, doh		#   if input was negative
		syscall
		j  main			# return to main and restart

good_data:	move $s1, $v0		# $s1 = number of integers in array
		move $s3, $s1		# $s3 = permanent copy of $s1
		li  $t0, 4		# $t0 = number of bytes per integer
		mul $a0, $s1, $t0	# space needed for array is number of
					#   ints times the int size
		li $v0, 9		# system call to allocate memory
		syscall			#   for the array
		move $s2, $v0		# $s2 = pointer to the array
		move $s4, $s2		# $s4 = permanent copy of $s2

input_loop: 	li $v0, 4		# syscall 4 = write string
		la $a0, prompt2		# output prompt for data value
		syscall			
		li $v0, 5		# syscall 5 = read integer
		syscall			# input a value
		sw $v0, ($s2)		# store value in array
		addi $s2, $s2, 4	# move pointer to next array element
		addi $s1, $s1, -1	# decrement counter
		bgtz $s1, input_loop	# repeat if more numbers
end_loop:	move $a0, $s4		# pass array size to some function
		move $a1, $s3		# pass array location to some function
		jal  some_func		# call the function
		li $v0, 10		# syscall 10 = exit the program
		syscall		

print_prompt:	li $v0, 4		# syscall 4 = write string
		la $a0, prompt
		syscall			# output the initial prompt
		li $v0, 5		# syscall 5 = read integer
		syscall			# input the number of entries
		jr $ra

some_func:
		jr $ra
