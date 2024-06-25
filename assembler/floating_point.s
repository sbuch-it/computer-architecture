.data
EPSILON:  .float 0.0001
A:        .float  4.0, -1.0, -1.0
          .float -2.0,  6.0,  1.0
          .float -1.0,  1.0,  7.0
B:        .float  3.0,  9.0, -6.0
e2:       .space 4
x:        .space 12
y:        .space 12
c:        .space 12
R:        .space 36
T:        .space 36
iter:     .word 0
x_str:    .asciz "X: "
spazio:   .asciz " "
iter_str: .asciz " - iter ="
e_str:    .asciz "      e2="
ret:      .asciz "\n"

.text

setup: 
#________NO CALL FRAME___________
# t2=i, t3=j, t4=k, ft0=t, t5=i*N

li      t6, 3        # N 
la      a4, x        # &x
la      a5, A        # &A
la      a6, T        # &T
li      t2, 0        # t2=i=0

Setup_start_for1: 
   slti    t0, t2, 3    # i <? N  (=3)
   beq     t0, x0, Setup_end_for1
   #__________________________________
   mul     t5, t2, t6   # t5=i*N
   slli    t0,t2, 2     # i*sizeof(float)
   add     t1, a4, t0   # &x[i]
   sw      x0, 0(t1)    # x[i]=0.0
   add     t3, x0, x0   # t3=j=0
   Setup_start_for2: 
      slti    t0, t3, 3 # j <? N  (=3)
      beq     t0, x0, Setup_end_for2   
      #__________________________________
      fmv.s.x fa0, x0   # t=0
	  
      #if1
	  slt     t0, t3, t2   # j <? i
      beq     t0, x0, Setup_fine_if1
      add     t4, t3, x0   # t4=k=j
      Setup_start_for3: 
         slt     t0, t4, t2   # k <? i
         beq     t0, x0, Setup_end_for3   
         #_______________________________
         add     t0, t5, t4   # i*N+k
         slli    t0,t0, 2 #*sizeof(float)
         add     t1, a5, t0   # &A[i,k]
         flw     fa2, 0(t1)   # k*N
         mul     t0, t4, t6   # t0=k*N
         add     t0, t0, t3   # k*N+j
         slli    t0,t0, 2 #*sizeof(float)
         add     t1, a6, t0   # &T[k,j]
         flw     ft1, 0(t1)   # f4=T[k,j]
         fmul.s  ft3, fa2, ft1# f6=f2*f4
         fsub.s  fa0, fa0, ft3# ++k
         #_______________________________
         addi    t4, t4, 1
         j Setup_start_for3
      Setup_end_for3: 
      Setup_fine_if1: 

      #if2
      bne      t2, t3, Setup_fine_if2   
      #__________________________________
      li       t0, 1
      fcvt.s.w fa0, t0   
      #__________________________________
      Setup_fine_if2: 

      #if3
      slt      t0, t2, t3   # i <? j
      beq     t0, x0 Setup_else_if3   
      #__________________________________
      fmv.s.x fa4, x0       # fa4=0.0
      j Setup_fine_if3   
      #__________________________________
      Setup_else_if3: 
      #__________________________________
      add     t0, t5, t2    # t0=i*N+i
      slli    t0,t0, 2   # i*sizeof(float)
      add     t1, a5, t0    # &A[i,k]
      flw     fa2, 0(t1)    # A[i,i]
      fdiv.s  fa4, fa0, fa2   
      #__________________________________
      Setup_fine_if3: 

      add     t0, t5, t3 # t0=i*N+j
      slli    t0,t0, 2   #i*sizeof(float)
      add     t1, a6, t0 # &T[i,j]
      fsw     fa4, 0(t1) # T[i,j]=fa4
      #__________________________________
      addi    t3, t3, 1   # ++j
      j Setup_start_for2
   Setup_end_for2: 
   #__________________________________ 
   addi    t2, t2, 1 # ++i
   j Setup_start_for1
Setup_end_for1: 
   
