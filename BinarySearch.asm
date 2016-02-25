#########################################################
# Binary Search                                         
# BinarySearch.asm                                     	
# author: Shuyang Liu                                   
# CSC252 Project01                                      
#########################################################

	.data 
length: .word 10
nums:   .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10	# an "array" of 10 numbers
target: .word 11					# target number
msg1:	.asciiz "\n****Target not Found****\n"	# message to be printed if the target 
						# is not found
	.globl main
	.text
main:
	la   	$t0,nums	# load base address of array
	lw	$s1,target	# load the target number to $s1
	la   	$t5,length      # load address of length variable
	lw   	$t5, 0($t5)     # load array size
	addi	$t5,$t5,-1	# $t5 now is the right index
	li	$t7,0		# $t7 store the left index

loop:	sub	$t2,$t5,$t7	# $t2 stores the value of $t5-$t7 (right-left)
	blez	$t2,fail	# if $t2 is less or equal to zero, go to end
	nop
	add	$t2,$t5,$t7	# set $t2 to $t5 + $t7 (right + left)
	sra 	$t2,$t2,1	# Division by two (2) is accomplished more efficiently
				# using the Shift Right Arithmetic instruction
	sll	$t4,$t2,2	# left shift $t2 by 2, ($t2*4, calculating offset number)
	add	$t4,$t4,$t0	# pointer to nums[m]	
	lw	$t4,0($t4)	# load nums[m] to $t4
	sub	$t4,$t4,$s1	# subtract nums[m] with the target number 
				# and store it in $t4
	beqz 	$t4,found	# if $t4 is zero, go to found
	nop
	bltz 	$t4,less	# branch if $t4 is less than zero (target>nums[m])
	nop
	subi	$t5,$t2,1	# r = m-1
	j	loop		# jump back to loop
	nop
	
less: 	addi	$t7,$t2,1	# l = m+1
	j	loop		# jump back to loop
	nop
	
found:	li	$v0,1		# system call code for Print Integer
	move 	$a0, $t2	# move value to be printed to $a0
	syscall 
	j 	end		# jump to the end
	nop

fail:	li 	$v0, 4 		# system call code for Print String
	la 	$a0, msg1 	# load address of prompt into $a0
	syscall 		# print the prompt message
			
end:









