
.data
a:
.word 51, 11, 32, 34, 11, 51, 46, 5, 62, 27
spa: .asciz " "
.globl main
.text#-------------------------------------
# a2=a,a1=n t0=i,t1=j,t2=increm,t3=tmp

shellsort:
#costante=2
addi a5, x0, 2#n/2
div t2, a1, a5#increm=(.)

ss_for1_ini:
slt a6, x0, t2          #increm>?0
beq a6, x0, ss_for1_end #-----for1 body start

add t0, x0, t2
ss_for2_ini:

slt a6, t0, a1          #i<?n
beq a6, x0, ss_for2_end #-----for2 body start

slli t3,t0, 2   #i*4
add t3, t3, a2  #&a[i]
lw t3, 0(t3)    #tmp=a[i]
add t1, x0, t0  #j=i

ss_for3_ini:
slt a6, t1, t2  #j<?increm
bne a6, x0, ss_for3_end
#-----for3 body start
sub t4, t1, t2#j-increm
slli t4,t4, 2#(.)*4
add t4, t4, a2#&a[(.)]
lw t4, 0(t4)#a[(.)]
slt a6, t3, t4#tmp<?(.)
beq a6, x0, ss_else#-----if body start

slli t5,t1, 2#j*4
add t5, t5, a2#&a[j]
sw t4, 0(t5)#a[j]=a[..]
j ss_if_end#-----if body end

ss_else:

j ss_for3_end#break
ss_if_end:
#-----for3 body end

sub t1, t1, t2#j=-increm
j ss_for3_ini
ss_for3_end:

slli t5,t1, 2#j*4
add t5, t5, a2#&a[j]
sw t3, 0(t5)#-----for2 body end
#i++
addi t0, t0, 1
j ss_for2_ini
ss_for2_end:
#-----for1 body end
#increm/2
div t2, t2, a5#increm=(.)
j ss_for1_ini
ss_for1_end:

jr ra#-------------------------------------

main:
# &a
la a2 , a# n
addi a1, x0, 10
jal shellsort
add t0, x0, x0# i=0

main_forini:
slt a6, t0, a1# i<?n
beq a6, x0, main_forend
slli t2,t0, 2# &a
la t3, a
add t2, t2, t3# &a[i]

lw a0 , 0(t2)# serv.1
addi a7,x0,1
ecall# &sp

la a0, spa # serv.4
addi a7,x0,4
ecall#i++

addi t0, t0, 1
j main_forini

main_forend:
# serv.10

addi a7,x0,10
ecall