.data
message: .asciz "Got a timer interrupt\n"
newLine: .asciz "\n"
timecnt: .word 0xFFFF0018 # reg. di conteggio interno   (in ms)
timecmp: .word 0xFFFF0020 # reg. di confronto del timer (in ms)
savereg: .space 20

.text
.globl main

setup:
   # Initialize timecmp to trigger
   # the first timer interrupt after 5 secs
   lw     a0, timecmp
   li     a1, 5000
   sw     a1, 0(a0)

   # Set the handler address and enable interrupts
   la     t0, timer_handler
   csrrw zero, utvec, t0 #handler address into the utvec

   # devo mettere a 1 il bit 4 di SIE 
   # per abilitare gli interrupt dallo user-timer **
   csrrsi zero, uie, 0x10    # enable user timer interrupt

   # devo mettere a 1 il bit 0 di SSTATUS 
   # per abilitare globalmente gli interrupt in user mode **
   csrrsi zero, ustatus, 0x1 # enable global user interrupts
   # ** NOTA: RARS usa la modalita? USER 
   #e non la modalita? SYSTEM
   # (in modalita? SYSTEM, i bit da mettere a 1 sarebbero 
   # rispettivamente il bit 5 e il bit 1)



loop: # ciclo di attesa infinita
      # per attendere gli interrupt dal timer
   add    x0,x0,x0
   j      loop

 
timer_handler:
   #------------------------------------------------------------
   # PROLOGO:
   # Salvo TUTTI I REGISTRI CHE USO 
   csrrw x0, uscratch,a4 # salvo a4 nello uscratch register
   la    a4, savereg     # (base della zona di salvataggio)
   sw    t2, 16(a4)      # NOTA: non posso usare lo stack!
   sw    t1, 12(a4)
   sw    t0, 8(a4)
   sw    a0, 4(a4)
   sw    a7, 0(a4)
   #------------------------------------------------------------

   # Print out the message
   li    a7, 4
   la    a0, message
   ecall

   # Re-initialize timer to interrupt every 5 seconds
   lw    a0, timecnt
   lw    t2, 0(a0)
   li    t1, 5000
   add   t1, t2 t1 # add to current count, another 5 seconds
   lw    t0, timecmp
   sw    t1, 0(t0) # update time-compare register

   #------------------------------------------------------------
   # EPILOGO:
   # Reload the saved registers and return
   lw    t2, 16(a4)
   lw    t1, 12(a4)
   lw    t0, 8(a4)
   lw    a0, 4(a4)
   lw    a7, 0(a4)
   #------------------------------------------------------------
   uret    # back to the user (in RARS uso urete invece di sret)

main:
   jal setup
   jal loop