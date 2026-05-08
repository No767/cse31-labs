.data 

orig: .space 100	# In terms of bytes (25 elements * 4 bytes each)
sorted: .space 100

str0: .asciiz "Enter the number of assignments (between 1 and 25): "
str1: .asciiz "Enter score: "
str2: .asciiz "Original scores: "
str3: .asciiz "Sorted scores (in descending order): "
str4: .asciiz "Enter the number of (lowest) scores to drop: "
str5: .asciiz "Average (rounded down) with dropped scores removed: "
str6: .asciiz "All scores dropped!"

.text 


# This is the main program.
# It first asks user to enter the number of assignments.
# It then asks user to input the scores, one at a time.
# It then calls selSort to perform selection sort.
# It then calls printArray twice to print out contents of the original and sorted scores.
# It then asks user to enter the number of (lowest) scores to drop.
# It then calls calcSum on the sorted array with the adjusted length (to account for dropped scores).
# It then prints out average score with the specified number of (lowest) scores dropped from the calculation.
main: 
	addi $sp, $sp -4
	sw $ra, 0($sp)

validate_input:
	la $a0, str0 
	li $v0, 4 
	syscall 
	li $v0, 5	# Read the number of scores from user
	syscall
	
	# Your code here to handle invalid number of scores (can't be less than 1 or greater than 25)
	
	# If it's invalid, it will go to the start of the validate_input label, thus causing a loop
	# Check for less than 0
	slt $t1, $zero, $v0
	beq $t1, $zero, validate_input

	# Check for > 25
	# We need to load up the immediate value of 25
	li $t1, 25
	slt $t2, $t1, $v0
	bne $t2, $zero, validate_input

	move $s0, $v0	# $s0 = numScores
	move $t0, $0
	la $s1, orig	# $s1 = orig
	la $s2, sorted	# $s2 = sorted

loop_in:
	li $v0, 4 
	la $a0, str1 
	syscall 
	sll $t1, $t0, 2

	add $t2, $t1, $s1	# $t2 = offset + orig array base address
	add $t3, $t1, $s2	# $t3 = offset + sorted array base address

	li $v0, 5	# Read elements from user
	syscall
	sw $v0, 0($t2)
	sw $v0, 0($t3)

	addi $t0, $t0, 1
	bne $t0, $s0, loop_in
	
	move $a0, $s0
	jal selSort	# Call selSort to perform selection sort in original array
	
	li $v0, 4 
	la $a0, str2 
	syscall
	move $a0, $s1	# More efficient than la $a0, orig
	move $a1, $s0
	jal printArray	# Print original scores
	li $v0, 4 
	la $a0, str3 
	syscall 
	move $a0, $s2	# More efficient than la $a0, sorted
	jal printArray	# Print sorted scores
	
	read_dropped:
		li $v0, 4 
		la $a0, str4 
		syscall

		li $v0, 5	# Read the number of (lowest) scores to drop
		syscall

		# Your code here to handle invalid number of (lowest) scores to drop (can't be less than 0, or 
		# greater than the number of scores). Also, handle the case when number of (lowest) scores to drop 
		# equals the number of scores. 

		# drop < 0
		slt $t0, $v0, $zero        
    	bne $t0, $zero, read_dropped

		# drop > numScores
		slt $t0, $s0, $v0
		bne $t0, $zero, read_dropped

		# drop == numScores
		beq $v0, $s0, all_dropped


	move $a1, $v0
	sub $a1, $s0, $a1	# numScores - drop
	move $a0, $s2
	jal calcSum	# Call calcSum to RECURSIVELY compute the sum of scores that are not dropped
	
	# Your code here to compute average and print it (you may also end up having some code here to help 
	# handle the case when number of (lowest) scores to drop equals the number of scores
	
	# Values are:
	# - $v0: Official return value of calcSum
	# - $a1: numScores
	# Note that it's safe to use $a1 here as we restored the original values from the stack before the calls for calcSum
	div $v0, $a1
	mflo $t0
	
	li $v0, 4
	la $a0, str5
	syscall
	
	li $v0, 1
	addu $a0, $zero, $t0
	syscall
	

	j end

	all_dropped:
		li $v0, 4
		la $a0, str6
		syscall
		

end:	lw $ra, 0($sp)
	addi $sp, $sp 4
	li $v0, 10 
	syscall
	
	
# printList takes in an array and its size as arguments. 
# It prints all the elements in one line with a newline at the end.
printArray:
	# Note:
	# - Syscall 1 = print_int
	# - Syscall 11 = print_character
	# - ASCII code 10 = \n
	# - ASCII code 32 = ' '
	# See: https://asm-editor.specy.app/documentation/mips/syscall

	# Register mappings:
	# - $t0 = Array address to the element (starts off at the base address)
	# - $t1 = Length of array
	# - $t2 = Loop counter

	# Using the stack would result in 12 * n bytes of RAM being used
	# I.e., if we needed to print out 100 elements, it would be 12 * 100 = 1200 bytes of RAM
	# Seems negligible but could stack up. So by using $t0-$t2, we use 0 bytes of RAM	
	addu $t0, $zero, $a0 
	addu $t1, $zero, $a1
	add  $t2, $zero, $zero

	print_loop:
		# if (i < len)
		slt $t3, $t2, $t1
		beq $t3, $zero, end_print

		li $v0, 1
		lw $a0, 0($t0)
		syscall

		li $v0, 11
		li $a0, 32
		syscall

		# Cheap way to move to a different element, by nudging the address forward by 4 bytes
		addi $t0, $t0, 4    # $t0 += 4, or in C, *ptr++
		addi $t2, $t2, 1	# i++
		j print_loop

	end_print:
		li $v0, 11
		li $a0, 10
		syscall

		jr $ra
	

