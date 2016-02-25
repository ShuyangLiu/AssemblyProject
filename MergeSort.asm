################################################################################
# Merge Sort                                         	
# MergeSort.asm                                     	
# author: Shuyang Liu                                   
# CSC252 Project01                                      
################################################################################

################################################################################
# Pseudocode:
# private static void mergeSort(int [ ] a, int [ ] b, int left, int right)
#	{
#		if( left < right )
#		{
#			int center = (left + right) / 2;
#			mergeSort(a, b, left, center);
#			mergeSort(a, b, center + 1, right);
#			merge(a, b, left, center + 1, right);
#		}
#		
#		return;
#	}
#
#
#   private static void merge(int[ ] a, int[ ] b, int left, int right, int rightEnd )
#    {
#        int leftEnd = right - 1;
#        int k = left;
#        int num = rightEnd - left + 1;
#
#        while(left <= leftEnd && right <= rightEnd)
#        {
#            if(a[left]<=a[right])
#            {
#                b[k] = a[left];
#                k++;
#                left++;
#            }
#            else
#            {
#                b[k] = a[right];
#                k++;
#                right++;	
#            }
#	    }
#
#       while(left <= leftEnd)
#        {   // Copy rest of first half
#            b[k] = a[left];
#            k++;
#            left++;
#        }
#
#        while(right <= rightEnd)
#        { // Copy rest of right half
#            b[k] = a[right];
#            k++;
#            right++;
#        }
#
#        // Copy b back
#        for(int i = 0; i < num; i++)
#        {
#            a[rightEnd] = b[rightEnd];
#            rightEnd--;
#        }
#    }
################################################################################

		.data
nums: 		.word 	10,9,8,7,6,5,4,3,2,1
sorted: 	.word 	0:10
length: 	.word 	10

comma:		.asciiz 	", "	# Comma

		.globl 	main
		.text

main:
		la	$s0,nums	# Load the base address of nums to $s0
		la	$s1,sorted	# Load the base address of sorted to $s1
		
		li	$a0,0		# left index = 0 initially
		lw	$a1,length	# Load length to $t1
		addi	$a1,$a1,-1	# $t1 = $t1-1 (calculate right index)
		
		jal	mergesort	# Call the function of mergesort
		nop
		
		j	end		# Jump to end 
		nop

mergesort:	
		
		addiu 	$sp,$sp,-16	# Allocate Space on the stack 
		
		sw	$a0,0($sp)	# Store left to the allocated stack
		sw	$a1,4($sp)	# Store right to the allocated stack
		sw	$ra,12($sp)	# Save the return address 
		
		sub	$t0,$a1,$a0	# right - left
		blez 	$t0,mersortend	# if left >= right, return
		li	$t0,0		# Reset $t0 to 0

		# Calculating middle index
		add	$t0,$a0,$a1	# $t0 = left + right
		sra	$t0,$t0,1	# $t0 = $t0 / 2 ($t0 is middle index)
		move	$a2,$t0		# move $t0 to $a2
		sw	$a2,8($sp)	# store middle index
		
		lw	$a0,0($sp)	# Load left index
		lw	$a1,8($sp)
		
		# Call itself (nums, sorted, left, center)
		jal	mergesort	# Call mergesort (nums, sorted, left, center)
		nop
		
		lw	$a0,8($sp)	# Load middle index (left)
		addi	$a0,$a0,1	# middle+1
		lw	$a1,4($sp)	# Load right index (right)
		
		# Call itself (nums, sorted, center+1, right)
		
		jal	mergesort	# Call mergesort (nums, sorted, center+1, right)
		nop
		
		lw	$a0,0($sp)	# Load left index
		lw	$a1,4($sp)	# Load right index
		lw	$a2,8($sp)	# Load middle index
		addi	$a2,$a2,1
		
		# Call merge function
		jal	merge		# Call merge function
		nop
		
mersortend:
		lw	$ra,12($sp)	# Restore the return address
		addiu	$sp,$sp,16	# De-allocate stack
		jr	$ra		# Retern 
		nop
		
