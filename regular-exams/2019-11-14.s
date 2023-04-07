.data
prompt:  .asciz "\nInserire un numero intero: "
output:  .asciz "\nIl numero di Fibonacci e': "
ncit:    .asciz "\nIl numero totale di cicli per l'algoritmo iterativo e': "
ncrc:    .asciz "\nIl numero totale di cicli per l'algoritmo ricorsivo e': "
BB:      .asciz "\nConteggio dei BB: "
virgola: .asciz ","
RTN:     .asciz "\n"
.text
.globl main

main: 
	 la a0, prompt   # stampa della stringa "Inserire un numero intero: "
	 addi a7,x0,4
	 ecall

	 addi a7,x0,5     # lettura del valore inserito
	 ecall

	 add s0, x0, a0   # salvo il valore letto in s0

#Azzeramento variabili per instrumentazione
	 add s8, x0, x0   # contatore cicli macchina
	 add s1, x0, x0   # contatore istanze Basic-Block #1
	 add s2, x0, x0   # contatore istanze Basic-Block #2
	 add s3, x0, x0   # contatore istanze Basic-Block #3
	 add s4, x0, x0   # contatore istanze Basic-Block #4

	 add a4, s0, x0   # metto n in a2
	 jal fib_it       # chiamata della funzione fib_it()

	 add s7, a0, x0   # salvo il risultato s7
	 la a0,  output   # stampa della stringa "Il numero di Fibonacci e': "
	 addi a7,x0,4     
	 ecall

	 add a0, s7, x0   # stampo il numero di fibonacci
	 addi a7,x0,1
	 ecall

# Stampa risultati instrumentazione
	 la a0,  BB       # stampa della stringa "\nConteggio dei BB: "
	 addi a7,x0,4     
	 ecall

	 add a0, x0, s1   # stampo il numero corrispondente alle esecuzioni di BB1
	 addi a7,x0,1
	 ecall

	 la a0,  virgola  # stampo la stringa ","
	 addi a7,x0,4
	 ecall

	 add a0, x0, s2   # stampo il numero corrispondente alle esecuzioni di BB2
	 addi a7,x0,1
	 ecall

	 la a0,  virgola  # stampo la stringa ","
	 addi a7,x0,4
	 ecall

	 add a0, x0, s3  # stampo il numero corrispondente alle esecuzioni di BB3
	 addi a7,x0,1
	 ecall

	 la a0,  virgola # stampo la stringa ","
	 addi a7,x0,4
	 ecall

	 add a0, x0, s4  # stampo il numero corrispondente alle esecuzioni di BB4
	 addi a7,x0,1
	 ecall

	 la a0,  ncit    # stampo la stringa "\nIl numero totale di cicli per..."
	 addi a7,x0,4
	 ecall

	 add a0, x0, s8  # stampo il numero di cicli eseguiti per l'algoritmo it.
	 addi a7,x0,1
	 ecall

	 la a0,  RTN     # stampo il ritorno a capo
	 addi a7,x0,4
	 ecall

#Azzeramento variabili per instrumentazione

	 add s8, x0, x0  # contatore cicli macchina

	 add s1, x0, x0  # contatore istanze Basic-Block #1
	 add s2, x0, x0  # contatore istanze Basic-Block #2
	 add s3, x0, x0  # contatore istanze Basic-Block #3
	 add s4, x0, x0  # contatore istanze Basic-Block #4

	 add a2, s0, x0  # metto n in a2
	 jal fib_rc      # chiamata della funzione fib_rc()
 
	 add s0, a0, x0  # salvo il risultato s0
	 la a0,  output  # stampa della stringa "Il numero di Fibonacci e': "
	 addi a7,x0,4
	 ecall

	 add a0, s0, x0  # stampo il numero di fibonacci
	 addi a7,x0,1
	 ecall

