org 0x0000

#ADDRESS
ori $6, $0, 0x48 #'b01001000
ori $7, $0, 0x88 #'b10001000
ori $10, $0, 0xC8 #'b11001000
ori $8, $0, 0x0BADBEEF

sw $8, 0($6)
lw $8, 0($7)
#sw $8, 0($6)
lw $9, 0($10)

halt
