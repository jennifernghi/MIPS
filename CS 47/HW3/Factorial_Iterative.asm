.include "./cs47_macro.asm"

#int main(void){
#    printf("%lu", fibonacci(10));
#}

#int fibonacci(int x){
#    unsigned long int result =1;
#    for(unsigned int i = 1; i<=x; i++){
#        result *= i;
#    }   
#    return result;
#}

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	
# Write body of the iterative
# factorial program here
# Store the factorial result into 
# register $s0

	
	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit
	

fibonacci:
	#save $t0
	addi $sp, $sp, -4
	sw $t0, 0($sp)

	#recover $t0
	lw $t0, 0($sp)
	addi $sp, $sp, 4

