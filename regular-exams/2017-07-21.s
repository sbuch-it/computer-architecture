
#esame 21-07-2017 esercizio 1 MIPS
.data
count:
.word 0
vals:
.word 12, 56, 45, 78, 2, 6, 5, 8, 0, 0, 0, 0
spc2:
.asciz " "
nl1:
.asciz "\n"
ii:
.word 0
jj:
.word 0
kk:
.word 0
.text
.globl main
#-------------------------------------------------------

multiply:
# allocate frame,...
addi sp, sp, -36
sw a3, 32(sp)
sw a2, 28(sp)
sw a1, 24(sp)
sw a0 , 20(sp)
sw s0, 16(sp)# save old-fp
sw ra, 12(sp)# save old-ra
sw s6, 8(sp)# used for 7th parm
sw s5, 4(sp)# used for 6th parm
sw s4, 0(sp)# used for 5th parm

lw s4, 36(sp)# load 5th parm
lw s5, 40(sp)# load 6th parm
lw s6, 44(sp)# &i
la t0, ii
lw t6, 0(t0)# i
slt a6, t6, a0# i<?m1: else1
bne a6, x0, else1
j endif1
else1:

slt a6, t6, a0# i<?m1: if not endif1
beq a6, x0, endif1# &j
la t0, jj
lw a4, 0(t0)# j
slt a6, a4, s4# j<?n2: if not endif2
beq a6, x0, endif2# &k
la t0, kk
lw a5, 0(t0)# k
slt a6, a5, a1# k<?n1: if not endif3
beq a6, x0, endif3# a[i][k] ...
add t0, t6, t6# 2*i
add t0, t0, a5# 2*i+k
slli t0,t0, 2# 4*(2*i+k)
add t0, t0, a2# &a+4*(2*i+k)
lw t1, 0(t0)# b[k][j] ...
add t0, a5, a5# 2*k
add t0, t0, a4# 2*k+j
slli t0,t0, 2# 4*(2*k+j)
add t0, t0, s5# &b+4*(2*k+j)
lw t2, 0(t0)# c[i][j] ...
add t0, t6, t6# 2*i
add t0, t0, a4# 2*i+j
slli t0,t0, 2# 4*(2*i+j)
add t0, t0, s6# &c+4*(2*i+j)
lw t3, 0(t0)# a[][]*b[][]
mul t1, t1, t2
add t3, t3, t1# a[][]*b[][]+c[][]
sw t3, 0(t0)# k++
addi a5, a5, 1# &k
la t0, kk
sw a5, 0(t0)# push extra params
addi sp, sp, -12
sw s6, 8(sp)
sw s5, 4(sp)
sw s4, 0(sp)
jal multiply
addi sp, sp, 12
endif3:
# &k
la t0, kk
sw x0, 0(t0)# &j
la t0, jj
lw t1, 0(t0)# j++
addi t1, t1, 1
sw t1, 0(t0)# push extra params
addi sp, sp, -12
sw s6, 8(sp)
sw s5, 4(sp)
sw s4, 0(sp)
jal multiply
addi sp, sp, 12
endif2:
# &j
la t0, jj
sw x0, 0(t0)# &i
la t0, ii
lw t1, 0(t0)# i++
addi t1, t1, 1
sw t1, 0(t0)# push extra params
addi sp, sp, -12
sw s6, 8(sp)
sw s5, 4(sp)
sw s4, 0(sp)
jal multiply
addi sp, sp, 12
endif1:

lw s4, 0(sp)
lw s5, 4(sp)
lw s6, 8(sp)
lw ra, 12(sp)
lw s0, 16(sp)
lw a0 , 20(sp)
lw a1, 24(sp)
lw a2, 28(sp)
lw a3, 32(s0)
addi sp, sp, 36
ret #-------------------------------------------------------

display:
# allocate frame,save-s0,save-s1,a2
addi sp, sp, -28
sw a2, 24(sp)# save a2
sw a1, 20(sp)# save a1
sw a0 , 16(sp)# save a0
sw s0, 12(sp)# save old-fp
sw ra, 8(sp)# save old-ra
sw s1, 4(sp)# save s1
sw s2, 0(sp)# save s2
add s0, sp, x0# i=0
addi s2, x0, 0
fori1:

slt a6, s2, a0# i<?m1: if not endfori
beq a6, x0, endfori1# j=0
addi s1, x0, 0
forj1:

slt a6, s1, a1# j<?n2: if not endforj
beq a6, x0, endforj1#----- forj1 body start
slli t2,s2, 1# i*2
add t2, t2, s1# i*2+j
slli t2,t2, 2# 4*(i*2+j)
add t2, a2, t2# &c+4*(i*2+j)

lw a0 , 0(t2)# service-1: print_int
addi a7,x0,1
ecall# pointer to the string

la a0 , spc2# service-4: print_str
addi a7,x0,4
ecall#----- forj1 body end

nextforj1:
# ++j
addi s1, s1, 1
lw a1, 20(sp)# restore a1
j forj1
endforj1:
# i++
addi s2, s2, 1# print just 1 newline

la a0 , nl1# print_str
addi a7,x0,4
ecall

lw a0 , 16(sp)# restore a0
j fori1
endfori1:

addi sp, sp, 28
lw s2, 0(sp)# restore s2
lw s1, 4(sp)# restore s1
lw ra, 8(s0)# restore ra
lw s0, 12(s0)# restore fp
jr ra#-------------------------------------------------------

main:
# allocate "int x[2][2], y... z..."
addi sp, sp, -48
add s0, sp, x0# initialize x,y,z
la t0, vals
add t1, s0, x0# pointer to x[0][0]
addi t2, t0, 48
loop1:

lw t3, 0(t0)# load val
sw t3, 0(t1)# increment pointers
addi t1, t1, 4#
addi t0, t0, 4
bne t0, t2, loop1# m1
addi a0 , x0, 2# n1
addi a1, x0, 2
add a2, s0, x0# n1
addi a3, x0, 2# allocate space for extra parms
addi sp, sp, -12# &z
addi t0, s0, 32
sw t0, 8(sp)# &y
addi t0, s0, 16
sw t0, 4(sp)# store 6th parm
sw a3, 0(sp)# store the 5th parm
jal multiply# restore stack pointer for parms
addi sp, sp, 12# m1
addi a0 , x0, 2# n2
addi a1, x0, 2# &z
addi a2, s0, 32
jal display# deallocate "x, y, z"
addi sp, sp, 48# service 10: exit

addi a7,x0,10
ecall