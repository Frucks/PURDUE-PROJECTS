org 0x0000

ori $2, $0, 10 #BEQ CORRECT
ori $3, $0, 11 #BEQ NOT CORRECT
ori $4, $0, 12 #BNE CORRECT
ori $5, $0, 13 #BNE NOT CORRECT
ori $10, $0, 26 #J CORRECT
ori $11, $0, 27 #J NOT CORRECT
ori $12, $0, 28 #JAL CORRECT
ori $13, $0, 29 #JAL NOT CORRECT
ori $14, $0, 30 #JR CORRECT
ori $15, $0, 31 #JR NOT CORRECT

#TEST TAKING BEQ
or $6, $0, $2
beq $2, $2, BEQ1
or $6, $0, $3

BEQ1:

#TEST NOT TAKING BEQ
or $7, $0, $3
beq $2, $3, BEQ2
or $7, $0, $2

BEQ2:

#TEST TAKING BNE
or $8, $0, $4
bne $2, $3, BNE1
or $8, $0, $5

BNE1:

#TEST NOT TAKING BNE
or $9, $0, $5
bne $2, $2, BNE2
or $9, $0, $4

BNE2:

sw $6, 4($0)
sw $7, 8($0)
sw $8, 12($0)
sw $9, 16($0)

#TEST JUMP
or $16, $0, $10
j JTAKEN
or $16, $0, $11

JTAKEN:

#TEST JAL
or $17, $0, $12
jal JALTAKEN
or $17, $0, $13

JALTAKEN:

#TEST JR
or $18, $0, $14
ori $19, $0, 144
jr $19
or $18, $0, $15

sw $16, 20($0)
sw $17, 24($0)
sw $18, 28($0)

#test jump after branch
ori $19, $0, 0xbeef
beq $0, $0, BEQ3
ori $19, $0, 0xdead

BEQ3:
    j JUMP1
ori $19, $0, 0xabba

JUMP1:
ori $19, $0, 0xbaba
sw $19, 32($0)

halt
