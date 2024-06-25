
.data
x:
.float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0
.text
.globl main

gep:
#______CALL_FRAME______
# float t[2]: 8B
#______Totale 8B

addi sp, sp, -8# c in a3, n in a1, res in a2
# i in t0, j in t1, k in t2, p in t3
# q in t4, m in t5
# temp in f4, sum in f5, max in f6
#t9=3=dim.riga
addi a6, x0, 3#for1

add t1, x0, x0#j=0
gep_for1start:
#t6=n-1
addi t6, a1, -1
slt a4, t1, t6#j<?n-1
beq a4, x0, gep_for1end#j*3
mul a4, t1, a6
add a4, a4, t1#j*3+j
slli a4,a4, 2#4*(j*3+j)
add a4, a3 , a4#&c[j][j]
flw ft4, 0(a4)#c[j][j]
fabs.s ft3, ft4#max=fabs()
add t3, t1, x0#m=j+1
addi t5, t1, 1
gep_for11start:

slt a4, t5, a1#m<?n
beq a4, x0, gep_for11end#m*3
mul a4, t5, a6
add a4, a4, t1#m*3+j
slli a4,a4, 2#4*(m*3+j)
add a4, a3 , a4#&c[m][j]
flw ft4, 0(a4)#c[m][j]
fabs.s ft5, ft4#()>=?max
flt.s a7 ,ft5,ft3
bne a7 , x0, gep_if111end
fmv.s ft3, ft4#max=c[m][j]
add t3, t5, x0#p=m
gep_if111end:
#m++
addi t5, t5, 1
j gep_for11start
gep_for11end:
#if11
beq t3, t1, gep_if11end#for111
add t4, t1, x0#q=j
gep_for111start:
#n+1
addi t6, a1, 1
slt a4, t4, t6#q<?n+1
beq a4, x0, gep_for111end#j*3
mul a4, t1, a6
add a4, a4, t4#j*3+q
slli a4,a4, 2#4*(j*3+q)
add a4, a3 , a4#&c[j][q]
flw ft1, 0(a4)#p*3
mul a5, t3, a6
add a5, a5, t4#p*3+q
slli a5,a5, 2#4*(p*3+q)
add a5, a3 , a5#&c[p][q]
flw ft5, 0(a5)#c[p][q]
fsw ft5, 0(a4)#c[j][q]=c[p][q]
fsw ft1, 0(a5)#++q
addi t4, t4, 1
j gep_for111start
gep_for111end:

gep_if11end:
#i=j+1
addi t0, t1, 1
gep_for12start:

slt a4, t0, a1#i<?n
beq a4, x0, gep_for12end#i*3
mul a4, t0, a6
add a4, a4, t1#i*3+j
slli a4,a4, 2#4*(i*3+j)
add a4, a3 , a4#&c[i][j]
flw ft4, 0(a4)#j*3
mul a5, t1, a6
add a5, a5, t1#j*3+j
slli a5,a5, 2#4*(j*3+j)
add a5, a3 , a5#&c[j][j]
flw ft5, 0(a5)#c[j][j]
fdiv.s ft1, ft4, ft5#for121
add t2, t1, x0#k=j
gep_for121start:

slt a4, a1, t2#n<?k
bne a4, x0, gep_for121end#i*3
mul a4, t0, a6
add a4, a4, t2#i*3+k
slli a4,a4, 2#4*(i*3+k)
add a4, a3 , a4#&c[i][k]
flw ft4, 0(a4)#j*3
mul a5, t1, a6
add a5, a5, t2#j*3+k
slli a5,a5, 2#4*(j*3+k)
add a5, a3 , a5#&c[j][k]
flw ft5, 0(a5)#c[j][k]
fmul.s ft6, ft1, ft5#temp*cjk
fsub.s ft6, ft4, ft6#cik-()
fsw ft6, 0(a4)#k++
addi t2, t2, 1
j gep_for121start
gep_for121end:
#i++
addi t0, t0, 1
j gep_for12start
gep_for12end:
#j++
addi t1, t1, 1
j gep_for1start
gep_for1end:
#t8=n1=n-1
addi a5, a1, -1#n1*3
mul a4, a5, a6
add a4, a4, a1#n1*3+n
slli a4,a4, 2#4*(n1*3+n)
add a4, a3 , a4#&c[n1][n]
flw ft4, 0(a4)#n1*3
mul a4, a5, a6
add a4, a4, a5#n1*3+n1
slli a4,a4, 2#4*(n1*3+n1)
add a4, a3 , a4#&c[n1][n1]
flw ft5, 0(a4)#c[n1][n1]
fdiv.s ft6, ft4, ft5#cn1n/cn1n1
slli a4,a5, 2#4*n1
add a4, a4, sp#&t[n-1]
fsw ft6, 0(a4)#for2
#i=n-2
addi t0, a1, -2
gep_for2start:

slt a4, t0, x0#i<?0
bne a4, x0, gep_for2end
fmv.s.x ft2, x0#j=i+1
addi t1, t0, 1#for21
gep_for21start:

slt a4, t1, a1#j<?n
beq a4, x0, gep_for21end#i*3
mul a4, t0, a6
add a4, a4, t1#i*3+j
slli a4,a4, 2#4*(i*3+j)
add a4, a3 , a4#&c[i][j]
flw ft4, 0(a4)#c[i][j]
slli a5,t1, 2#4*j
add a5, a5, sp#&t[j]
flw ft5, 0(a5)#t[j]
fmul.s ft6, ft4, ft5#cij*tj
fadd.s ft2, ft2, ft6#j++
addi t1, t1, 1
j gep_for21start
gep_for21end:
#i*3
mul a4, t0, a6
add a4, a4, t0#i*3+i
slli a4,a4, 2#4*(i*3+i)
add a4, a3 , a4#&c[i][i]
flw ft4, 0(a4)#i*3
mul a4, t0, a6
add a4, a4, a1#i*3+n
slli a4,a4, 2#4*(i*3+n)
add a4, a3 , a4#&c[i][n]
flw ft5, 0(a4)#c[i][n]
fsub.s ft7, ft5, ft2#cin-sum
fdiv.s fa3, ft7, ft4#()/cii
slli a5,t0, 2#4*i
add a5, a5, sp#&t[i]
fsw fa3, 0(a5)#i--
addi t0, t0, -1
j gep_for2start
gep_for2end:

flw ft4, 0(sp)#t[0]
fsw ft4, 0(a2)#*res=()
addi sp, sp, -8
ret 
main:
#________CALL FRAME_____________
# saved variable: fp,ra 8B
# local variable: out=0(fp) 4B
#___________________Totale 12B

addi sp, sp, -12
sw s0, 8(sp)
sw ra, 4(sp)
add s0, sp, x0#a3=&x
la a3 , x#a1=2
addi a1, x0, 2
add a2, s0, x0#a2=&out
jal gep
add t0, s0, x0
flw fa0, 0(t0)#print_float
addi a7,x0,2
ecall

addi sp, sp, 12

addi a7,x0,10
ecall