.include "./cs47_macro.asm"
.data
msg1: .asciiz "Enter the size of the vector:  "
msg2: .asciiz "Enter the vector elements, one integer per line:  "
msg3: .asciiz "The non-zero vector is:   "
msg4: .asciiz "The non-zero indices are:  "
space: .asciiz "  "
newline: .asciiz "\n"
.text
.globl main
main:	
# int size =0;
#    printf("size = ");
#    scanf("%d", &size);
#    
#    int k=0;
#    int a[size];
#    for(int i =0; i<2*size;i=i+2){
#        int temp = 0;
#        scanf("%d", &temp);
#        if(temp!=0){
#            a[k] = temp;
#            a[k+1] = i/2;
#            k += 2;
#        }
#    }        
#    printf("non-zero element:\n");
#    for(int i =0; i<k; i=i+2){
#        printf("%d\n", a[i]);        
#    }    
#    printf("index non-zero element:\n");
#    for(int i =1; i<=k; i+=2){
#        printf("%d\n", a[i]);
#    }
	#$s0 store the size, size = 0
	addiu $s0, $zero, 0

	#base address of the array
	addi $s1, $gp, 0
	
	addi $s2, $zero, 0 # k = 0  <-index to access array
	
	#enter size
	print_str(msg1)
	print_str(newline)
	read_int($s0) # read from stdio, store size in $s0
	
	#enter input
	print_str(msg2)
	print_str(newline)
	
	jal writeToArray
	

	# print non-zero vector
	print_str(msg3)
	print_str(newline)
	
	
	jal printNonZeroVector
	
	#print non-zero vector indices
	print_str(newline)
	print_str(msg4)
	print_str(newline)
	
	jal printIndex
	
	exit
	
#user input value a
#value is stored in the array	
writeToArray: 
#for(int i =0; i<2*size;i=i+2){
#        int temp = 0;
#        scanf("%d", &temp);
#        if(temp!=0){
#            a[k] = temp;
#            a[k+1] = i/2;
#            k += 2;
#        }
#    }
#base start at 0($gp)
#do not store 0 value in array
#store only nonzero vectors followed by their indices
#[nonzero vec 1][index 1][nonzero vec 2][index 2]...[nonzero vec n][n]

	#save registers used in this callee
	addi $sp, $sp, -28
	sw $t1, 0($sp) #i
	sw $t3, 4($sp)
	sw $ra, 8($sp)
	sw $t2, 12($sp)
	sw $t0, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	addi $t1, $zero, 0  #<- i =0  
	sll  $t3, $s0, 1  #<- 2*size
	loop:	
		bge   $t1, $t3, endloop # i>=2size, quit loop
		read_int($t2) # read from stdio, store the value in $t2
		beq $t2, $zero, ifinput0 #if input == 0
		
		
		#ELSE, save nonzero vector
		sll $t0, $s2, 2 # offset 4*k
		add $t4, $s1, $t0 #new address store non-zero vector: memory[base address+offset]
		sw $t2, 0($t4) # save nonzero  index
		
		#save index of non-zero vector
		
		add $t4, $s2, 1 # k+1 
		sll $t4, $t4, 2 # new offset 4* (k+1)
		add $t4, $s1, $t4 # new address for storing index
		srl $t5, $t1, 1 #i/2
		sw $t5, 0($t4) # store index
		addi $s2, $s2, 2 # k += 2, used globally, -> no need to save this 
		
		
		addi $t1, $t1, 2 # i +=2
		j loop
		
	#if input == 0
	ifinput0:
		addi $t1, $t1, 2 # i +=2
		j loop

				
endloop:
	sw $t1, 0($sp) #i
	sw $t3, 4($sp)
	sw $ra, 8($sp)
	sw $t2, 12($sp)
	sw $t0, 16($sp)
	sw $t4, 20($sp)
	sw $t5, 24($sp)
	addi $sp, $sp, 28
	jr $ra
	
#print non-zero vector	
printNonZeroVector:
	#save register used in this callee
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp) 
	sw $ra, 8($sp) 
	sw $t3, 12($sp) 
	addi $t1, $zero, 0 # <- i =0
#    printf("non-zero element:\n");
#    for(int i =0; i<k; i=i+2){
#        printf("%d\n", a[i]);        
#    } 
	loop2:	
		bge  $t1, $s2, endprintloop # i>=k, exit loop
		sll $t3, $t1, 2 # 4*i
		add $t3, $s1, $t3 # memory[base address+offset]
		lw $t2, 0($t3) #load a[i] int $t2
		print_reg_int($t2)
		print_str(space)
		
		addi $t1, $t1, 2 #i +=2 
		j loop2

#print index of non-zero vector	
printIndex:

	#save registers used in this callee
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp) 
	sw $ra, 8($sp) 
	sw $t3, 12($sp) 
	addi $t1, $zero, 1 # <- i =1
	loop3:	
		bgt  $t1, $s2, endprintloop
		sll $t3, $t1, 2 # 4*i
		add $t3, $s1, $t3 # memory[base address+offset]
		lw $t2, 0($t3) #load a[i] int $t2
		print_reg_int($t2)
		print_str(space)
		addi $t1, $t1, 2#i++
		j loop3

# same endprintloop used for printNonZeroVector and printIndex		
endprintloop:
	#restore saved registers
	lw $t1, 0($sp) # i
	lw $t2, 4($sp) 
	lw $ra, 8($sp) 
	lw $t3, 12($sp) 
	addi $sp, $sp, -16
	jr $ra #back to main
