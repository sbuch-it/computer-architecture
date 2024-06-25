.data
A: .float 1, 2, 3, 4, 5, 6, 7, 8, 8
al: .float 7.0
be: .float 3.0
.text
.globl main
#float *ssyrk(float *A, float *C, float alpha, float beta, int n) {
ssyrk: #a0=&A, a1=&C, a2=n, fa0=alpha, fa1=beta
    # int i, j, p; float temp;
    # t0=i, t1=j, t2=p, ft0=temp
    li   t1,0         #j=0
for1_ini:
    slt  t3,t1,a2     # j<?n
    beq  t3,zero,for1_end # false->end
    #----- for1-body start
    li   t0,0         # i=0
for2_ini:
    slt  t3,t0,a2     # i<?n
    beq  t3,zero,for2_end # false->end
    #----- for2-body start
    fmv.s.x ft0,zero  # temp=0.0
    li   t2,0         # p=0
for3_ini:
    slt  t3,t2,a2     # p<?n
    beq  t3,zero,for3_end # false->end
    #----- for3-body start
    #calc &A+(p*n+i)*4
    mul t4,t2,a2      # p*n
    add t4,t4,t0      # p*n+i
    slli t4,t4,2      # (.)*4
    add t4,a0,t4      # &A(p,i)
    flw ft1,0(t4)     # A(p,i)
    #calc &A+(p*n+j)*4
    mul t4,t2,a2      # p*n
    add t4,t4,t1      # p*n+j
    slli t4,t4,2      # (.)*4
    add t4,a0,t4      # &A(p,j)
    flw ft2,0(t4)     # A(p,j)
    fmul.s ft1,ft1,ft2# A(p,i) * A(p,j)
    fadd.s ft0,ft0,ft1# temp += (.)     
    #----- for3-body end
    addi t2,t2,1      # ++p
    b    for3_ini
for3_end:
    #calc &C+(i*n+j)*4
    mul t4,t0,a2      # i*n
    add t4,t4,t1      # p*n+j
    slli t4,t4,2      # (.)*4
    add t4,a1,t4      # &C(i,j)
    flw ft1,0(t4)     # C(i,j)
    fmul.s ft1,ft1,fa1# (.)*beta
    fmul.s ft2,fa0,ft0# alpha*temp
    fadd.s ft1,ft1,ft2# (..)+(.)
    fsw ft1,0(t4)     # C(i,j)=(.)
    #----- for2-body end
    addi t0,t0,1      # ++i
    b    for2_ini
for2_end:  
    #----- for1-body end
    addi t1,t1,1      # ++j
    b    for1_ini
for1_end:
    mv   a0,a1        # a0=&C
    ret

main:
    li      a0,3      # n
    mul     a0,a0,a0  # n*n
    slli    a0,a0,2   # n*n *4 (4=sizeof(float))
    li      a7,9      # sbrk
    ecall             # allocate 36 bytes
    mv      a1,a0     # 2nd param. = &C
    la	  a0,A        # 1st param. = &A
    la      t0,al     # &alpha
    flw     fa0,0(t0) # 3rd param. alpha=3.0
    la      t0,be     # &beta
    flw     fa1,0(t0) # 4th param. beta=7.0
    li      a2,3      # 5th param. n=3
    jal     ssyrk     # returns &C in a0
    li      a2,3      # n=3
    li      t0,2     
    mul     t0,t0,a2  # 2*n
    addi    t0,t0,2   # 2*n+2
    slli    t0,t0,2   # (.) *4 (4=sizeof(float))
    add     t0,a0,t0  # &C(2,2)
    flw     fa0,0(t0) # C(2,2)
    li      a7,2      # print_float
    ecall
    li      a7,10
    ecall