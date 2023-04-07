.data
A:
.word 1,2,3,4,5,6,7,8,8
LC0: .asciz "det(A)="

.text
.globl main
main:
la   a5, A #carico ind.base matrice
#Carico diagonale
lw   a1,  0(a5) #A[0][0]
lw   a4, 16(a5) #A[1][1]
lw   a0, 32(a5) #A[2][2]
#moltiplico diagonale a salvo in a3
mul  a3, a4, a0
lw   a4, 20(a5) #A[1][2]
lw   a0, 28(a5) #A[2][1]
#moltiplico e salvo in a0
mul  a0, a4, a0
#sottraggio e salvo in a0
sub  a0, a3, a0
mul  a1, a1, a0 #molt.per A[0][0]
#in a1 ho il primo pezzo dell'espr.

lw   a2, 12(a5) #A[1][0]
lw   a4,  4(a5) #A[0][1]
lw   a0, 32(a5) #A[2][2]
#a3=A[0][1] * A[2][2]
mul  a3, a4, a0
lw   a4,  8(a5) #A[0][2]
lw   a0, 28(a5) #A[2][1]
#a0= A[0][2]*A[2][1]
mul  a0, a4, a0
#sottraggo e metto in a0
sub  a0, a3, a0
#moltiplico con A[1][0]#e salvo in a0
mul  a0, a2, a0
#sottraggo al precedente pezzo
sub  a1, a1, a0
#in a1 ho i primi due pezzi dell'espr.

lw   a2, 24(a5) #A[2][0]
lw   a4,  4(a5) #A[0][1]
lw   a0, 20(a5) #A[1][2]
#a3= A[0][1]*A[1][2]
mul  a3 , a4, a0
lw   a4,  8(a5) #A[0][2]
lw   a0, 16(a5) #A[1][1]
#a0= A[0][2]*A[1][1]
mul  a0, a4, a0
sub  a0, a3 , a0
#moltiplico per A[2][0] e salvo in a0
mul  a0, a2, a0
#sommo col precedente pezzo
add  a1, a1, a0
#stampo stringa det(A)=
la   a0, LC0
addi a7, x0,4
ecall
#stampo risultato
mv   a0, a1
addi a7, x0,1
ecall
#exit
addi a7, x0, 10
ecall