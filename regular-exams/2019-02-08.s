
.data
RTN:
.asciz "\n"

.globl main
.text

#-------------------------------------
# a3=num,t0=NO_OF_BITS,t1=reverse_num,
# t2=i,t3=temp

reversebits:
# t0=32
addi t0, x0, 32
add t1, x0, x0# i=0
addi t2, x0, 0
for_ini:

sltu t4, t2, t0# i<?NO_OF_BITS
beq t4, x0, for_end
addi t4, x0, 1 # t4=1
sll  t3,t4,t2 # 1<<i

and t3, a2 , t3# num & (.)
beq t3, x0, if_end
add t4, t0, x0# t4=t4-1
addi t4, t4, -1
sub t4, t4, t2# t5=1
addi t5, x0, 1
sll  t5, t5, t4# 1<<(.)
or t1, t1, t5

if_end:
# i++
addi t2, t2, 1
j for_ini
for_end:

addi a0, t1, 0
ret
#--------------------------------------

main:
#--------------------------------------
# PROLOGO
# alloco frame
addi sp, sp, -16
sw ra, 12(sp)# salvo OLD-ra
sw s0, 8(sp)# salvo OLD-fp
add s0, x0, sp# NUOVO fp
sw s1, 4(s0)# salvo s1
sw s2, 0(s0)
#s2 = x = 2
addi s2, x0, 2
add a2 , s2, x0
jal reversebits
add s1, a0, x0#s1 = y

#serv.1
addi a7,x0,1
ecall
# carriage return
la a0 , RTN
#serv.4
addi a7,x0,4
ecall

add a2 , s1, x0# y
jal reversebits
addi a7,x0,1
ecall
#--------------------------------------
FINEFUN:
# EPILOGO
lw s2, 0(s0)# ripristina s2
lw s1, 4(s0)# ripristina s1
lw ra, 8(s0)# RIPRISTINA ra
lw s0, 12(s0)
# DEALLOCO FRAME
addi sp, sp, 16
# serv.10
addi a7,x0,10
ecall
