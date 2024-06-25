# CALCOLARE E STAMPARE IL VALORE DELLA SOMMA
# 1*2 + 2*3 + 3*4 + ... + 10*11 9   (fa 440)

.data                       #SEZIONE DATI

out_str: 
.asciz "Il risultato e': "  # dichiara una stringa terminante con zero

.text                       #SEZIONE CODICE
main:                       # indica l'inizio del codice
     addi t0, x0, 1         # t0 e' un contatore inizializzato a 1 (n)
     addi t1, x0, 0         # t1 contiene la somma
     addi t2, x0, 10        # t2 contiene il limite del loop

loop_ini: 
     slt  t4, t2, t0        
     bne  t4, x0 loop_end   # esce dal loop se t0 > 10
     addi t3, t0, 1         # da n calcola (n+1) in t3
     mul  t3, t0, t3        # t3 = Lo (=t0*t3) (non uso Hi (mulh)...valori piccoli)
     add  t1, t1, t3        # t1 = t1 + t3
     addi t0, t0, 1         # incremento il contatore
     j    loop_ini          # salta a loop_ini

loop_end:                   # stampa la stringa di introduzione al risultato
     la   a0, out_str       # carica l'indirizzo della string da stampare in a0
     addi a7, x0,4          # system call per il servizio 4 (stampa stringa)
     ecall                  # chiama il sistema operativo per effettuare il servizio

     add  a0, x0, t1        # mette dentro a0 l'intero che e' in t1
     addi a7, x0,1          # system call per il servizio 1 (stampa un intero)
     ecall                  # chiama il sistema operativo per effettuare il servizio

     addi a7, x0,10         # system call per il servizio 1 (exit)
     ecall                  # chiama il sistema operativo per effettuare il servizio