.include "./cs47_macro.asm"
.data
msg1: .asciiz "Enter first number: "
msg2: .asciiz "Enter second number: "
msg3: .asciiz "Enter third number: "
msg4: .asciiz "The largest number: "
newline: .asciiz "\n"
.text 
.globl main
main:
#int a[3];
#    printf("Enter first number: ");
#    scanf("%d", &a[0]);    
#    printf("Enter second number: ");
#    scanf("%d", &a[1]);
#    printf("Enter third number: ");
#    scanf("%d", &a[2]); 
#    int max = a[0];   
#    for(int i =0; i<3; i++){
#        if(a[i]>max){
#            max=a[i];
#        }
#    }   
#    printf("The largest number: %d", max);

	#base address of array[a]
	addi $t0, $gp, 0 
	
	#a[0]
	print_str(msg1)
	read_int($t1)
	sw $t1, 0($t0)
	print_str(newline)
	
	#a[1]
	print_str(msg2)
	read_int($t1)
	sw $t1, 4($t0)
	print_str(newline)
	
	#a[2]
	print_str(msg1)
	read_int($t1)
	sw $t1, 8($t0)
	print_str(newline)
	
	#call maximum procedure
	jal maximum
	
	#print maximum value
	print_str(msg4)
	print_reg_int($v1)
	exit
	
	
	
maximum:
	# save resgisters
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $ra, 8($sp)
	
	#a[0]
	add $t0, $gp, 0
	
	#i = 0
	addi $t1, $zero, 0
	
	#size of the array
	addi $t2, $zero, 3
	
	#max=a[0]
	lw $t3, 0($t0)
	
	loop:
		beq  $t1, $t2, endloop #if i==3
		sll $t4, $t1, 2  #i*4 - offset
		add $t4, $t0, $t4 # new address memory[baseaddress + offset]
		lw $t5, 0($t4) #get a[i]
		ble $t5, $t3, ifless # if a[i]<=max
		move $t3, $t5 #move a[i] to max register
		addi $t1, $t1, 1 # i++
		j loop
	
	# if a[i]<=max	
	ifless:  
		#continue;
		addi $t1, $t1, 1 #i++
		j loop
		
endloop:
	move $v1, $t3 #return max value
	#restore registers		
	lw $t0, 0($sp)			
	lw $t1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra # back to main