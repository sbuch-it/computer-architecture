.data
c: .asciz "Architettura dei Calcolatori"

.text
.globl main

i4modp:
   rem a0,a0,a1     # a0=v = i%j
   slt t1,t0,x0     # v<?0
   beq t1,x0,i4modp_if_end
   add a0,a0,a1     # v+=j
i4modp_if_end:
   ret

caesar1:
   addi sp,sp,-20    #alloca stack
   sw   ra,0(sp)    # save ra
   sw   s0,4(sp)    # save s0=k
   sw   s1,8(sp)    # save s1=s
   sw   s2,12(sp)   # save s2=c
   sw   s3,16(sp)   # save s3=*c
   
   mv   s2,a1       # s2=c
   mv   s1,a0       # s1=s
   li   s0,7        # s0=k = 7
   
c1_wh_ini:
   li   t1,'A'      # t1='A'
   lb   s3,0(s2)    # *c
   beq  s3,x0,c1_wh_end # *c==0 -->
   
   slt  t0,s3,t1   # *c<?'A'
   bne  t0,x0,c1_else1
   addi t2,t1,25   # 'A'+25
   slt  t0,t2,s3   # 'A'+25<?*c
   bne  t0,x0,c1_else1
   
   add  a0,s3,s0   # *c+k
   sub  a0,a0,t1   # (.)-'A'
   li   a1,26      # secondo param.
   jal  i4modp
   addi a0,a0,'A'  # risultato+'A'
   sb   a0,0(s1)   # *s=(.)
   b    c1_if_end
   
c1_else1:
   li   t1,'a'     # t1='a'
   slt  t0,s3,t1   # *c<?'a'
   bne  t0,x0,c1_else2
   addi t2,t1,25   # 'a'+25
   slt  t0,t2,s3   # 'a'+25<?*c
   bne  t0,x0,c1_else2

   add  a0,s3,s0   # *c+k
   sub  a0,a0,t1   # (.)-'a'
   li   a1,26      # secondo param.
   jal  i4modp
   addi a0,a0,'a'  # risultato+'a'
   sb   a0,0(s1)   # *s=(.)
   b    c1_if_end

c1_else2:
   sb s3,0(s1)     # *s = *c;

c1_if_end:
   addi s2,s2,1     # ++c
   addi s1,s1,1     # ++s
   b c1_wh_ini
c1_wh_end:
   sb  x0,0(s1)     # *s='\0'
   
   lw   s3,16(sp)   # ripristina reg.s
   lw   s2,12(sp)
   lw   s1,8(sp)
   lw   s0,4(sp)
   lw   ra,0(sp)    # ripristina ra
   addi sp,sp,20   # ripristina stack
   ret

main:
   addi  sp,sp,-32  # alloca s nello stack
   mv    a0,sp      # primo param.
   la    a1,c       # second param.
   jal   caesar1
   mv    a0,sp      # primo param.
   li    a7,4
   ecall            # print the string
   li    a7,10
   ecall            # exit
   addi  sp,sp+32   # ripristina stack