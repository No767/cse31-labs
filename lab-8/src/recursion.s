.data

# TPS 2 #3 (input prompt to be displayed)

str1: .asciiz "Please enter a num: "

.text
main: 	addi $sp, $sp, -4	# Moving stack pointer to make room for storing local variables (push the stack frame)
	# TPS 2 #3 (display input prompt)

	la $a0, str1
	li $v0, 4 
	syscall 

	move $s1, $sp
	
	# TPS 2 #4 (read user input)

	li $v0, 5
	syscall

	addu $a0, $zero, $v0

		
	jal recursion	# Call recursion(x)
	
	# TPS 2 #6 (print out returned value)

	# our "29" is sitting in $v0, so move before we reuse $v0
	addu $a0, $zero, $v0
    li $v0, 1
    syscall
	
	j end		# Jump to end of program


# Implementing recursion
recursion: addi $sp, $sp, -12	# Push stack frame for local storage

	# TPS 2 #7 

	sw   $ra, 8($sp)    # Save Return Address
	sw   $a0, 4($sp)    # Save original argument (m)
	sw   $s0, 0($sp)    # Save old $s0 value
			
	
	addi $t0, $a0, 1
	bne $t0, $zero, not_minus_one
	
	# TPS 2 #8 (update returned value)
	
	li $v0, 1
	j end_recur
		
not_minus_one:	bne $a0, $zero, not_zero
	# TPS 2 #9 (update returned value)
	
	li $v0, 3
	j end_recur		

not_zero: sw $a0, 4($sp) 	
	# TPS 2 #11 (Prepare new input argument, i.e. m - 2)
	addi $a0, $a0, -2
	
	
	jal recursion	# Call recursion(m - 2)
	
	# TPS 2 #12 
	
	addu $s0, $zero, $v0
		
	# TPS 2 #13 (Prepare new input argument, i.e. m - 1)

	# Get our original "m" value so we can do the calculation properly
	lw   $a0, 4($sp)
	addi $a0, $a0, -1
	
	jal recursion	# Call recursion(m - 1)
	
	# TPS 2 #14 (update returned value)
	
	addu $v0, $s0, $v0    # Add the two answers together and store the final sum in $v0
	
	j end_recur
		

# End of recursion function	
end_recur: # TPS 2 #15 
	# Get the original $ra value
	lw $ra, 8($sp)
	lw $s0, 0($sp)

	addi $sp, $sp, 12	# Pop stack frame 
	jr $ra

# Terminating the program
end:	addi $sp, $sp 4	# Moving stack pointer back (pop the stack frame)
	li $v0, 10 
	syscall
