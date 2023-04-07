
.text
.globl main

idamax:
#______NO_CALL_FRAME______
# dmax in f4
# i in t0, ix in t1, itemp in t2
#t4=1

addi t4, x0, 1#retval=-1
addi a0, x0, -1#n<?1
slti t5, a3 , 1
bne t5, x0, idamax_ret
add a0, x0, x0#retval=0
beq a3 , t4, idamax_ret#n==?1
beq a2, t4, idamax_else1#ix=1
addi t1, x0, 1
flw ft2, 0(a1)#dx[0]
fabs.s ft1, ft2#dmax=fabs()
add t1, t1, a2#i=1
addi t0, x0, 1
idamax_forini1:

slt t5, t0, a3#i<?n
beq t5, x0, idamax_forend1
slli t5,t1, 2#ix*4
add t5, t5, a1#&dx[ix]
flw ft2, 0(t5)#dx[ix]
fabs.s ft3, ft2#dmax<?()
flt.s a4 ,ft1,ft3
beq a4 , x0, idamax_if1end
add t2, x0, t0#itemp=i
fmv.s ft1, ft3#dmax=()
idamax_if1end:

add t1, t1, a2#i++
addi t0, t0, 1
j idamax_forini1
idamax_forend1:

j idamax_ifend1
idamax_else1:
#itemp=1
addi t2, x0, 1
flw ft2, 0(a1)#dx[0]
fabs.s ft1, ft2#dmax=fabs()
add t1, t1, a2#i=1
addi t0, x0, 1
idamax_forini2:

slt t5, t0, a3#i<?n
beq t5, x0, idamax_forend2
slli t5,t0, 2#i*4
add t5, t5, a1#&dx[i]
flw ft2, 0(t5)#dx[i]
fabs.s ft3, ft2#dmax<?()
flt.s a4 ,ft1,ft3
beq a4 , x0, idamax_if2end
add t2, x0, t0#itemp=i
fmv.s ft1, ft3#dmax=()
idamax_if2end:
#i++
addi t0, t0, 1
j idamax_forini2
idamax_forend2:

idamax_ifend1:

add a0, x0, t2#a0=itemp
idamax_ret:

ret 
main:
#______CALL_FRAME______
# 100 float: 400B
#______Totale 400B

addi sp, sp, -400
add a6, sp, x0#n=100
addi t0, x0, 100#lda=10
addi t1, x0, 10#l in t2, k in t3

add t3, x0, x0#k=0
main_forini:

slt t5, t3, t0#k<?n
beq t5, x0, main_forend#k*k
mul t5, t3, t3
mul t5, t3, t5#()%n
rem t5, t5, t0

fcvt.s.w fa1, t5#(float)()
slli t5,t3, 2#k*4
add t5, t5, a6#&a[k]
fsw fa1, 0(t5)#++k
addi t3, t3, 1
j main_forini
main_forend:
#k=4
addi t3, x0, 4#lda*k
mul t5, t1, t3
add t5, t5, t3#lda*k+k
sub a3 , t0, t5#a3=n-lda*k-k
slli t5,t5, 2
add a1, t5, a6#a2=1
addi a2, x0, 1
jal idamax#a3=l=retval+k

addi a0 , a0, 4#print_int
addi a7,x0,1
ecall
#exit
addi a7,x0,10
ecall