#initialize stack pointer to 0xFFFC
org   0x0000
# ori $29, $0, 0xFFFC

ori $2, $0, 0x10 #HALT STOPPED
ori $3, $0, 0x11 #HALT DIDN'T STOP

ori $5, $0, 0x8
ori $6, $0, 0xC

#test halt
or $4, $0, $2
# push $4
sw $4, 0($5)

halt

or $4, $0, $3
sw $4, 0($6)
