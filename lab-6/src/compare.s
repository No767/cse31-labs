.data

    n: .word 25

    str1: .asciiz "Less than\n"
    str2: .asciiz "Less than or equal to\n"
    str3: .asciiz "Greater than\n"
    str4: .asciiz "Greater than or equal to\n"

.text

    li $v0, 5 # Command code 5 reads from input, and puts it in $v0
    syscall

    move $t0, $v0 # Move to $t0 so it doesn't get overwritten

    # We need to load these into the registers so we can compute it
    la $t1, n      # get address of n
    lw $t2, 0($t1) # get the value of n

    slt $t3, $t0, $t2 # $t3 becomes 0 if it's invalid
    bne $t3, $zero, is_less_than # $t3 != 0, go to is_less_than

    # if $t3 == 0 (found result), is_greater_or_equal
    beq $t3, $zero, is_greater_or_equal

    # $t3 would become 0 if n > input
    slt $t3, $t2, $t0
    bne $t3, $zero, is_greater_than

    # All branches failed, so input <= n
    beq $t3, $zero, is_less_or_equal


is_greater_than:
    li $v0, 4
    la $a0, str3
    syscall
    j end_compare

is_less_or_equal:
    li $v0, 4
    la $a0, str2
    syscall
    j end_compare

is_less_than:
    li $v0, 4
    la $a0, str1
    syscall
    j end_compare

is_greater_or_equal:
    li $v0, 4
    la $a0, str4
    syscall
    j end_compare

end_compare:
    li $v0, 10
    syscall
