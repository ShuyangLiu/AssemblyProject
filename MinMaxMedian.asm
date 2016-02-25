#########################################################
# Find Min, Max and Median                                         
# MinMaxMedian.asm                                     	
# author: Shuyang Liu                                   
# CSC252 Project01                                      
#########################################################

#########################################################
# Pseudocode: (Bubble Sort)
# 
# for(int j=0; j<ary.length; j++){
#	for(int i=0; i<ary.length - j; i++){
#		if(ary[i]>ary[i+1]){
#			swap(ary[i],ary[i+1];
#		}
#	}
# }
#########################################################
			
		.data
nums: 		.word 		92, 31, 92, 6, 54, 54, 62, 33, 8, 52
length: 	.word 		10
min: 		.word 		0
max: 		.word 		0
median: 	.word 		0

		.globl 		main
		.text

main:
		la	$s0,nums	# Load the base address of nums to $s0
		lw	$s1,length	# Load the length of nums to $s1
		la	$s2,min		# Load the address of min
		la	$s3,max		# Load the address of max
		la	$s4,median	# Load the address of median
		
		li	$t0,0		# Initialize the loop counter (i) to 0
		li	$t1,0		# Initialize the loop counter (j) to 0
		
loop_1:		
		addi	$t2,$s1,-1	# $t2 = length - 1
		sub	$t2,$t1,$t2	# $t2 = $t1 - $t2 = j - (length - 1)
		bgez 	$t2,end		# exit loop
		nop
		li	$t0,0		# Initialize the loop counter (i) to 0

loop_2:
		sub	$t2,$s1,$t1	# $t2 = length - j
		sub	$t2,$t0,$t2	# $t2 = $t0 - $t2 = i - (length - j)
		bgez 	$t2,loop_1_end	# exit loop
		nop
		
		sll	$t3,$t0,2	# $t0*4 (Calculating offset)
		add	$t3,$s0,$t3	#
		lw	$t6,0($t3)	# Load nums[i] 
		
		sll	$t4,$t0,2	# $t0*4 (Calculating offset)
		addi	$t4,$t4,4	#
		add	$t4,$s0,$t4	#
		lw	$t7,0($t4)	# Load nums[i+1] 
		
		sub	$t5,$t6,$t7	# Subtract nums[i] by nums[i+1]
		blez 	$t5,loop_2_end	#
		nop
		
		move	$t2,$t6		# swap
		move	$t6,$t7
		move	$t7,$t2
		
		sw	$t6,0($t3)
		sw	$t7,0($t4)
		
loop_2_end:		
		addi	$t0,$t0,1	# i++
		j	loop_2
		nop	
		
loop_1_end:	
		addi	$t1,$t1,1	# j++
		j	loop_1
		nop
end:		
		lw	$t0,0($s0)	# Store Min
		sw	$t0,($s2)
		
		addi	$t1,$s1,-1	# Store Max
		sll	$t1,$t1,2
		add	$t1,$s0,$t1
		lw	$t0,0($t1)
		sw	$t0,($s3)
		
		sra 	$t1,$s1,1	# Store Median
		sll	$t1,$t1,2
		add	$t1,$s0,$t1
		lw	$t0,0($t1)
		sw	$t0,($s4)
		
		
		
		