# selSort takes in the number of scores as argument. 
# It performs SELECTION sort in descending order and populates the sorted array
selSort:
	
	# Register Map:
	# $a1 = len
	# $t0 = i (Outer loop counter)
	# $t1 = j (Inner loop counter)
	# $t2 = max_idx
	# $t3 = Base address of 'sorted' array
	
	# Note: We are not pushing $t0-t3 into the stack. We could, but that would result in wasted memory and unnescary management
	# As this is a leaf function anyways, it's safe to use $t0-$t9 here

	# The length of our sorted array will always be the same as the original one
	addu $a1, $zero, $a0

	# Load the address for our sorted array
	# Note that the sorted array WILL CONTAIN all user inputs, as we saved it to $t3
	la $t3, sorted

	# i = 0
	add $t0, $zero, $zero      

	outer_loop:
		# if (i < len - 1)
		addi $t4, $a1, -1		# $t4 = len - 1
		slt $t5, $t0, $t4		# $t5 = 1 if i < ($t4)
		beq $t5, $zero, end_sort

		# max_idx = i
		addu $t2, $zero, $t0   

		# j = i + 1
		addi $t1, $t0, 1           

		inner_loop:
			# if (j < len)
			slt $t4, $t1, $a1		# $t4 = 1 if $t1 < $a1
			beq $t4, $zero, end_inner

			# The general process for getting the element of an array is:
			# 1. Offset the amount of bytes by "j" * 4
			#     a. We need to multiply "j" by 4 bytes (which is the size of each element here)
			# 2. Get the base address
			# 3. Calculate final address by: Base Address + Offset
			# 4. Load the value from the final address
			# Note that step 2 is already done, which the base address is in $t3

			# sorted[j], $t5
			sll $t4, $t1, 2		# Get offset by doing sll (much faster than multiplying by 4)
			add $t4, $t3, $t4   # Address to sorted[j]
			lw $t5, 0($t4)		# Load address

			# sorted[maxIndex], $t7
			sll $t6, $t2, 2
			add $t6, $t3, $t6
			lw $t7, 0($t6)

			# if (sorted[j] > sorted[maxIndex])
			# If false, sorted[maxIndex] is still the biggest
			slt $t8, $t7, $t5
			beq $t8, $zero, skip_max

			# maxIndex = j
			# "j" is our new max
			addu $t2, $zero, $t1

		skip_max:
			# j++, restart inner loop
			addi $t1, $t1, 1           
			j inner_loop

		end_inner:
			# sorted[i], $t5
			# Address of sorted[i] is in $t4
			sll $t4, $t0, 2
			add $t4, $t3, $t4
			lw $t5, 0($t4)

			# sorted[maxIndex], $t7
			# Address of sorted[maxIndex] is in $t6
			sll $t6, $t2, 2
			add $t6, $t3, $t6
			lw $t7, 0($t6)

			# Now swap the values of $t5 with $t7, $t7 with $t5
			# Note that we don't actually need the temp variable here 
			# as both are in the registers. They won't be destroyed yet, so it's safe
			sw $t7, 0($t4) # sorted[i] = sorted[maxIndex]
			sw $t5, 0($t6) # sorted[maxIndex] = sorted[i]

			# i++
			addi $t0, $t0, 1           
			j outer_loop               

	end_sort:
		jr $ra
	
# calcSum takes in an array and its size as arguments.
# It RECURSIVELY computes and returns the sum of elements in the array.
# Note: you MUST NOT use iterative approach in this function.
# Note: $v0 is the OFFICIAL return output value for calcSum
calcSum:

	recursive_calc:
		# Base case: if $t0 == 0
		slt $t0, $zero, $a1       
		beq $t0, $zero, return_zero

		# We want to store our arguments, and the return address
		# $a0 is array address
		# $a1 is our current length

		addi $sp, $sp, -12
		sw $ra, 8($sp)
		sw $a1, 4($sp)
		sw $a0, 0($sp)

		# Move on one layer deeper
		addi $a1, $a1, -1

		# main recursive loop
		jal recursive_calc


	sum_scores:
		# Load our values up again
		# As they may be tainted from the recursive calls
		lw $a0, 0($sp)
		lw $a1, 4($sp)
		lw $ra, 8($sp)

		# Yeet stackframe away, as we don't need it anymore
		addi $sp, $sp, 12

    	# Now we want to get the arr[len - 1]
		# The way we are going to do this is to overshoot 4 bytes after the end of the array address, and go back 4 bytes
		# This effectively guarantees our last element
		sll $t0, $a1, 2
		add $t0, $a0, $t0
		lw $t1, -4($t0)

		# add the final value into $v0, basically like $v0 += $t1
		add $v0, $v0, $t1

		jr $ra 

	return_zero:
		add $v0, $zero, $zero	# $v0 = 0
		jr $ra
