
.data
inp1:
.asciz "Inserire stringa: "
inp2:
.asciz "\nInserire intero: "
out1:
.asciz "\nRisultato: "
newl:
.asciz "\n"
buf:
.space 80


.text
.globl main
#--------------------------------------

converti:
# lunghezza predefinita di 80 char max
addi t0, x0, 79
bne a1, x0, tomi# converti in minuscolo

toma:

beq t0, x0, finefun
lb t1, 0(a2 )# poni a 1 il bit 5
ori t1, t1, 32
sb t1, 0(a2 )
addi t0, t0, -1
addi a2 , a2 , 1
j toma

tomi:
beq t0, x0, finefun
lb t1, 0(a2 )# poni a 0 il bit 5
andi t1, t1, 223
sb t1, 0(a2)
addi t0, t0, -1
addi a2 , a2 , 1
j tomi
finefun:

jr ra#--------------------------------------

main:
#indirizzo msg input 1
la a0 , inp1# stampa msg1
addi a7,x0,4
ecall
# indirizzo buffer
addi a1, x0,79
la a0, buf# leggi stringa
addi a7,x0,8
ecall
# indirizzo msg input 2
la a0, inp2# stampa msg2
addi a7,x0,4
ecall
# leggi intero
addi a7,x0,5
ecall

add a1, a0, x0# a1 (&stringa)
la a2, buf
jal converti
# indirizzo msg output
la a0, out1# stampa msg3
addi a7,x0,4
ecall
# indirizzo buf
la a0 , buf# stampa risultato
addi a7,x0,4
ecall
# fine
addi a7,x0,10
ecall