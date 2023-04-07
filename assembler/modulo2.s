
 .data
f: 
 .float 0.0
A: 
 .float 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0
ret: 
 .asciz "\n"
esi: 
 .asciz "esito="
nco: 
 .asciz "   n.cond="
 .text
 .globl main
   # non necessario su SPIM: caricare exp.s e ncond.s in sequenza
   # a3=**T
   # a1=n
   # a2=*nc
   # a0=r
   # t0=j
   # t1=k

num_cond: 
   # spazio per a3,a0,t0,t1
   addi sp, sp, -24
   
   #prepariamo il frame perche' lo useremo quando chiameremo funzione esterna
   sw ra, 0(sp)   # salva ra perche' usa altra f.(exp)
   sw s0, 4(sp)   # salva fp per il ritorno
   add s0, sp, x0 # salvo sp per il ritorno
   
   add a0, x0, x0   # r = 0 
   addi t0, x0, 1   # j = 1 
   addi t2, x0, 1
   fcvt.s.w fa1, t2 # preparo costante f.p. 1
   addi t2, x0, 0
   fmv.s.x fa0, t2  # preparo costante f.p. 1 (la codifica di 0.0 e' 0...0)
while_ini: 

   slt t2, a1, t0   # j > n ? 
   bne t2, x0 while_end   # se si while_end
   add t1, x0, x0   # k = 0
for_ini: 

   slt t2, t1, a1     # k < n ? 
   beq t2, x0 for_end #se risultato slt = 0 -> uscita for
   addi t3, t0, -1    # j -1 
   add t2, t3, t3     # calcolo indice riga matrice T 
   add t2, t2, t3     # (j-1)*3 ( moltiplico per 3 perche' e' una matrice 3x3)
   add t2, t2, t1     # (j-1)*3+k (indice riga piu' colonna per l'elemento selezionato)
   slli t2,t2, 2      #  moltiplico per la size del dato float = 32bit = 4 byte
   add t2, t2, a3     # carico l'indirizzo di T[j-1][k] 
   flw fa2, 0(t2)     # carico il valore di T[j-1][k] in fa2 
   feq.s t5,fa2,fa0   # if != 0  
   bne t5, x0, ramo_else  #se == 0 vai a ramo else
   #salvo i valori n, r,j,k prima della chimata a exp
   sw a3, 8(s0)   
   sw a0, 12(s0)   
   sw t0, 16(s0)   
   sw t1, 20(s0)   
   fneg.s fa2, fa2    # cambio segno 
   fmv.x.s a3, fa2    # carico parametro funzione exp
   jal exp            #chiamo funzione exp
   
   #qui ritornera' ra dopo la chiamata a exp
   
   fmv.s.x fa2, a0    #carico il valore di ritorno di exp
   
   #rispristino i valori che avevo salvato nello stack
   lw t1, 20(s0)   
   lw t0, 16(s0)   
   lw a0, 12(s0)   
   lw a3, 8(s0)   
   fdiv.s fa2, fa1, fa2    # 1/exp(-T[][])
   flw ft0, 0(a2)          # carico nc 
   fadd.s ft0, ft0, fa2    # nc+=  
   fsw ft0, 0(a2)          # salvo il risultato 
   j if_end                

ramo_else: 
   addi a0, x0, 1          # r ++

if_end: 
   addi t1, t1, 1          # k++
   j for_ini

for_end: 
   addi t0, t0, 1         #j++
   j while_ini
while_end: 

   lw ra, 0(s0)           # carichiamo ra per tornare al main 
   lw s0, 4(s0)           # carichiamo il fp 
   addi sp, sp, 24        # liberiamo lo stack
   ret
   
main: 
   
   la a3,  A        #base address matrice A
   addi a1, x0, 3   # n 
   la a2,  f        # base address f
   jal num_cond

   add s0, a0, x0   #print "esito"
   la a0,  esi
   addi a7,x0,4
   ecall
   
   add a0, s0, x0   # ripristina ec
   addi a7,x0,1     # stampa esito
   ecall    
   
   la a0,  nco      #stampa "n.cond"
   addi a7,x0,4
   ecall   
   
   la a0,  f        #carica f 
   flw fa0, 0(a0)  
   addi a7,x0,2     #stampa float
   ecall   

   addi a7,x0,10    #exit
   ecall