la      a4,  B       # &B
add     t2, x0, x0   # t2=i=0
Setup_start_for4:
   slti    t0, t2, 3    # i <? N(3)
   beq     t0, x0 Setup_end_for4
   #__________________________________
   mul     t5, t2, t6   # t5=i*N
   add     t3, x0, x0   # t3=j=0
   Setup_start_for5: 
      slti    t0, t3, 3    # j <? N(3)
      beq     t0, x0 Setup_end_for5   
      #__________________________________
      fmv.s.x fa0, x0      # t=0
      add     t4, x0, x0   # t4=k=0
      Setup_start_for6: 
         slti    t0, t4, 3    # k <? N(3)
         beq     t0, x0 Setup_end_for6   
         #_______________________________
         #if4
         slt     t0, t4, t3   # k <? j
         beq     t0, x0 Setup_end_if4   
         #_______________________________
         add     t0, t5, t4   # i*N+k
         slli    t0,t0, 2 #*sizeof(float)
         add     t1, a6, t0   # &T[i,k]
         flw     fa2, 0(t1)   # k*N
         mul     t0, t4, t6
         add     t0, t0, t3   # k*N+j
         slli    t0,t0, 2#*sizeof(float)
         add     t1, a5, t0   # &A[i,k]
         flw     ft1, 0(t1)   # A[i,k]
         fmul.s  ft3, fa2, ft1# fa2*ft1
         fadd.s  fa0, fa0, ft3   
         #_______________________________
         Setup_end_if4: 
         #_______________________________
         addi    t4, t4, 1    # ++k
         j Setup_start_for6
      Setup_end_for6: 
      add     t0, t5, t3  # t0=i*N+j
      slli    t0,t0,2   # i*sizeof(float)
      la      t1,  R      # &R
      add     t1, t1, t0  # &R[i,j]
      fsw     fa0, 0(t1)  # R[i,j]=t
	  #__________________________________
      addi    t3, t3, 1   # ++j
      j Setup_start_for5
   Setup_end_for5: 

   fmv.s.x  fa0, x0     # t=0
   add      t4, x0, x0  # t4=k=0
   Setup_start_for7: 
      slti     t0, t4, 3   # k <? N(3)
      beq      t0, x0 Setup_end_for7   
      #__________________________________
      slli     t0,t4,2  # k*sizeof(float)
      add      t1, a4, t0  # &B[k]
      flw      fa2, 0(t1)  # f2=B[k]
      add      t0, t5, t4  # i*N+k
      slli     t0,t0, 2 # *sizeof(float)
      add      t1, a6, t0  # &T[i,k]
      flw      ft1, 0(t1)  # f4=T[i,k]
      fmul.s   ft3, fa2, ft1# f6=f2*f4
      fadd.s   fa0, fa0, ft3# ++k
      #__________________________________
      addi     t4, t4, 1
      j Setup_start_for7
   Setup_end_for7: 
   slli     t0,t2, 2    # i*sizeof(float)
   la       t1,  c      # &c
   add      t1, t1, t0  # &c[i]
   fsw      fa0, 0(t1)   
   #__________________________________
   addi     t2, t2, 1
   j Setup_start_for4
Setup_end_for4: 
ret
#--------------------------------------
seidel2: 
#________NO CALL FRAME___________
# INPUT: a0=*x,a1=*y,a2=*a,fa0=c,t0=j

fsw     fa0, 0(a0)   # store c into *x

li      t0, 0        # t0=j=0
Seidel2_start_for1:
   slti    a6, t0, 3    # j<?N  (=3)
   beq     a6, x0, Seidel2_end_for1
   #_______________________________
   slli    t3,  t0,  2  # j*sizeof(float)
   add     t4,  t3,  a2 # &a[j]
   flw     ft0, 0(t4)   # load a[j]
   add     t4,  t3,  a1 # &y[j]
   flw     ft1, 0(t4)   # load y[j]
   fmul.s  ft2, ft0, ft1# (a[j]*y[j])
   flw     ft3, 0(a0)   # load *x
   fsub.s  ft3, ft3, ft2# [(*x)-(.)]
   fsw     ft3, 0(a0)   # store [.]
   #_______________________________
   addi    t0, t0, 1    # ++j
   b Seidel2_start_for1
Seidel2_end_for1:
ret

report: 
#________NO CALL FRAME___________
# TEMP: i=t0
la      a0,  x_str   # print "X: "
li      a7,4         # print_string
ecall

li      t0, 0           # t0=i=0
Report_start_for1: 
   slti    t1, t0, 3    # i <? N
   beq     t1, x0, Report_end_for1 
   #_______________________________
   slli    t3, t0, 2    #i*sizof(float)
   la      t4, x        # t4=&x
   add     t4, t4, t3   # t4= x[i]
   flw     fa0, 0(t4)   # load x[i]  
   addi    a7, x0, 2    # print_float
   ecall
   la      a0, spazio   # & " "
   li      a7, 4        # print_string
   ecall  
   #_______________________________
   addi    t0, t0, 1    # ++i
   j Report_start_for1
Report_end_for1: 

la     a0,  iter_str   # & " - iter="
li     a7,4            # print_string
ecall

la     t0,  iter       # &iter
lw     a0, 0(t0)       # load iter
li     a7,1            # print_int
ecall

la     a0,  e_str      # & " e2="
li     a7,4            # print_string
ecall

la     t0,  e2         # &e2
flw    fa0, 0(t0)      # load e2
li     a7,2            # print_float
ecall

la     a0,  ret        # & "\n"
li     a7,4            # print_string
ecall

ret


