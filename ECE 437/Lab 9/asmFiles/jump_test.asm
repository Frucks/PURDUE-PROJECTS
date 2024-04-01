#initialize stack pointer to 0xFFFC
ori $29, $0, 0xFFFC

ori $2, $0, 0x10 #J TAKEN
ori $3, $0, 0x11 #J NOT TAKEN
ori $4, $0, 0x20 #JAL TAKEN
ori $5, $0, 0x21 #JAL NOT TAKEN
ori $6, $0, 0x30 #JR TAKEN
ori $7, $0, 0x31 #JR NOT TAKEN

#test J
or $8, $0, $2
j JTAKEN
or $8, $0, $3

JTAKEN:

#test JAL
or $9, $0, $4
jal JALTAKEN #$31 = 0x30 (48ten)
or $9, $0, $5 #48

JALTAKEN:

#test JR
or $10, $0, $6 #52
ori $11, $0, 0x44 #56
jr $11 #60
or $10, $0, $7 #64

push $8 #68 = 0x44
push $9
push $10

#sw $8, 0($12)
#sw $9, 0($13)
#sw $10, 0($14)

halt
