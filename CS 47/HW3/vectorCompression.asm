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
	
	print_str(msg1)
	print_str(newline)
	read_int($s0) # read from stdio, store size in $s0
	
	
	addi $t0, $zero, 0 # temp = 0
	addi $t1, $zero, 0 # i = 0
	
	print_str(msg2)
	print_str(newline)
	jal writeToArray
	
	print_str(msg3)
	print_str(newline)
	
	
	jal printNonZeroVector
	
	
	print_str(newline)
	print_str(msg4)
	print_str(newline)
	
	jal printIndex
	
	exit
	
	
writeToArray: 
#for(int i =0; i<size; i++){
#         int temp = 0;
#        scanf("%d", &temp);
#        if(temp!=0){
#            a[i] = temp;
#        }

#    }
	addi $sp, $sp, -12
	sw $t1, 0($sp)
	sw $s1, 4($sp) 
	sw $ra, 8($sp)
	loop:	
		bge  $t1, $s0, endWriteToArray
		read_int($t2) # read from stdio, store the value in $t2
		beq $t2, $zero, ifinput0
	
		#ELSE
		#get correct offset to store value in the array
		sll $t3, $t1, 2 # 4*i
		add $s2, $s1, $t3 # memory[base address+offset]
		sw $t2, 0($s2)
		addi $t1, $t1, 1
		j loop

	ifinput0:
		addi $t1, $t1, 1
		j loop
				
endWriteToArray:
	lw $t1, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
printNonZeroVector:

	addi $sp, $sp, -12
	sw $t1, 0($sp)
	sw $s1, 4($sp) 
	sw $ra, 8($sp)
	loop2:	
		bge  $t1, $s0, endPrintNonZeroVector
		sll $t3, $t1, 2 # 4*i
		add $s2, $s1, $t3 # memory[base address+offset]
		lw $t2, 0($s2)
		beq $t2, $zero, if0
		print_reg_int($t2)
		print_str(space)
		addi $t1, $t1, 1
		j loop2
	
	if0: 
		addi $t1, $t1, 1
		j loop2
endPrintNonZeroVector:
	lw $t1, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
printIndex:

	addi $sp, $sp, -12
	sw $t1, 0($sp)
	sw $s1, 4($sp) 
	sw $ra, 8($sp)
	loop3:	
		bge  $t1, $s0, endPrintIndex
		sll $t3, $t1, 2 # 4*i
		add $s2, $s1, $t3 # memory[base address+offset]
		lw $t2, 0($s2)
		beq $t2, $zero, ifelement0
		print_reg_int($t1)
		print_str(space)
		addi $t1, $t1, 1
		j loop3
	
	ifelement0: 
		addi $t1, $t1, 1
		j loop3
endPrintIndex:
	lw $t1, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	