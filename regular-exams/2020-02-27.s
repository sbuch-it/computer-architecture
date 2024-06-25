
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
   sw ra, 0(sp)   # salva ra perche' usa altra f.
   sw s0, 4(sp)   # salva fp perche' usa frame
   add s0, sp, x0
   add a0, x0, x0   # j = 1
   addi t0, x0, 1   # costante f.p. 1
   addi t2, x0, 1
   fcvt.s.w fa1, t2   # costante f.p. 0
   addi t2, x0, 0
   fmv.s.x fa0, t2   # la codifica di 0.0 e' 0...0
while_ini: 

   slt t2, a1, t0   # j>?n
   bne t2, x0 while_end   # se si while_end
   add t1, x0, x0   # k = 0
for_ini: 

   slt t2, t1, a1   # k<?n
   beq t2, x0 for_end   # j -1
   addi t3, t0, -1
   add t2, t3, t3
   add t2, t2, t3   # (j-1)*3
   add t2, t2, t1   # (j-1)*3+k
   slli t2,t2, 2   # *4
   add t2, t2, a3  # &T[j-1][k]
   flw fa2, 0(t2)   # == 0.0
   feq.s t5,fa2,fa0
   bne t5, x0, ramo_else
   sw a3, 8(s0)   # salva a3
   sw a0, 12(s0)   # salva a0
   sw t0, 16(s0)   # salva t0
   sw t1, 20(s0)   # salva t1
   fneg.s fa2, fa2   # cambio segno
   fmul.s fa2, fa2, fa2 #fa2=(.)*()
   lw t1, 20(s0)   # salva t1
   lw t0, 16(s0)   # salva t0
   lw a0, 12(s0)   # ripristina a0
   lw a3, 8(s0)   # ripristina a3
   fdiv.s fa2, fa1, fa2   # 1/sqr(-T[][])
   flw ft0, 0(a2)   # *nc
   fadd.s ft0, ft0, fa2   # +=
   fsw ft0, 0(a2)   # *nc=
   j if_end
ramo_else: 
   # r = 1
   addi a0, x0, 1
if_end: 
   # ++k
   addi t1, t1, 1
   j for_ini
for_end: 
   # ++j
   addi t0, t0, 1
   j while_ini
while_end: 

   lw ra, 0(s0)
   lw s0, 4(s0)
   addi sp, sp, 24   # ritorna a0
   ret
main: 
   # param.1
   la a3,  A   # param.2
   addi a1, x0, 3   # param.3
   la a2,  f
   jal num_cond

   add s0, a0, x0   #print "esi...
   la a0,  esi
   addi a7,x0,4
   ecall
   add a0, s0, x0   # ripristina ec
   addi a7,x0,1
   ecall   # print "nco...
   la a0,  nco
   addi a7,x0,4
   ecall   # print f
   la a0,  f
   flw fa0, 0(a0)
   addi a7,x0,2
   ecall   # print ret
   la a0,  ret
   addi a7,x0,4
   ecall   # exit

   addi a7,x0,10
   ecall
