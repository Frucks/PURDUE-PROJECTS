#initialize stack pointer to 0xFFFC
and $29, $29, $0
ori $29, $0, 0xFFFC
ori $6, $0, 0xFFF8

#push operands to stack
ori $7, $0, 2
ori $8, $0, 2
ori $9, $0, 2
ori $10, $0, 2
push $7
push $8
push $9
push $10

#mult start
l2:
    jal mul1
    bne $29, $6, l2
halt

#multiply
mul1:
    #reset result reg
    and $5, $5, $0

    #get operands
    pop $2
    pop $3

    #set $4 as one of the operands to serve as counter
    or $4, $2, $0

    #loop
    l1:
        add $5, $5, $3
        addi $4, $4, -1
        bne $4, $0, l1

    #push result to stack
    push $5

    jr $31
