org 0x0000

#ADDRESS
ori $2, $0, 0x48 #'b01001000
ori $3, $0, 0x88 #'b10001000
ori $4, $0, 0x14C #'b101001100
ori $5, $0, 0x1CC #'b111001100

#DATA
ori $6, $0, 0x0BADBEEF
ori $7, $0, 0x0DEADBEEF
ori $8, $0, 0x0BEEFBAD
ori $9, $0, 0x0DEADBAD


sw $6, 0($2)
sw $7, 0($3)
sw $8, 0($4)
sw $9, 0($5)


halt
