org 0x0000

#EX/MEM.RegisterRd = ID/EX.RegisterRs
ori $2, $0, 10
or $3, $2, $0
sw $3, 4($0) #0xA

#EX/MEM.RegisterRd = ID/EX.RegisterRt
ori $4, $0, 11
or $5, $0, $4
sw $5, 8($0) #0xB

#MEM/WB.RegisterRd = ID/EX.RegisterRs
ori $6, $0, 12
or $0, $0, $0
or $7, $6, $0
sw $7, 12($0) #0xC

#MEM/WB.RegisterRd = ID/EX.RegisterRt
ori $8, $0, 13
or $0, $0, $0
or $9, $0, $8
sw $9, 16($0) #0xD

#EM/WB.RegisterRd = EX/MEM.RegisterRd = ID/EX.RegisterRs
or $10, $0, $0
add $10, $10, $2
add $10, $10, $2
add $10, $10, $2
sw $10, 20($0) #0x1E

#EM/WB.RegisterRd = EX/MEM.RegisterRd = ID/EX.RegisterRt
or $11, $0, $0
add $11, $11, $2
add $11, $11, $2
add $11, $4, $11
sw $11, 24($0) #0x1F

#load use
lw $12, 4($0)
addi $13, $12, 0x20
sw $13, 28($0) #0x2A

#RAW->RAR->WAR->WAW
ori $14, $0, 0x2B
sw $14, 32($0)
lw $14, 8($0)
lw $15, 12($0)
sw $15, 36($0)
sw $14, 40($0) #0x80

#TEST JR FORWARDING
#FROM ID/EX
ori $16, $16, 0x90 #0x84
jr $16 #0x88
sw $16, 44($0) #0x8C
sw $16, 48($0) #0x90

#FROM EX/MEM
ori $17, $17, 0xA4 #0x94
or $0, $0, $0 #0x98
jr $17 #0x9C
sw $17, 52($0) #0xA0
sw $17, 56($0) #0xA4

#FROM MEM/WB
ori $18, $18, 0xBC #0xA8
or $0, $0, $0 #0xAC
or $0, $0, $0 #0xB0
jr $18 #0xB4
sw $18, 52($0) #0xB8
sw $18, 56($0) #0xBC

#JR AFTER JAL AT ID
ori $19, $0, 0xABBA
jal JAL1
sw $19, 60($0)

#JR AFTER JAL AT EX
ori $20, $0, 0xBAAB
jal JAL2
sw $20, 64($0)

#JR AFTER JAL AT MEM
ori $21, $0, 0xBABA
or $0, $0, $0
or $0, $0, $0
jal JAL3
sw $21, 68($0)

#JAL SPAM
jal JAL1
jal JAL1
jal JAL1

halt

JAL1:
    jr $31
    halt

JAL2:
    or $0, $0, $0
    jr $31
    halt

JAL3:
    or $0, $0, $0
    or $0, $0, $0
    jr $31
    halt
