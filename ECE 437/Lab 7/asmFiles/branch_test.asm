#0x13 BEQ TAKEN
#0x24 BEQ NOT TAKEN
#0x42 BNE TAKEN
#0x69 BNE NOT TAKEN

#$8 BEQ RESULT
#$9 BNE RESULT
org 0x0000

#to store in memory
ori $2, $0, 0x10 #BEQ TAKEN
ori $3, $0, 0x11 #BEQ NOT TAKEN
ori $4, $0, 0x20 #BNE TAKEN
ori $5, $0, 0x21 #BNE NOT TAKEN

#test values
ori $6, $0, 0x2
ori $7, $0, 0x3

#test beq
or $8, $0, $2
beq $6, $7, BEQTAKEN
or $8, $0, $3

BEQTAKEN:

#test bne
or $9, $0, $4
bne $6, $6, BNETAKEN
or $9, $0, $5

BNETAKEN:

sw $8, 8($0)
sw $9, 0($0)

halt