merge:
		addiu	$sp,$sp,-16	# Allocate Space on the stack 
		
		sw	$a0,0($sp)	# Store left
		sw	$a1,4($sp)	# Store rightEnd 
		sw	$a2,8($sp)	# Store right (middle)
		
		sw	$ra,12($sp)	# Save the return address
		
################################################################################
################### MERGE ACTION HERE ##########################################

		addi	$t7,$a2,-1	# int leftEnd = right - 1;
		
		add	$t6,$a0,$zero	# int k = left;
		sll	$t6,$t6,2	# k*4 (calculating offset)
		add	$t6,$t6,$s1	# $t6 is the address of sorted[k]
		
		sub	$t5,$a1,$a0	# int num = rightEnd - left + 1;
		addi	$t5,$t5,1
while_1:		
		sub 	$t4,$t7,$a0	# leftEnd - left
		sub	$t2,$a1,$a2	# rightEnd - right
		
		bltz	$t2,while_2	# 
		nop
		bltz  	$t4,while_2	# while(left <= leftEnd && right <= rightEnd)
		nop
		
		sll	$t2,$a0,2	# left*4 (calculating offset)
		add 	$t2,$t2,$s0	# 
		lw	$s4,0($t2)	# Load nums[left] to $s4
		
		sll	$t4,$a2,2	# right*4 (calculate offset)
		add	$t4,$t4,$s0	# 
		lw	$s5,0($t4)	# Load nums[right] to $s5
		
		sub	$s7,$s4,$s5	# nums[left] - nums[right]
		bgtz 	$s7,else_1	# 
		nop
		
		# if(a[left]<=a[right])
		sw	$s4,0($t6)	# sorted[k] = nums[left];
		addi	$t6,$t6,4	# k++
		addi	$a0,$a0,1	# left++
		
		j	while_1
		nop
		
else_1:		# else
		sw	$s5,0($t6)	# sorted[k] = nums[right];
		addi	$t6,$t6,4	# k++	
		addi	$a2,$a2,1	# right++ 
		
		j	while_1
		nop
		
while_2:	
		sub	$s7,$t7,$a0	# leftEnd - left
		bltz 	$s7,while_3	# while(left <= leftEnd)
		nop
		
		sll	$s4,$a0,2	# Load num[left]
		add	$s4,$s4,$s0	#
		lw	$s4,0($s4)	#
		
		sw	$s4,0($t6)	# sorted[k] = nums[left];
		addi	$t6,$t6,4	# k++
		addi	$a0,$a0,1	# left++
		
		j	while_2
		nop
while_3:
		sub	$s7,$a1,$a2	# rightEnd - right
		bltz	$s7,end_3	# while(right <= rightEnd)
		nop
		
		sll	$s5,$a2,2	# Load nums[right]
		add	$s5,$s5,$s0	#
		lw	$s5,0($s5)	#
		
		sw	$s5,0($t6)	# b[k] = a[right];
		addi	$t6,$t6,4	# k++
		addi	$a1,$a1,1	# right++
		
		j	while_3
		nop
		
end_3:		
		li	$s6,0		# Set $s6 (i) to 0 
		
loop_4:		
		sub	$s7,$s6,$t5	# i - num
		bgez 	$s7,end_4
		nop
		
		sll	$s7,$a1,2	# $s7 is the address of sorted[rightEnd]
		add	$s7,$s7,$s1	#
		lw	$s7,0($s7)	# Load sorted[$s7] to $s7
		
		sll	$s3,$a1,2	# $s3 is the address of nums[rightEnd]
		add	$s3,$s3,$s0	# 
		sw	$s7,0($s3)	# nums[rightEnd] = sorted[rightEnd];
		
		addi	$s6,$s6,1	# i++
		addi	$a1,$a1,-1	# rightEnd--
		
		j	loop_4
		nop
################################################################################		

end_4:		
		lw	$ra,12($sp)	# Restore the return address
		addiu	$sp,$sp,16	# De-allocate stack
		jr	$ra		# return
		nop
		
end: 
		############################
		######  PRINTING OUT  ######
		############################
		li 	$v0,1
		lw	$s7,0($s1)
		move	$a0,$s7
		syscall 	