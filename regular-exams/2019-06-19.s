
.data
q: .float 0.6931472, 0.9333737, 0.9888778, 0.9984959, 0.9998293, 0.9999833, 0.9999986, 0.9999999
mz:   .word 11111
cf1:  .float 1.0
c970: .word 970000
spa:   .asciz " "
cf232: .float 2.3283062e-10
c31883: .word 31883
c65535: .word 65535

.globl main
.text
#-----------------------------------

rnd:
# &cf232
la t2, cf232# &c31883
la t3, c31883# &c65535
la t4, c65535# &mz
la t5, mz
flw fa0, 0(t2)# 2.32...
lw t6, 0(t3)# 31883
lw a4, 0(t4)# 65535
lw a6, 0(t5)# mz
and a5, a6, a4# ()*31883
mul a5, a5,t6
srli a6,a6, 16# mz>>16
add a6, a6, a5# ()+() ex addu
sw a6, 0(t5)# update mz
#fmv.s.x ft1, a6# mz into c1
fcvt.s.w ft1, a6# &cf1
la t5, cf1
flw ft3, 0(t5)# 1.0
fadd.s ft1, ft1, ft3# 1.0+mz
fmul.s fa0, ft1, fa0# result
jr ra

#-----------------------------------
# f12=avg, s0=i,
# f20=a,f22=u,f24=umin,f26=ustar
# f28=1.0

gexp:
#-----------------------------------
# PROLOGO
#alloco frame
addi sp, sp, -32
sw ra, 28(sp)#salvo old-ra
sw s0, 24(sp)#salvo old-fp
sw s0, 20(sp)#salvo s0
fsw fs1, 16(sp)#salvo f20
fsw fs3, 12(sp)#salvo f22
fsw fs5, 8(sp)#salvo f24
fsw fs7, 4(sp)#salvo f26
fsw fs9, 0(sp)#salvo f28
add s0, x0, sp# &cf1
la t1, cf1
flw fs9, 0(t1)# f28=1.0
fmv.s.x fs1, x0# a=0.0
jal rnd# f0=rnd()
fmv.s fs3, fa0# &q
la t0, q
flw ft1, 0(t0)# q[0]

for1ini:
fadd.s fs3, fs3, fs3# 1.0<u
flt.s a3 ,fs9,fs3
bne a3 , x0, for1break
fadd.s fs1, fs1, ft1# a=a+(.)
j for1ini

for1break:
fsub.s fs3, fs3, fs9# u<=?q[0]
fle.s a3 ,fs3,ft1
beq a3 , x0, fineif2
fadd.s fa0, fs1, fs3# a+u
fdiv.s fa0, fa0, fa4# (.)/avg
j gexp_epilogo

fineif2:
add s0, x0, x0# i=0
jal rnd
fmv.s fs7, fa0# ustar=rnd()
fmv.s fs5, fs7# umin=ustar

for2ini:
jal rnd
fmv.s fs7, fa0# ustar<?umin
flt.s a3 ,fs7,fs5
beq a3 , x0, fineif3
fmv.s fs5, fs7# umin=ustar
fineif3:

add t0, s0, s0
add t0, t0, t0# &q
la t1, q
add t1, t1, t0# &q[i]
flw ft1, 0(t1)# q[i]<?u
flt.s a3 ,ft1,fs3
beq a3 , x0, for2end# ++i
addi s0, s0, 1
j for2ini

for2end:
# &q
la t0, q
flw ft1, 0(t0)# q[0]
fmul.s fa0, fs5, ft1# umin*q[0]
fadd.s fa0, fs1, fs3# a+(.)
fdiv.s fa0, fa0, fa4#-----------------------------------
# EPILOGO

gexp_epilogo:
lw ra, 28(sp)#riprist. old-ra
lw s0, 24(sp)#riprist. old-fp
lw s0, 20(sp)#riprist. s0
flw fs1, 16(sp)#riprist. f20
flw fs3, 12(sp)#riprist. f22
flw fs5, 8(sp)#riprist. f24
flw fs7, 4(sp)#riprist. f26
flw fs7, 4(sp)#dealloco frame
addi sp, sp, 32
jr ra#-----------------------------------

main:
add s0, x0, x0# &cf1
la t1, cf1# &c970
la t2, c970
flw fs1, 0(t1)# f20=1.0
lw s3, 0(t2)# s4=10
addi s4, x0, 10

main_forini:
slt a6, s0, s4# n<?10
beq a6, x0, main_forend
#fmv.s.x ft1, s3# 970000
fcvt.s.w ft3, s3# 970000.0
fdiv.s fa4, fs1, ft3#1.0/970000.0
jal gexp# result in f0

#fmv.s fa0, fa4# serv.2
addi a7,x0,2
ecall# &sp

la a0 , spa# serv.4
addi a7,x0,4
ecall# n++
addi s0, s0, 1
j main_forini

main_forend:
# serv.10
addi a7,x0,10
ecall