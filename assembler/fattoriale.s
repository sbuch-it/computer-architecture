# FATTORIALE RICORSIVO

.data
    messaggio:    .asciz "Calcolo di n!\n"
    insdati:      .asciz "Inserisci n = "
    visris:       .asciz "n! = "
    RTN:          .asciz "\n"

.globl main
.text

# Funzione per il calcolo del fattoriale (versione per RV32IM)
# Parametri:   n  : a0 (x10)
# Risultato:   n! : a0 (x10)

fact:

# crea il call frame sullo stack (12 byte)
# lo stack cresce verso il basso
    addi sp, sp, -12     # allocazione del call frame nello stack
    sw   a0, 8(sp)       # salvataggio di n nel call frame
    sw   ra, 4(sp)       # salvataggio dell'indirizzo di ritorno
    sw   s0, 0(sp)       # salvataggio del precedente frame pointer
    add  s0, sp, zero    # aggiornamento del frame pointer

# calcolo del fattoriale
    bne  a0, zero,  Ric  # test fine ricorsione n!=0
    addi a0, zero, 1     # 0! = 1
    j    Fine    

Ric:                     # chiamata ricorsiva per il calcolo di (n-1)!
    addi a0, a0, -1      # a0 <- (n ? 1)  passaggio del parametro in a0 per fact(n-1)
    call fact            # chiama fact(n-1) -> risultato in a0
    lw   t0, 8(s0)       # t0 <- n
    mul  a0, a0, t0      # n! = (n-1)! x n

# uscita dalla funzione 
Fine:
    lw   s0, 0(sp)       # recupera il frame pointer
    lw   ra, 4(sp)       # recupera l'indirizzo di ritorno
    addi sp, sp, 12      # elimina il call frame dallo stack
    jr   ra              # ritorna al chiamante

# Programma principale
#

main:

# Stampa intestazione
    la   a0, messaggio
    addi a7, zero, 4
    ecall

# Stampa richiesta
    la   a0, insdati
    addi a7, zero,  4
    ecall

# legge n (valore in a0)
    addi a7, zero,  5
    ecall

# chiama fact(n)
    call  fact          # parametro n in a0 
    add  s0, a0, zero   # salva il risultato in s0

# stampa messaggio per il risultato
    la   a0, visris
    addi a7, zero,  4
    ecall

# stampa n!
    add  a0, s0, zero
    addi a7, zero,  1
    ecall

# stampa \n
    la   a0, RTN
    addi a7, zero,  4
    ecall

# exit
    addi a7, zero,  10
    ecall