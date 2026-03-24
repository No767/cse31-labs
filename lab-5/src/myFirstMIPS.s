.text
    move $t0, $s0  

    # No subi instruction because of optimization reasons
    # instead add a negative sign (-28), which does the same thing
    # Two's complements is used here, which means that it would work
    addi $t1, $t0, -7       

    add $t2, $t1, $t0       

    addi $t3, $t2, 2        

    add $t4, $t3, $t2       

    addi $t5, $t4, -28      

    sub $t6, $t4, $t5       

    addi $t7, $t6, 12      

    # Exit program
    li $v0, 10
    syscall
