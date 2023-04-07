
.data
SPC:
.asciz " "
RTN:
.asciz " "
ID:
.word 7, 5, 4, 3, 1, 0, 2, 6
COUNT:
.word 0
HW:
.space 4
HG:
.space 1024
PX:
.space 1024
.globl main
.text#-------------------------------------

getid:
# &COUNT
la t0, COUNT
lw t1, 0(t0)# COUNT++
addi t2, t1, 1
sw t2, 0(t0)# store in mem.
slli t1,t1, 2# &ID
la t0, ID
add t0, t0, t1# &ID[COUNT]
lw a0, 0(t0)# ID[COUNT]
ret
#-------------------------------------
# a3=histogram,a1=pixel,a2=size

comph:
# alloco frame
addi sp, sp, -4
sw ra, 0(sp)# salvo OLD-ra
jal getid# a0=tid
add t0, x0, x0# t1=8
addi t1, x0, 8# size/8
div t2, a2, t1# tid*size/8
mul t3, a0, t2# t8=&HW
la a5, HW
lw a5, 0(a5)# t8=HW
comph_forini1:

slt a6, t0, t2# i<?size/8
beq a6, x0, comph_forend1
add a4, t3, t0# (.)+i
add a4, a4, a1# pixel+(.)
lb t4, 0(a4)# HG_BIN_COUNT
addi a4, x0, 256# tid*(.)
mul t5, a0, a4
add t5, t5, t4# (.)+pixel[.]
slli t5,t5, 2# (.)*4
add t5, t5, a5# &HW+(.)
lw t6, 0(t5)# ++
addi t6, t6, 1
sw t6, 0(t5)# ++i
addi t0, t0, 1
j comph_forini1
comph_forend1:

lw ra, 0(sp)# DEALLOCO FRAME
addi sp, sp, 4
ret 
#-------------------------------------
# a3=hist

preph:

add t0, x0, x0# t0=i=0
preph_forini1:
# i<?256
slti a6, t0, 256
beq a6, x0, preph_forend1
slli t1,t0, 2# i*4
add t1, t1, a3# &hist+i
sw x0, 0(t1)# ++i
addi t0, t0, 1
j preph_forini1
preph_forend1:
# &PX
la t2, PX
add t0, x0, x0# t0=i=0
preph_forini2:
# i<?1024
slti a6, t0, 1024
beq a6, x0, preph_forend2# 256
addi t1, t1, 256
rem t1, t0, t1# i % 256
add t3, t2, t0# &PX+i
sb t1, 0(t3)# ++i
addi t0, t0, 1
j preph_forini2
preph_forend2:
# HG_BIN_COUNT
addi t0, x0, 256# NW
addi t1, x0, 8
mul t1, t0, t1# HG_BIN_COUNT*NW

slli a0 ,t1, 3# serv. 9
addi a7,x0,9
ecall# malloc

la a5, HW
sw a0, 0(a5)# HW=(.)
add t0, x0, x0# t0=i=0
preph_forini3:

slt a6, t0, t1#i<?HG_BIN_COUNT*NW
beq a6, x0, preph_forend3
slli t2,t0, 2# i*4
add t3, a0, t2# &HW+(.)
sw x0, 0(t3)# ++i
addi t0, t0, 1
j preph_forini3
preph_forend3:

ret 
#-------------------------------------

main:
#-------------------------------------
# PROLOGO
# alloco frame
addi sp, sp, -20
sw ra, 16(sp)# salvo OLD-ra
sw s0, 12(sp)# salvo OLD-fp
add s0, x0, sp# NUOVO fp
sw s2, 8(s0)# salvo s2
sw s1, 4(s0)# salvo s1
sw s3, 0(s0)# histogram = &HG
la s3, HG# pixel = &PX
la s1, PX
add a3 , x0, s3# a3=histogram
jal preph
add s2, x0, x0# s2=t=0
main_forini1:
# i<?8
slti a6, s2, 8
beq a6, x0, main_forend1
add a3 , x0, s3# histogram
add a1, x0, s1# PX_IMGSIZE
addi a2, x0, 1024
jal comph# ++t
addi s2, s2, 1
j main_forini1
main_forend1:
# &HW
la a5, HW
lw a5, 0(a5)# HW
add t0, x0, x0# t0=i=0
main_forini2:
# i<?256
slti a6, t0, 256
beq a6, x0, main_forend2
add t1, x0, x0# t1=t=0
main_forini3:
# i<?8
slti a6, t1, 8
beq a6, x0, main_forend3# 256
addi t2, x0, 256# t*256
mul t2, t1, t2
add t2, t2, t0# (.)+i
slli t2,t2, 2# (.)*4
add t2, t2, a5# (.)+&HW
lw t3, 0(t2)# HW[.]
slli t4,t0, 2# i*4
add t4, t4, s3# &histogram[i]
lw t5, 0(t4)# histogram[i]
add t5, t5, t3# +=
sw t5, 0(t4)# ++t
addi t1, t1, 1
j main_forini3
main_forend3:
# ++i
addi t0, t0, 1
j main_forini2
main_forend2:

add t0, x0, x0# t0=i=0
main_forini4:
# i<?256
slti a6, t0, 256
beq a6, x0, main_forend4# space string

la a0 , SPC# serv.4
addi a7,x0,4
ecall

slli t1,t0, 2# i*4
add t1, t1, s3# &histogram[i]

lw a0 , 0(t1)# serv.1
addi a7,x0,1
ecall# ++i

addi t0, t0, 1
j main_forini4
main_forend4:
#-------------------------------------
# EPILOGO

lw s3, 0(s0)# ripristina s0
lw s1, 4(s0)# ripristina s1
lw s2, 8(s0)# ripristina s2
lw ra, 16(s0)# RIPRISTINA ra
lw s0, 12(s0)# DEALLOCO FRAME
addi sp, sp, 20# serv.10

addi a7,x0,10
ecall