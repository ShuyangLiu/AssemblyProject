#########################################################################
# Matrix Multiplication                                 		
# MatrixMultiplication.asm                              		
# author: Shuyang Liu                                   		
# CSC252 Project01                                      		
#########################################################################

#########################################################################
# Pseudocode:															
# 																		
# void mmult(int[][] a, int[][] b, int[][] c)							
# {																		
# 	int s3 = a.length;//row number 3									
# 	int s4 = a[0].length;//column number 2								
# 																		
# 	int s5 = b.length;//row number 2									
# 	int s6 = b[0].length;//column number 3								
# 																		
# 	for(int i=0; i<s3; i++)//loop 1										
# 	{																	
# 		for(int j=0; j<s6; j++)//loop 2									
# 		{																
# 			for(int k=0; k<s5; k++)//loop 3								
# 			{															
# 				c[i][j] = c[i][j] + a[i][k]*b[k][j];					
# 			}															
# 		}																
# 	}																	
# }																		
#########################################################################

		.data
matrixA: 	.word 		1,2,3,4,5,6	# content of A
matrixB: 	.word 		5,6,7,8,9,10	# content of B
sizeA: 		.word 		3,2		# A is a 3 by 2 matrix
sizeB: 		.word 		2,3		# B is a 2 by 3 matrix
result: 	.word 		0:9		# declare an array of 9 integers
												# The initial value of each array element is 0
newline:	.asciiz 	", "		# Comma
		.globl 		main
		.text
main:
	la	$s0,matrixA		# Load the base address of matrix A to $s0
	la	$s1,matrixB		# Load the base address of matrix B to $s1
	
	la	$s2,result		# Load the base address of result array to $s2
	
	
	la	$s3,sizeB		# Load the base address of sizeB
	lw	$s5,0($s3)		# Load the first element of sizeB to $s4 (B row)
	lw	$s6,4($s3)		# Load the second element of sizeB to $s5 (B column)
	
	la	$s3,sizeA		# Load the base address of sizeA
	lw	$s4,4($s3)		# Load the second element of sizeA to $s4 (A column)
	lw	$s3,0($s3)		# Load the first element of sizeA to $s3 (A row)
	
					# Loop counters
	li	$t0,0			# Initially set $t0 to 0 (i=0)
	li	$t1,0			# Initially set $t1 to 0 (j=0)
	li	$t2,0			# Initially set $t2 to 0 (k=0)
	
loop1: 	
loop2:	
	mul 	$t3,$s3,$t0		# $t3 = (number of rows in A) * (i)
	add	$t3,$t3,$t1		# $t3 = $t3 + (j)
	mul 	$t3,$t3,4		# $t3 = $t3*4
	add	$t3,$t3,$s2		# add $t3 to the result array's base address
					# in order to get the address of that element
	li 	$t7,0			# Load the value at the address to $t7 (c[i][j])
	
loop3: 		
	mul	$t5,$s4,$t0
	add	$t5,$t5,$t2
	sll	$t5,$t5,2
	add	$t5,$t5,$s0
	lw	$t5,0($t5)		# Get A[i][k] and put to $t5
	
	mul	$t6,$s6,$t2
	add	$t6,$t6,$t1
	sll	$t6,$t6,2
	add	$t6,$t6,$s1
	lw	$t6,0($t6)		# Get B[k][j] and put to $t6
	
	mul 	$t5,$t5,$t6		# $t5 = $t5*$t6    (A[i][k]*B[k][j])
	add	$t7,$t5,$t7		# $t7 = $t7 + $t5
	
	addi	$t2,$t2,1		# Increment k by 1
	sub	$t5,$s5,$t2		# Subtract
	bgtz  	$t5,loop3		# Go back to loop3 if k<$s5
	nop
	
	sw	$t7,0($t3)		# Store the value to memory
	
	li	$t2,0			# reset k to 0
	addi	$t1,$t1,1		# Increment j by 1
	sub	$t6,$s6,$t1		# Subtract
	bgtz	$t6,loop2		# Go back to loop2 if j<$s6
	nop			
	
	li	$t1,0			# reset j to 0
	addi	$t0,$t0,1		# Increment i by 1
	sub	$t4,$s3,$t0		# subtract $s3 by $t0 and put it to $t4
	bgtz 	$t4,loop1		# go back and continue loop1 if i<$s3
	nop
	 	
###################################################################################	 	
########################### Print out the result array ############################
###################################################################################

	mul	$t2,$s3,$s6		# $t2 is the length of the result array
	
	li	$t0,0			# Initialize $t0 to 0
end:
	sll	$t1,$t0,2		# $t0*4
	add 	$t1,$t1,$s2		# $t1 is the address of current pointed element
	lw	$t1,0($t1)		# Load the first value of result to $t1
	li 	$v0,1
	move 	$a0,$t1
	syscall 
	
	li	$v0,4
	la	$a0,newline
	syscall 
	
	addi	$t0,$t0,1
	bne 	$t0,$t2,end
	nop
	
	
	
	
	
