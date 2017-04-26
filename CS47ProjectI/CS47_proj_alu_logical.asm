.include "./cs47_proj_macro.asm"
.data
plus: .asciiz "+"
sub: .asciiz "-"
mul: .asciiz "*"
div: .asciiz "/"
hi: .asciiz "hi"
lo: .asciiz "lo"
eq: .asciiz "="
quotion: .asciiz "quotion"
remainder: .asciiz "remainder"
newline:	.asciiz  "\n"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
# TBD: Complete it
	
	