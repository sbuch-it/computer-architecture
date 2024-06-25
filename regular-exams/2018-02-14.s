
.data
newline:
.asciz "\n"
.text
.globl main

main:
# t0=7
addi t0, x0, 7

fcvt.s.w fa4, t0# f12=7.0
jal sqrt1# call function
fmv.s fs1, fa0# t0=27
addi t0, x0, 27

fcvt.s.w fa4, t0# f12=27.0
jal sqrt1# call function
fmv.s fs2, fa0# save first result into f21

fmv.s fa0, fs1# print_float service number 2
addi a7,x0,2
ecall# print "\n"

la a0 , newline
addi a7,x0,4
ecall

fmv.s fa0, fs2# print_float service number 2
addi a7,x0,2
ecall# print "\n"

la a0 , newline
addi a7,x0,4
ecall# exit

addi a7,x0,10
ecall

sqrt1:
# associate t9 -> times

fcvt.s.w ft7, x0# f10=0.0
fmv.s ft1, ft7# low=0.0
fmv.s ft5, ft7# sqrt=0.0
fmv.s ft6, ft7# res=0.0
fmv.s ft2, fa4# high=n
fmv.s ft3, fa4# xlow=high=n
fmv.s ft4, ft7# times=1
addi a6, x0, 1# if(n<0)
flt.s a3 ,fa4,ft7
bne a3 , x0, retmeno1# t0=1
addi t0, x0, 1

fcvt.s.w fa3, t0# f11=1.0
iniwhile1:
# while(n<1)
flt.s a3 ,fa4,fa3
beq a3 , x0, endwhile1# t0=100
addi t0, x0, 100

fcvt.s.w ft9, t0# f16=100.0
fmul.s fa4, fa4, ft9# times++
addi a6, a6, 1
j iniwhile1
endwhile1:
# if(n<0)
flt.s a3 ,fa4,ft7
beq a3 , x0, notif1# t0=-1
addi t0, x0, -1
fcvt.s.w ft9, t0# f16=-1.0
fmul.s fa4, ft9, fa4# n=-1*n
notif1:

iniwhile2:
# check if res==n
feq.s a3 ,ft6,fa4
bne a3 , x0, endwhile2# if true skip while
fadd.s ft7, ft2, ft3# t0=2
addi t0, x0, 2

fcvt.s.w ft9, t0# f16=2.0
fdiv.s ft5, ft7, ft9# sqrt=(high+low)/2
fmul.s ft6, ft5, ft5# if(res>n)
fle.s a3 ,ft6,fa4
bne a3 , x0, notifw1# skip high=sqrt
fmv.s ft2, ft5# high=sqrt
j notelseifw1# skip eldeif condition
notifw1:
# if(res<n)
flt.s a3 ,ft6,fa4
beq a3 , x0, notelseifw1# skip low=sqrt
fmv.s ft1, ft5# low=sqrt
notelseifw1:
# check if xlow==low
feq.s a3 ,ft3,ft1
beq a3 , x0, elseifw2# check if xhigh==high
feq.s a3 ,ft4,ft2
beq a3 , x0, elseifw2# skip if
j endwhile2# break
elseifw2:

fmv.s ft3, ft1# xlow=low
fmv.s ft4, ft2# xhigh=high
notifw2:

j iniwhile2
endwhile2:
# i=1
addi t0, x0, 1
iniforw1:

slt t1, t0, a6# i<times ?
beq t1, x0, endforw1# t0=10
addi t0, x0, 10

fcvt.s.w ft9, t0# f16=10.0
fdiv.s ft5, ft5, ft9# i++
addi t0, t0, 1
j iniforw1
endforw1:

fmv.s fa0, ft5# prepare return sqrt
j endsqrt1# skip retmeno1 code below
retmeno1:
# t0=-1
addi t0, x0, -1

fcvt.s.w fa0, t0# f0=-1.0
j endsqrt1
endsqrt1:
ret 
