.data
a: .dword 12 23 34 45 56

.text
.globl main

binpacking:
   # a0=&a, a1=size, a2=n
   mv   a3, a0      # a3=&a
   mv   a4, a1      # a4=s=size
   li   a0, 1       # bincount=1
   li   t0, 0       # t0=i=0
for_ini:
   slt  t1, t0, a2  # i<?n
   beq  t1, x0, for_end # false-->
   slli t2, t0, 3   # offset(i)=i*8
   add  t2, a3, t2  # a+offset(i)
   ld   t3, 0(t2)   # *(a+i)
   sub  t4, a4, t3  # s - (.)
   slt  t1, x0, t4  # 0 <? (.)
   beq  t1, x0, if_else # false-->
   mv   a4, t4      # s = s - (.)
   b   for_next
if_else:
   addi a0, a0, 1
   mv   a4, a1      # a4=a1=size
   addi t0, t0, -1  # i--   
for_next:
   addi t0, t0, 1   # i++
   b    for_ini
for_end:
   ret

main:
   la   a0, a       # &a
   li   a1, 70
   li   a2, 5
   jal binpacking
   li   a7,1        # a0=b
   ecall            # print_int
   li   a7,10
   ecall            # exit
