#$2 operand 1
#$3 operand 2
#$4 counter
#$5 result of multiply
#$6 current day
#$7 current month
#$8 current year
#$9 month - 1
#$10 year - 2000
#$11 30
#$12 365
#$13 30 * (month - 1)
#$14 365 * (year - 2000)
#$15 final result

#initialize stack pointer to 0xFFFC
ori $29, $0, 0xFFFC

#set variables
ori $6, $0, 22 #day
ori $7, $0, 8 #month
ori $8, $0, 2023 #year

#calculate 365 * (year - 2000)
addi $10, $8, -2000
#set immediate
ori $12, $0, 365
#push operands to stack
push $12
push $10
#multiply and set result to $14
jal mul1
pop $14

#calculate 30 * (month - 1)
addi $9, $7, -1
#set immediate
ori $11, $0, 30
#push operands to stack
push $11
push $9
#multiply and set result to $13
jal mul1
pop $13

#calculate day + 30 * (month - 1) + 365 * (year - 2000)
add $15, $6, $13
add $15, $15, $14

#halt
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
