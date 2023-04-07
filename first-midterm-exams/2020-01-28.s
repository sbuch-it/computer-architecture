.data
base:  .word 0
       .word 0
freep: .word 0
RTN:   .asciz "\n"
puneq: .asciz "p="

.globl main
.text
myfree:
#------------------------------------- 
# a0=ap,bp   t0=p, sizeof(Header)=8
	 addi a0, a0, -8  # bp=ap-8
	 la   t1,  freep  # &freep
	 lw   t0,  0(t1)  # t1=p=freep
MF_INIFOR1: #scan list of free blocks
	 slt  a6, t0, a0  # bp>?p
	 lw   t2, 0(t0)   # t2=p->ptr
	 slt  a5, a0, t2  # bp<?p->ptr
	 and  a4, a5, a6 
	 bne  a4, x0, MF_FINEFOR1
	 slt  a4, t0, t2  # p>=?p->ptr
                      # => !(p<?p->ptr)
	 not  a4, a4      #not(.)=> p<?p->ptr
	 or   a5, a5, a6  # (... || ...)
	 and  a4, a4, a5  # (... && (.))
	 bne  a4, x0, MF_FINEFOR1

	 add  t0, t2, x0  # p=p->ptr
	 j MF_INIFOR1

MF_FINEFOR1:     
	 lw   t3, 4(a0)   # bp->size
	 add  t4, t3, a0  # bp+bp->size
	 bne  t4, t2, MF_E1 # (.)!=p->ptr
	 lw   t5, 4(t2)   # p->ptr->size
	 add  t4, t3, t5  # bp->size+(.)
	 sw   t4, 4(a0)   # bp->size=(.)
	 lw   t5, 0(t2)   # p->ptr->ptr
	 sw   t5, 0(a0)   # bp->ptr=(.)
	 j MF_F1

MF_E1: 
	 sw   t2, 0(a0)   #bp->ptr=p->ptr

MF_F1: 
	 lw   t6, 4(t0)   # p->size
	 add  a4, t6, t0  # p+p->size
	 bne  a4, a0, MF_E2 # (.)!=bp
	 lw   a5, 4(a0)   # bp->size
	 add  t6, t6, a5  # p->size+(.)
	 sw   t6, 4(t0)   # p->size=(.)
	 lw   t6, 0(a0)   # bp->ptr
	 sw   t6, 0(t0)   # p->ptr=(.)
	 j MF_F2

MF_E2: 
	 sw   a0, 0(t0)   # p->ptr=bp

MF_F2: 
	 sw   t0, 0(t1)   # freep=p
	 jr ra
#-------------------------------------
# a0=sz,  v1=p 
alloc_and_print_pun:  
	 addi a7, x0, 9   # serv.9
	 ecall            # sbrk
	 add  a1, x0, a0  # salvo in a1
	 la   a0, puneq   # stampa msg
	 addi a7, x0, 4   # serv.4
	 ecall            # print_str
	 add  a0, x0, a1  # p
	 addi a7, x0, 1   # serv.1
	 ecall            # print_int
	 la   a0, RTN     # stampa RTN
	 addi a7, x0, 4   # serv.4
	 ecall            # print_str
	 add  a0, a1, x0  # return(p)
	 jr ra
#-------------------------------------
main:  #s2=p0, s3=p1, s4=p2, s5=p3
#-------------------------------------
# PROLOGO
	 addi sp, sp, -24  # alloco frame
	 sw   ra, 20(sp)   # salvo OLD-ra
	 sw   s0, 16(sp)   # salvo OLD-fp
	 add  s0, x0, sp   # NUOVO fp
	 sw   s5, 12(s0)   # salvo s5
	 sw   s4, 8(s0)    # salvo s4
	 sw   s3, 4(s0)    # salvo s3
	 sw   s2, 0(s0)    # salvo s2
	 la   t0, base     # &base
	 la   t1, freep    # &freep
	 sw   t0, 0(t0)    # base.ptr=&base
	 sw   t0, 0(t1)    # freep=&base
	 add  a0, x0, x0   # sz=0 (HEAPtop)
	 jal  alloc_and_print_pun
	 addi s2, a0, 0    # salva p0

	 addi a0, x0, 256  # sz=256
	 jal  alloc_and_print_pun
	 addi s3, a0, 0    # salva p1

	 addi a0, x0, 256  # sz=256
	 jal  alloc_and_print_pun
	 addi s4, a0, 0    # salva p2
 
	 addi a0, x0, 256  # sz=256
	 jal  alloc_and_print_pun
	 addi s5, a0, 0    # salva p3

	 add  a0, s3, x0   # p1
	 jal  myfree  
	 add  a0, s4, x0   # p2
	 jal  myfree
	 add  a0, s5, x0   # p3
	 jal  myfree
	 add  a0, x0, x0   # sz=0 (HEAPtop)
	 jal  alloc_and_print_pun
	 add  s2, a0, x0   # salva p0
 #-------------------------------------
# EPILOGO
	 lw   s2, 0(s0)    # ripristina s2
	 lw   s3, 4(s0)    # ripristina s3
	 lw   s4, 8(s0)    # ripristina s4
	 lw   s5, 12(s0)   # ripristina s5
	 lw   ra, 20(s0)   # ripristina ra
	 lw   s0, 16(s0)   # ripristina fp
	 addi sp, sp, 24   # DEALLOCO FRAME
	 addi a7, x0, 10   # serv.10
	 ecall             # exit