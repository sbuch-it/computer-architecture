
.data
nul: .asciz ""
.text
.globl main

itoa:

add t0, x0, a2
add t1, x0, x0
addi t2, x0, 10
div_start:

slti t3, t0, 10
bne t3, x0, div_end
rem t4, t0, t2
div t0, t0, t2
addi t4, t4, 48
addi t1, t1, 1
addi sp, sp, -1
sb t4, 0(sp)
j div_start

div_end:
addi t0, t0, 48
addi t1, t1, 1
addi sp, sp, -1
sb t0, 0(sp)
add a2 , x0, t1
addi a2 , a2 , 1
add a0, x0, a2
ori a7,x0,9
ecall

add t5, x0, a0
sb_start:

lb t6, 0(sp)
addi sp, sp, 1
addi t1, t1, -1
sb t6, 0(t5)
addi t5, t5, 1
beq t1, x0, sb_end
j sb_start
sb_end:

la a4, nul
lb a5, 0(a4)
sb a5, 0(t5)
jr ra
main:

ori a7,x0,5
ecall

add a2 , x0, a0
jal itoa

#add a0 , x0, a2
ori a7,x0,4
ecall

ori a7,x0,10
ecall