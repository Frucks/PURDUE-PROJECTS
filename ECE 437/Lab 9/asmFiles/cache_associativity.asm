org 0x0000

#DATA
ori $2, $0, 0xbeef
ori $3, $0, 0xdead
ori $4, $0, 0xdada
ori $5, $0, 0xbebe

#ADDRESS
ori $6, $0, 0x48 #'b01001000
ori $7, $0, 0x88 #'b10001000

#ASSOCIATIVITY CHECK
sw $2, 0($6)
sw $3, 0($7)

lw $8, 0($6)
lw $9, 0($7)

sw $8, 500($0)
sw $9, 504($0)

halt
