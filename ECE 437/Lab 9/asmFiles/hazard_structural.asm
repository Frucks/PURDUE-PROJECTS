org 0x0000

# #check if waiting one cycle for r-type write after load (only hazard if pipeline implementation is wrong, i.e. not taking all 5 cycles for each instruction)
# ori $2, $0, 10
# ori $3, $0, 0
# sw $2, 0($0)
# lw $3, 0($0)
# and $4, $2, $3
# sw $4, 4($0)

#check if can write data to dCache and read from iCache in the same clock cycle
ori $2, $0, 0xbeef
ori $3, $0, 0xdead
sw $2, 4($0)
or $0, $0, $0
or $0, $0, $0
or $3, $0, $0
sw $3, 0($0)

#check if can read data from iCache and dCache in the same clock cycle
lw $4, 4($0)
or $0, $0, $0
or $0, $0, $0
or $4, $0, $0
sw $4, 8($0)

#check if can write and read in same clock cycle
ori $5, $0, 11
or $0, $0, $0
or $0, $0, $0
or $6, $5, $0
sw $6, 12($0)

halt
