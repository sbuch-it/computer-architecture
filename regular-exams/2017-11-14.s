
.data
A:
.float 10.0, 1.0, 2.0
.float 1.0, 20.0, 3.0
.float 2.0, 3.0, 30.0
uno:
.float 1.0
paropen:
.asciz "["
parclose:
.asciz "]=\n"
newline:
.asciz "\n"
spc:
.asciz " "
namer:
.asciz "R"
namex:
.asciz "X"
.text
.globl main

main:
# col valore di ritorno della f. cholesky
la a0 , namex
la a1, A
addi a2, x0, 9
jal printmat
la a0 , A
addi a1, x0, 3
jal cholesky

la a0 , namer
add a1, x0, a3
addi a2, x0, 9
jal printmat

addi a7,x0,10
ecall

printmat:
# stampa 'name' che e' in a0

addi a7,x0,4
ecall
la a0 , paropen
addi a7,x0,4
ecall# stampa parentesi aperta

add a0 , x0, a2
addi a7,x0,1
ecall# stampa m

la a0 , parclose
addi a7,x0,4
ecall# stampa parentesi chiusa

add t0, x0, x0# i=0
pmfor:

slt t1, t0, a2# i<?m
beq t1, x0, pmfinefor
slli t1,t0, 2# i*4
add a0 , a1, t1# &X+i*4

flw fa0, 0(a0 )# X[i]
addi a7,x0,2
ecall# stampa X[i]

la a0 , spc
addi a7,x0,4
ecall# ++i
addi t0, t0, 1
j pmfor
pmfinefor:

la a0 , newline
addi a7,x0,4
ecall# stampa parentesi aperta
ret

mysqrt:
#
fmv.x.s t0, fa4
srai t0,t0, 1# vint>>1
addi t1, x0, 1
slli t1,t1, 29
add t0, t0, t1
addi t1, x0, 1
slli t1,t1, 22
sub t0, t0, t1
fmv.s.x fa4, t0
ret
cholesky:
#____________________Totale 8B
addi sp, sp, -24
sw ra, 0(sp)
sw s0, 4(sp)
sw s1, 8(sp)
sw s2, 12(sp)
sw s3, 16(sp)
sw s4, 20(sp)
add s0, x0, a0# n*n
mul a0 , a1, a1

slli a0 ,a0 , 2# sbrk, a0=&L
addi a7,x0,9
ecall
add a3, a0,x0
add s1, x0, x0# j=0
for1:

slt a6, s1, a1# j<?n
beq a6, x0, finef1
fmv.s.x fa0, x0# s=0.0
add s2, x0, x0# k=0
for2:

slt a6, s2, s1# k<?j
beq a6, x0, finef2
mul a5, s1, a1
add a5, a5, s2# j*n+k
slli a5,a5, 2# (j*n+k)*4
add a5, a0, a5# &L[j,k]
flw fa2, 0(a5)# L[j,k]
fmul.s fa1, fa2, fa2# L*L
fadd.s fa0, fa0, fa1# ++k
addi s2, s2, 1
j for2
finef2:

mul s4, s1, a1
add s4, s4, s1# j*n+j
slli s4,s4, 2# (j*n+j)*4
add a5, s0, s4# &A[j,j]
flw fa1, 0(a5)# A[j,j]
fsub.s fa4, fa1, fa0# A[]-s
jal mysqrt
add a5, a0, s4# &L[j,j]
fsw fa4, 0(a5)# i=j+i
addi s3, s2, 1
for3:

slt a6, s3, a1# i<?n
beq a6, x0, finef3
fmv.s.x fa0, x0# s=0.0
add s2, x0, x0# k=0
for4:

slt a6, s2, s1# k<?j
beq a6, x0, finef4
mul a5, s3, a1
add a5, a5, s2# i*n+k
slli a5,a5, 2# (i*n+k)*4
add a5, a0, a5# &L[i,k]
flw ft0, 0(a5)# L[i,k]
mul a5, s1, a1
add a5, a5, s2# j*n+k
slli a5,a5, 2# (j*n+k)*4
add a5, a0, a5# &L[j,k]
flw ft1, 0(a5)# L[j,k]
fmul.s fa1, ft0, ft1# L[i,k]*L[j,k]
fadd.s fa0, fa0, fa1# ++k
addi s2, s2, 1
j for4
finef4:
# 1.0
la a5, uno
flw ft7, 0(a5)
fdiv.s ft2, ft7, fa4# 1.0 / L[j,j]
mul s4, s3, a1
add s4, s4, s1# i*n+j
slli s4,s4, 2# (i*n+j)*4
add a4, s0, s4# &A[i,j]
flw fa1, 0(a4)# A[i,j]
fsub.s ft3, fa1, fa0# A[]-s
mul a5, s1, a1
add a5, a5, s2# j*n+k
slli a5,a5, 2# (j*n+k)*4
add a5, a0, a5# &L[j,k]
flw ft0, 0(a5)# L[j,k]
fmul.s ft4, ft2, ft3# 1/L[]*(A[]-s)
add a5, a0, s4# &L[i,j]
fsw ft4, 0(a5)# ++i
addi s3, s3, 1
j for3
finef3:
# ++j
addi s1, s1, 1
j for1
finef1:
# a0 already contains &L
lw s4, 20(sp)
lw s3, 16(sp)
lw s2, 12(sp)
lw s1, 8(sp)
lw s0, 4(sp)
lw ra, 0(sp)
addi sp, sp, 24
ret