test_convergence: 
#________CALL FRAME___________
# ra                        4B
# s0                        4B
#___________________Totale  8B
# uso r=s0,  j=t0
addi   sp, sp, -8
sw     ra, 0(sp)
sw     s0, 4(sp)     # r

la     t0, iter      # &iter
lw     t1, 0(t0)     # load iter
addi   t1, t1, 1     # ++iter
sw     t1, 0(t0)     # store iter

la     t0, e2        # &e2
sw     x0, 0(t0)     # store e2=0

li     t0, 0         # t0=j=0
Test_Converg_start_for: 
   slti   a6, t0, 3  # j <? N  (=3)
   beq    a6, x0, Test_Converg_end_for
   #_______________________________
   la     t2,  x       # &x
   la     t3,  y       # &y
   slli   t5, t0, 2    # j*sizeof(float)
   add    t2, t2, t5   # &x[j]
   flw    ft0, 0(t2)   # load x[j]
   add    t3, t3, t5   # &y[j]
   flw    ft1, 0(t3)   # load y[j]   
   fsub.s ft1, ft1, ft0# (y[]-x[])
   fmul.s ft1, ft1, ft1# [(.)*(.)]
   la     t6,  e2      # &e2
   flw    ft2, 0(t6)   # load e2
   fadd.s ft2, ft2, ft1# e2+[.]
   fsw    ft2, 0(t6)   # store e2
   #_______________________________
   addi   t0, t0, 1    # ++j
   j Test_Converg_start_for
Test_Converg_end_for: 

la     t6,  e2       # &e2
flw    ft2, 0(t6)    # load  e2
la     t0,  EPSILON  # & EPSILON
flw    ft1, 0(t0)    # load EPSILON
fmul.s ft1, ft1, ft1 # EPSILON*EPSILON

li     s0, 0         # r=0
flt.s  t0,ft2,ft1    # e2 < EPSILON*EPSILON
beq    t0, x0, Test_Converg_c1_f
    #_______________________________
	li     s0, 1      # r=1 
	#_______________________________
Test_Converg_c1_f: 

la    t0,  iter      # & iter
lw    t0, 0(t0)      # load iter
li    t1, 20         # MAXITER (=20)
bne   t0, t1, Test_Converg_c2_end #iter==?MAXITER
    #_______________________________
	li    s0, 1       # r=1
    #_______________________________
Test_Converg_c2_end:

jal report

mv    a0,s0          # a0=r=s0

lw    ra, 0(sp)
lw    s0, 4(sp)
addi  sp, sp, 8
ret

compute: 
#________CALL FRAME___________
# ra                        4B
# saved variables: s0       4B
#____________________Totale 8B
# TEMP: i=s0
addi  sp, sp, -8
sw    ra, 0(sp)
sw    s0, 4(sp)

Compute_start_do:
   li     s0, 0     # s0=i=0
   Compute_start_for_1: 
   slti   t1, s0, 3 # i <? N
   beq    t1, x0, Compute_end_for_1   
      #___________________
      slli   t3, s0, 2 # t3=i*sizeof(float)
      la     a0, y     # &y
      add    a0, a0, t3# a0=&y[i]   
   
      la     a1, x     # &x 
	  
      li     t1, 3     # t1=N  (=3)   
      mul    t0, t1, t3# (N*i*sizeof(float))
      la     a2,  R    # &R
      add    a2, a2, t0# &R[(.)]   
   
      la     t4,  c    # t4=&c
      add    t4, t4, t3# t4=&c[i]
      flw    fa0, 0(t4)# load c[i]  
   
      jal    seidel2
      #___________________
      addi   s0, s0, 1 # ++i
      j Compute_start_for_1     
   Compute_end_for_1: 
   
   li     s0, 0      # s0=i=0
   Compute_start_for_2: 
   slti   t1, s0, 3  # i <? N
   beq    t1, x0, Compute_end_for_2   
      #___________________
      slli   t3, s0, 2 # t3=i*sizeof(float)
      la     a0, x     # &x
      add    a0, a0, t3# a0=&x[i]   
   
      la     a1, y     # &y 
	  
      li     t1, 3     # t1=N  (=3)   
      mul    t0, t1, t3# (N*i*sizeof(float))
      la     a2,  R    # &R
      add    a2, a2, t0# &R[(.)]   
   
      la     t4,  c    # t4=&c
      add    t4, t4, t3# t4=&c[i]
      flw    fa0, 0(t4)# load c[i]  
   
      jal    seidel2
      #___________________
      addi   s0, s0, 1 # ++i
      j Compute_start_for_2     
   Compute_end_for_2:    

   jal test_convergence # Output:a0
   beq a0, x0, Compute_start_do
Compute_end_do: 

lw     ra, 0(sp)
lw     s0, 4(sp)
addi   sp, sp, 8
ret


.globl main
main:
#_________NO CALL FRAME______
jal   setup
jal   compute
jal   report
li    a7,10  # chiamo exit
ecall