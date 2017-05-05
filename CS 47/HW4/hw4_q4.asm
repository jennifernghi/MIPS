.include "./cs47_macro.asm"

.macro extract_n($regResult, $x, $pos)
	
#int extract_n(int x, int pos) {
     #return (x >> pos) & 1;
#}
.text
srav $regResult, $x, $pos
andi $regResult, 1	


.end_macro 

.macro set_n($regResult, $x, $pos, $regAux)
#int set_n(int x, int pos) {
#        return x | (1 << pos);
#}
addi $regAux, $zero, 1
sllv $regAux, $regAux, $pos 
or $regResult, $x, $regAux

.end_macro  
.data
newline: .asciiz "\n"
.text
.globl main
main:

#li $t0, 10 #int x = 127;
#li $t1, 32 #int i = 32;
#li $t2, 0 #int y = 0; # $t3 for b
#loop:
#	
#	addi $t1, $t1, -1 #--i
#	blt $t1, 0, quit # while loop end when i<0
#	extract_n($t3, $t0, $t1)  # b = extract_n(x, i);
#	beqz $t3, bis0 #if (b == 0)
	

#printb:
#	print_int($t3) #printf("%d", b);
	
#	j loop
#bis0:
#	set_n($t2, $t2, $t1, $t4) #y = set_n(y, i);
#	j printb
#quit:
 #       print_str(newline)
#	print_reg_int($t2) #printf("\n%d\n", y);
#	exit
li $t1, 0xFFFFFFFF #int x = 127;