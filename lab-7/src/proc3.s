.data
    x:	.word 2
    y:	.word 4
    z:  .word 6

    str1: .asciiz "p + q: "
    newline: .asciiz "\n"
.text

MAIN:

    la $t0, x
	lw $s0, 0($t0)		# s0 = x
	la $t0, y
	lw $s1, 0($t0)		# s1 = y
    la $t0, z
    lw $s2, 0($t0)      # s2 = z

    # prepare our arguments
    # $a0 - x
    # $a1 - y
    # $a2 - z
    addu $a0, $zero, $s0
    addu $a1, $zero, $s1
    addu $a2, $zero, $s2

    jal FOO

    addu $t0, $s0, $s1 # $t0 = (x + y)
    addu $t0, $t0, $s2 # $t0 = $t0 + z
    addu $s2, $t0, $v0 # z = $t0 + output of foo ($v0)

    addu $a0, $zero, $s2
    
    li $v0, 1
    syscall
    
    la $a0, newline
    li $v0, 4
    syscall
    
    j END

FOO:
    # Will need to set up stack
    # Need $ra, $s0-$s1, and the arguments of m, n, o
    # Note that I am explicitly putting the arguments into the stack, but using $t0-$t3 to conserve as much registers as possible

    # 24 bytes total needed
    addi $sp, $sp, -24
    sw $ra, 20($sp)
    sw $s0, 16($sp)
    sw $s1, 12($sp)

    # Arguments into the stack for "safekeeping"
    sw $a0, 8($sp)
    sw $a1, 4($sp)
    sw $a2, 0($sp)

    # Now, as I am conserving registers, we need to load the values from the stack into $t0-$t2
    lw $t0, 8($sp) # m
    lw $t1, 4($sp) # n
    lw $t2, 0($sp) # o

    # Calculate the arguments
    addu $a0, $t0, $t2
    addu $a1, $t1, $t2
    addu $a2, $t0, $t1

    jal BAR

    # Move the first output into $s0, as it will be overridden
    addu $s0, $zero, $v0

    # In the label BAR, it might have done something
    # we need to reload $t0-$t2 up again from the stack
    lw $t0, 8($sp) # m
    lw $t1, 4($sp) # n
    lw $t2, 0($sp) # o

    # Calculate arguments again
    subu $a0, $t0, $t2
    subu $a1, $t1, $t0
    addu $a2, $t1, $t1

    jal BAR

    # Move to $s1
    addu $s1, $zero, $v0

    # At this point, we don't need $t0 because it's already used for the arguments
    # We saved $v1 into $s1, so just add them up for the final total
    addu $t0, $s0, $s1

    la $a0, str1
    li $v0, 4
    syscall

    # Move calculated value into $a0 so we can print it out
    addu $a0, $zero, $t0
    li $v0, 1
    syscall

    la $a0, newline
    li $v0, 4
    syscall

    # Set final value for MAIN to receive
    addu $v0, $zero, $t0

    # We only need to restore our primary protected values
    # $a0-$a2 are not needed as we are using $t0-$t2 instead
    lw $s1, 12($sp)
    lw $s0, 16($sp)
    lw $ra, 20($sp)
    addi $sp, $sp, 24
    
    jr $ra

BAR:
    # See that we are using $t0 here again. This is why we needed to reload it
    subu $t0, $a1, $a0 # $t0 = (b - a)
    
    sllv $v0, $t0, $a2 # $v0 = (b - a) << c

    jr $ra


END:
    li $v0, 10
    syscall
    
    