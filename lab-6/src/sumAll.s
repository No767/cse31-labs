.data
    prompt:     .asciiz "Please enter a number: "
    even_msg:   .asciiz "\nSum of even numbers is: "
    odd_msg:    .asciiz "\nSum of odd numbers is: "

.text
.globl main

main:
    # $s0-7 are registered saved throughout calls of the labels
    # as we are looping, we will need to use these registers
    # $t0-7 only exist within a label, as they are temporary
    li $s0, 0 # even_sum
    li $s1, 0 # odd_sum

loop:
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5
    syscall

    # safekeeping purposes
    move $t0, $v0

    # If $t0 == 0, end loop
    beq $t0, $zero, end_loop

    # div and other operations are banned, so we will find it by brute force
    # move the last bit to the front, which will determine even/odd, so it's exactly 0 or 1 (0 is even, 1 is odd)
    # and move it from the front to the back because of two's complements (1 in the front means negative number, so -2,147,483,648 in 32-bit)
    sll $t1, $t0, 31
    srl $t1, $t1, 31
    
    # if $t1 == 0, increment our $s0 value which is even_sum  
    beq $t1, $zero, is_even

is_odd:
    add $s1, $s1, $t0
    j loop

is_even:
    add $s0, $s0, $t0
    j loop

end_loop:
    li $v0, 4
    la $a0, even_msg
    syscall

    li $v0, 1           
    move $a0, $s0
    syscall

    li $v0, 4
    la $a0, odd_msg
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 10
    syscall