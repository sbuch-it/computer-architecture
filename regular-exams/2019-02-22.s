
.data
a:
.word 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1
c:
.space 128
.globl main
.text#-------------------------------------
# a2=a,a1=n t0=i,t1=count,t2=j,t3=k

bitstuff:
#i=0
addi t0, x0, 0#count=1
addi t1, x0, 1#j=0
addi t2, x0, 0
bs_wh_ini:

slt a6, t0, a1
# i<?n
beq a6, x0, bs_wh_end
slli t4,t0, 2
#i*4
add t4, t4, a2
#&a[i]
lw t4, 0(t4)
#1
addi t5, x0, 1
bne t4, t5, bs_if1_else
slli a6,t2, 2
#&c
la a5, c
add a5, a5, a6
#&c[j]
sw t4, 0(a5)
#k=i+1
addi t3, t0, 1

bs_for_ini:

slli t6,t3, 2   #k*4
add t6, t6, a2  #&a[k]
lw t6, 0(t6)    #a[k]
bne t6, t5, bs_for_end
slt a6, t3, a1#k<?n
beq a6, x0, bs_for_end#count<?5
slti a6, t1, 5
beq a6, x0, bs_for_end#j++
addi t2, t2, 1
slli a6,t2, 2#&c
la a5, c
add a5, a5, a6#&c[j]
sw t6, 0(a5)#count++
addi t1, t1, 1#5
addi a4, x0, 5
bne t1, a4, bs_if2_end#j++
addi t2, t2, 1
slli a6,t2, 2#&c
la a5, c
add a5, a5, a6#&c[j]
sw x0, 0(a5)#c[j]=0

bs_if2_end:
add t0, t3, x0#k++
addi t3, t3, 1
j bs_for_ini

bs_for_end:
j bs_if1_end

bs_if1_else:
slli a6,t2, 2#&c
la a5, c
add a5, a5, a6#&c[j]
sw t4, 0(a5)#c[j]=a[i]
bs_if1_end:
#i++
addi t0, t0, 1#j++
addi t2, t2, 1
j bs_wh_ini

bs_wh_end:
add a0, t2, x0
ret
#-------------------------------------

main:
# &a
la a2 , a# n
addi a1, x0, 12
jal bitstuff
add t1, a0, x0# m
add t0, x0, x0# i=0

main_forini:
slt a6, t0, t1# i<?m
beq a6, x0, main_forend
slli t2,t0, 2# &c
la t3, c
add t2, t2, t3# &c[i]

lw a0 , 0(t2)
addi a7,x0,1
ecall
#i++
addi t0, t0, 1
j main_forini

main_forend:
# serv.10
addi a7,x0,10
ecall