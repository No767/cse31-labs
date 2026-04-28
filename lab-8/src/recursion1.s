.data
	# Declare your prompt string here ("Please enter a number: ")
	prompt: .asciiz "Please enter a number: "

.text
main:
    la $a0, prompt
	li $v0, 4 
	syscall
	
    li $v0, 5 
	syscall

	# Move input into $a0, as this will be loaded as our argument
    addu $a0, $zero, $v0

    jal recursion

	# Our final, official return value is in $v0
    # Thus we need to move it to $a0 so it is the correct argument register to print the result
    # In addition, we can assume that $a0 is unused, so it's fine to overwrite it
    addu $a0, $zero, $v0

    li $v0, 1
    syscall
	
    j end


recursion:
    addi $sp, $sp, -12

    sw $ra, 8($sp)
    sw $a0, 4($sp)
    sw $s0, 0($sp)


    # if (m == -1)
    li $t0, -1
	beq $a0, $t0, is_minus_one


    # else if (m <= -2)
    slti $t0, $a0, -1
    beq  $t0, $zero, recursive_case # If false, go to the recursive_case label

    # Flipped logic from original, using "skip if false" logic
    # If $t1 is 0 (m == -2), branch to return_one
    slti $t1, $a0, -2
    beq  $t1, $zero, return_one     

    # Else, return 2
    li $v0, 2
    j end_loop


    is_minus_one:
        li $v0, 3
	    j end_loop

    return_one:
        li $v0, 1
        j end_loop

    # If code reaches here, then it must be that m > -1
    # Within each recursive call, $a0 will be restored as it may be tainted from the other calls
    recursive_case:

        # Call 1: recursion(m - 3)
        lw $a0, 4($sp)
        addi $a0, $a0, -3

        jal recursion

        # Move result from $v0 to $s0
        # This is our "first" call's returned value
        addu $s0, $zero, $v0


	    # Call 2: recursion(m - 2)
        # Note that the "second" call's returned value is in $v0
        # We *could* move it to $s1, but I would rather conserve registers (i.e., what I did in lab 7)
        lw $a0, 4($sp)
        addi $a0, $a0, -2
    
        jal recursion


	    # Final Calculation: recursion(m - 3) + recursion(m - 2) + m
        lw $a0, 4($sp)

        # Note that the final, official return value is in $v0
	    add $v0, $s0, $v0   # $v0 = recursion(m - 3) + recursion(m - 2)
	    add $v0, $v0, $a0   # $v0 = $v0 + m


    end_loop: 
        # We only need to save the following:
        # - $ra: So we can jump back properly, as the recursive calls probably messed up $ra
        # - $s0: It got overwritten as we are doing "m - 3" and "m - 2". Thus, if we didn't restore it, it would use the data used in the recursive calls

        # Note that $a0 is not restored as we are done using it.
        # By the MIPS calling conventions, as $a0 registers are the "Caller-saved registers", i.e., don't bother to trust it
        lw $ra, 8($sp)
        lw $s0, 0($sp)
    
        addi $sp, $sp, 12
        
        jr $ra

end:
    li $v0, 10
    syscall