
.data
input1:
.asciz "inserisci numero in base 10: "
stringa:
.space 20
risultato:
.asciz "\n--> "
.text

.globl main

main:
# stampo stringa input1
la a0, input1
addi a7,x0,4
ecall
# leggo stringa numerica da tastiera e salva in stringa
la a0, stringa# max char da leggere (20-1)
addi a1, x0, 19
addi a7,x0,8
ecall
# leggo stringa numerica da tastiera e salva in stringa
la a2, stringa
jal atox# converti stringa da base 10 a base 16

add s2, a0, x0# stampo messaggio risultato
la a0, risultato
addi a7,x0,4
ecall

add a0, s2, x0# copio puntatore stringa in a2
addi a7,x0,4
ecall
# uscita
addi a7,x0,10
ecall

atox:
# test
# jr ra
#___PROLOGO

addi sp, sp, -12
sw s0, 0(sp)
add s0, sp, x0
sw ra, 4(sp)
sw s2, 8(sp)
add s2, a2 , x0# alloco 20B di memoria dinamica
addi a0 , x0, 20
addi a7,x0,9
ecall
# a0 punta gia' al buffer della stringa risultato
addi a0, a0, 19
sb x0, 0(a0)# aggiorno punto iniziale di scrittura
addi a0, a0, -1# converto da stringa base 10 a intero
add t0, s2, x0
# carattere new-line
addi t2, x0, 10
l1:
lb t1, 0(t0)
addi t0, t0, 1
bne t1, t2, l1# punto alla cifra meno significativa
addi t0, t0, -2
add a6, x0, x0# t8=10
addi a5, x0, 10
l2:
lb t1, 0(s2)# trasformo ASCII --> intero
addi t1, t1, -48
add a6, a6, t1# aggiorno puntatore
addi s2, s2, 1
slt t2, t0, s2
bne t2, x0, fine1# se non ci sono piu' caratteri finisco
mul a6, a6, a5
j l2

fine1:
# converto da intero a stringa base 16
addi a5, x0, 58
add t0, a6, x0
l3:
addi a0, a0, -1
andi t0, a6, 15
addi t0, t0, 48
slt t1, t0, a5
bne t1, x0, av1# caso di cifra > 9
addi t0, t0, 7
av1:
sb t0, 0(a0)
srai a6,a6, 4# sposta cifre esadecimali
bne a6, x0, l3
addi a0, a0, -1
addi t0, x0, 120
sb t0, 0(a0)# memorizza 'x'
addi a0, a0, -1
addi t0, x0, 48
sb t0, 0(a0)#___EPILOGO

lw s2, 8(s0)
lw ra, 4(s0)
lw s0, 0(s0)
addi sp, sp, 12
ret 