# Stampa risultati instrumentazione

	 la a0,  BB     # stampa della stringa "\nConteggio dei BB: "
	 addi a7,x0,4   
	 ecall

	 add a0, x0, s1 # stampo il numero corrispondente alle esecuzioni di BB1
	 addi a7,x0,1
	 ecall

	 la a0,  virgola  # stampo la stringa ","â?Ž
	 addi a7,x0,4
	 ecall

	 add a0, x0, s2  # stampo il numero corrispondente alle esecuzioni di BB2
	 addi a7,x0,1
	 ecall

	 la a0,  virgola   # stampo la stringa ","â?Ž
	 addi a7,x0,4
	 ecall

	 add a0, x0, s3  # stampo il numero corrispondente alle esecuzioni di BB3
	 addi a7,x0,1
	 ecall

	 la a0,  virgola   # stampo la stringa ","â?Ž
	 addi a7,x0,4
	 ecall

	 add a0, x0, s4  # stampo il numero corrispondente alle esecuzioni di BB4
	 addi a7,x0,1
	 ecall

	 la a0,  ncit    # stampo la stringa "\nIl numero totale di cicli per..."
	 addi a7,x0,4
	 ecall

	 add a0, x0, s8  # stampo il numero di cicli eseguiti per l'algoritmo rc
	 addi a7,x0,1
	 ecall

	 la a0,  RTN    # stampo il ritorno a capo
	 addi a7,x0,4
	 ecall

	 addi a7,x0,10
	 ecall

fib_it: 
#__________________________________________________________________________________________BB1
	 addi s8, s8, 2    # contributo cicli di BB1
	 addi s1, s1, 1    # incrementa n. volte in cui e' eseguito BB1

	 addi a0, x0, 0    # first = 0
	 addi a1, x0, 1    # second = 0

while: 
#__________________________________________________________________________________________BB2
	 addi s8, s8, 5       # contributo cicli di BB2
	 addi s2, s2, 1       # incrementa n. volte in cui e' eseguito BB2
	 add t0, x0, a4       # (n != 0) ?
	 addi a4, a4, -1      # n = n - 1
	 beq t0, x0 end_while # se n==0 allora termino il ciclo

#__________________________________________________________________________________________BB3
	 addi s8, s8, 4      # contributo cicli di BB3
	 addi s3, s3, 1      # incrementa n. volte in cui e' eseguito BB3
	 add t0, a0, a1      # tmp = first+second
	 add a0, x0, a1      # first = second
	 add a1, x0, t0      # second = tmp
	 j while

end_while: 
#__________________________________________________________________________________________BB4
	 addi s8, s8, 1      # contributo cicli di BB4
	 addi s4, s4, 1      # incrementa n. volte in cui e' eseguito BB4
	 jr ra               # passo il controllo al chiamante


fib_rc: 
#__________________________________________________________________________________________BB1
	 addi s8, s8, 15    # contributo cicli di BB1 
	 addi s1, s1, 1     # incrementa n. volte in cui e' eseguito BB1
	 addi sp, sp, -8    # riservo due word nello stack
	 sw ra, 0(sp)       # salvo l'indirizzo di ritorno nella prima word dello stack
	 add a0, x0, x0     # metto il valore fisso di confronto 0 in a0
	 beq a2, a0 exit    # se a2==0 allora ho finito

#__________________________________________________________________________________________BB2
	 addi s8, s8, 4     # contributo cicli di BB2
	 addi s2, s2, 1     # incrementa n. volte in cui e' eseguito BB2
	 addi a0, x0, 1     # metto il valore fisso di confronto 1 in a0
	 beq a2, a0 exit    # se a2==1 allora ho finito
#__________________________________________________________________________________________BB3
	 addi s8, s8, 45     # contributo cicli di BB3
	 addi s3, s3, 1      # incrementa n. volte in cui e' eseguito BB3
	 addi t0, a2, -2     # t0 = n-2
	 addi a2, a2, -1     # a0 = n-1
	 sw t0, 4(sp)        # salva t0 nello stack
	 jal fib_rc          # chiama fibo(n-1): risultato in a0

	 lw a2, 4(sp)        # ripristino ex-t0 in a2 (n-2)
	 sw a0, 4(sp)        # salva a0 nello stack
	 jal fib_rc          # chiama fibo(n-2): risultato in a0
	 lw t0, 4(sp)        # ripristina ex-a0 in t0 (fibo(n-1))
	 add a0, a0, t0      # somma fibo(n-2) e fibo(n-1)

exit: 
#__________________________________________________________________________________________BB4
	 addi s8, s8, 12     # contributo cicli di BB4
	 addi s4, s4, 1      # incrementa n. volte in cui e' eseguito BB4

	 lw ra, 0(sp)        # recupero l'indirizzo di ritorno dallo stack
	 addi sp, sp, 8      # incremento lo stac
	 jr ra               # passo il controllo al chiamante
