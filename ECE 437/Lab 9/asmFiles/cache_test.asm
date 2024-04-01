org 0x0000

#IHIT AND DHIT SAME CYCLE
ori $10, $0, 2
LOOP1:
    or $0, $0, $0
    or $0, $0, $0
    or $0, $0, $0
    sw $10, 8($0)
    addi $10, $10, -1
    bne $10, $0, LOOP1

#IHIT BEFORE DHIT DURING SW
ori $11, $0, 2
LOOP2:
    or $0, $0, $0
    or $0, $0, $0
    bne $11, $0, END2
    sw $11, 12($0)
    addi $11, $11, -1
    bne $11, $0, LOOP2
END2:
#IHIT BEFORE DHIT DURING LW
ori $12, $0, 2
LOOP3:
    or $0, $0, $0
    or $0, $0, $0
    bne $12, $0, END3
    lw $13, 8($0)
    addi $11, $11, -1
    bne $11, $0, LOOP3
END3:
sw $13, 16($0)

halt
