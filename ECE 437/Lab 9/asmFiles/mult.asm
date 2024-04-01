#$2 first operand
#$3 second operand
#$4 counter
#$5 result

#initialize stack pointer to 0xFFFC
ori $29, $0, 0xFFFC

#push operands
ori $6, $0, 3
ori $7, $0, 4

push $6
push $7

#pop operands to registers
pop $2
pop $3

#reset result reg
and $5, $5, $0

#set $4 as one of the operands to serve as counter
or $4, $2, $0

#loop
l1:
    add $5, $5, $3
    addi $4, $4, -1
    bne $4, $0, l1

#push result to stack
push $5

halt
