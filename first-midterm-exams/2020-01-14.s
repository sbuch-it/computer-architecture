.data
base: .space 8
freep: .word 0
RTN: .asciz "\n"
HEAPtop: .asciz "Heap Top:"
heapmsg: .asciz "Malloc returns:"
.globl main
.text
malloc: 
#____NO_CALL_FRAME____________
S1: # a0=nbytes, sizeof(Header)=8
	 addi t0, a0, 8        # nbytes +8
	 addi t0, t0, -1       # (nbytes +8 -1)
	 srli t0,t0, 3         # (.)/8
	 addi t0, t0, 1        # (.)/8+1
	 # t0=nunits
#--------------------------------------
S2: 
	 la t1,  freep        # &freep
	 lw t2, 0(t1)         # VALORE_DI(freep)
	 # t2 = prevp     # (prevp=freep)
	 bne t2, x0 FINEIF1   # if((.)==NULL)
	 la t3,  base         # &base
	 add t2, x0, t3       # prevp=&base
	 sw t3, 0(t1)         # freep=&base
	 sw t3, 0(t3)         # base.s.ptr=&base
	 sw x0, 4(t3)         # base.s.size=0

FINEIF1: 
#--------------------------------------
S3: 
#--------------------------------------
S31: # t4=p
     lw t4, 0(t2)        # p=prevp->s.ptr
#--------------------------------------
S3.2: # VUOTO!
#--------------------------------------
S3.3: 
INIFOR: 
S331: 
         # (t0=nunits), (t4=p)
	 lw t5, 4(t4)        # p->s.size
	 # t5 = p->s.size
	 slt t6, t5, t0      # A>=B => !(A<B)
	 bne t6, x0 FINEIF2  # if (!(p->s.size<nunits))
CORPOIF2: 
	 bne t5, t0 ELSE3    # if (p->s.size==nunits)
	 lw a6, 0(t4)        # (p->s.ptr)  
	 sw a6, 0(t2)        # prevp->s.ptr=(.)
	 j FINEIF3
ELSE3: 
	 sub t5, t5, t0     # (p->s.size-nunits)
	 sw t5, 4(t4)       # p->size=(.)
	 add t4, t4, t5     # p+=p->s.size
	 sw t0, 4(t4)       # p->s.size=nunits
FINEIF3: 
	 sw t2, 0(t1)       # freep=prevp
	 addi a0, t4, 8     # p+1, il "+1" e' un Header
	 # a0 e' il valore di ritorno di "malloc" 
	 j FINEFUN 
FINEIF2: #chiudo S3.3.1
#--------------------------------------
S3.3.2: 
	 lw t3, 0(t1)          # freep aggiornato
	 bne t4, t3 FINEIF4    # if (p==freep)
	 #addi a0, x0, 9     
	 add a0, t0, x0        # a0=units da allocare
	    # NOTA: IL SEGUENTE CODICE E' ADATTATO 
	    # AL FINE DI AVERE UNA VERISONE FUNZIONANTE
        slli a0,a0,3          # sbrk(nunits*sizeof(Header))
	 addi a7,x0,9          # servizio 9 => SBRK
	 ecall                 # up=a0=pun.mem.allocata
	 add  x26,x0,x0
	    addi x26,x0,-1   # x26 = -1
	 beq  a0,x26,FINENULL # if((.) == -1) ADATTATO!
	    sw t0, 4(a0)          # up->s.size=nunits
	    sw t4, 0(a0)	      # up->s.ptr = p
	    sw a0, 0(t4)          # p->s.ptr = up
	    add t4, t3, x0        # p = freep
	 j FINEIF5
FINENULL: 
	 add a0, x0, x0        # a0 <= 0
	 j FINEFUN
FINEIF5: 
FINEIF4: # chiude S332 e CORPOFOR
	 add t2, x0, t4        # prevp=p
	 lw t4, 0(t4)          # p=p->s.ptr
	 j INIFOR              # chiudo FOR, S3.3.2 e S3.3
#--------------------------------------
FINEFUN:
	 jr ra
#--------------------------------------
#TESTBENCH
printHEAPtop:  
	 add a0, x0, x0        # get HEAPtop
	 addi a7,x0,9          # serv.9
	 ecall                 #sbrk
	 add a1, x0, a0        # salvo in a1
	 la a0,  HEAPtop       # stampa msg
	 addi a7,x0,4          # serv.4
	 ecall                 #print_str
	 add a0, x0, a1        # nuovo HEAPtop
	 addi a7,x0,1          #serv. 1
	 ecall	               #print_int
	 la a0,  RTN           # stampa RTN
	 addi a7,x0,4          #serv 4
	 ecall                 #print_str
	 jr ra
printMALLOC: 
         #a0 = pun. da stampare
	 add t0, a0, x0        # t0=pun.
	 la a0,  heapmsg       
	 addi a7,x0,4          # serv.4
	 ecall                 #print_str
	 add a0, t0, x0        # a0=pun 
	 addi a7,x0,1          #serv.1
	 ecall                 #print_int
	 la a0,  RTN          # stampa RTN
	 addi a7,x0,4         # serv.4
	 ecall                # print_str
	 jr ra
#--------------------------------------
main:  
	 jal printHEAPtop      
	 addi a0, x0, 256     # alloca 256B
	 jal malloc
	 jal printMALLOC
	 jal printHEAPtop
	 addi a0, x0, 256     # alloca 256B
	 jal malloc
	 jal printMALLOC
	 jal printHEAPtop
	 addi a0, x0, 256      # alloca 256B
	 jal malloc
	 jal printMALLOC
	 jal printHEAPtop
	 addi a7,x0,10        #serv.10
	 ecall                #exit
