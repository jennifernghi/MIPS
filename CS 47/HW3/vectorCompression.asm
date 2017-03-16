.include "./cs47_macro.asm"
.data
msg1: .asciiz "Enter the size of the vector:  "
msg2: .asciiz "Enter the vector elements, one integer per line:  "
msg3: .asciiz "The non-zero vector is:   "
msg4: .asciiz "The non-zero indices are:  "
size: .asciiz "size:  "
space: .asciiz "  "
newline: .asciiz "\n"
.text
.globl main
main:	

#int size =0;
#printf("size = ");
#scanf("%d", &size);    
#int a[size];
# for(int i =0; i<size; i++){
#         int temp = 0;
#        scanf("%d", &temp);
#        if(temp!=0){
#            a[i] = temp;
#        }

#    } 
#   printf("non-zero element:\n");
#   for(int i =0; i<size; i++){
#        if(a[i]!=0){
#            printf("%d\n", a[i]);
#        }
#    }   
#    printf("index non-zero element:\n");
#    for(int i =0; i<size; i++){
#        if(a[i]!=0){
#            printf("%d\n", i);
#        }
#    }
	#$s0 store the size, size = 0
	addiu $s0, $zero, 0

	#base address of the array
	addi $s1, $gp, 0
	
	addi $t1, $zero, 0 # i = 0
	
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
#for(int i =0; i<size; i++){
#         int temp = 0;
#        scanf("%d", &temp);
#        if(temp!=0){
#            a[i] = temp;
#        }

#    }
	#save register
	addi $sp, $sp, -12
	sw $t1, 0($sp) #i
	sw $s1, 4($sp) #base address
	sw $ra, 8($sp)
	loop:	
		bge  $t1, $s0, endloop # i>=size, quit loop
		read_int($t2) # read from stdio, store the value in $t2
		beq $t2, $zero, ifinput0 #if input == 0
	
		#ELSE, save input
		#get correct offset to store value in the array
		sll $t3, $t1, 2 # 4*i
		add $s2, $s1, $t3 #new address: memory[base address+offset]
		sw $t2, 0($s2) # save
		addi $t1, $t1, 1 #i++
		j loop
	#if input == 0
	ifinput0:
		addi $t1, $t1, 1
		j loop

#print non-zero vector	
printNonZeroVector:
	#store value in registers
	addi $sp, $sp, -12
	sw $t1, 0($sp) # i
	sw $s1, 4($sp) #base address
	sw $ra, 8($sp) 
	loop2:	
		bge  $t1, $s0, endloop # i>=size, exit loop
		sll $t3, $t1, 2 # 4*i
		add $s2, $s1, $t3 # memory[base address+offset]
		lw $t2, 0($s2) #load a[i] int $t2
		beq $t2, $zero, if0 #if a[i]==0
		
		#ELSE
		print_reg_int($t2)
		print_str(space)
		addi $t1, $t1, 1#i++
		j loop2
	#if a[i]==0
	if0: 
		addi $t1, $t1, 1
		j loop2

#print index of non-zero vector	
printIndex:

	addi $sp, $sp, -12
	sw $t1, 0($sp)
	sw $s1, 4($sp) 
	sw $ra, 8($sp)
	loop3:	
		bge  $t1, $s0, endloop
		sll $t3, $t1, 2 # 4*i
		add $s2, $s1, $t3 # memory[base address+offset]
		lw $t2, 0($s2) # load value into $t2
		beq $t2, $zero, ifelement0 # if a[i] == 0
		
		#ELSE
		print_reg_int($t1)#print index
		print_str(space)
		addi $t1, $t1, 1 # i++
		j loop3
	# if a[i] == 0
	ifelement0: 
		addi $t1, $t1, 1 #++
		j loop3

# end loop
#restore saved register				
endloop:
	lw $t1, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	