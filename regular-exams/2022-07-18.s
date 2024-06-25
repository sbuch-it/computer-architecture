.data
mat: .space 2048

.text
.globl main
transpose:
    la   a0,mat       # &mat
    li   a1,16        # MATSIZE
    li   t0,0         # i=0
tr_for1_ini:
    slt  t3,t0,a1     # i<?MATSIZE
    beq  t3,zero,tr_for1_end # false->end
    #----- for1-body start
    addi t1,t0,1      # j=i+1
tr_for2_ini:
    slt  t3,t1,a1     # j<?MATSIZE
    beq  t3,zero,tr_for2_end # false->end
    #----- for2-body start
    #calc &mat+(i*128+j)*4
    slli t4,t0,4      # i*MATSIZE
    add  t4,t4,t1     # i*MTATSIZE+j
    slli t4,t4,3      # (.)*8
    add  t4,a0,t4     # &mat[i][j]
    #calc &mat+(j*128+i)*4
    slli t5,t1,4      # j*MATSIZE
    add  t5,t5,t0     # j*MATSIZe+i
    slli t5,t5,3      # (.)*8
    add  t5,a0,t5     # &mat[j][i]

    ld   a2,0(t4)     # temp=mat[i][j]
    ld   a3,0(t5)     # temp2=mat[j][i]
    sd   a3,0(t4)     # mat[i][j]=temp2
    sd   a2,0(t5)     # mat[j][i]=temp
   
    #----- for2-body end
    addi t1,t1,1      # ++j
    b    tr_for2_ini
tr_for2_end:  
    #----- for1-body end
    addi t0,t0,1      # ++i
    b    tr_for1_ini
tr_for1_end:
    ret

main:
    addi sp,sp,-8     # allocate frame
    sd   s0,0(sp)     # save s0
    
    la   a0,mat       # &mat
    li   a1,16        # MATSIZE
    li   t0,0         # i=0
for1_ini:
    slt  t3,t0,a1     # i<?MATSIZE
    beq  t3,zero,for1_end # false->end
    #----- for1-body start
    li   t1,0         # j=0
for2_ini:
    slt  t3,t1,a1     # j<?MATSIZE
    beq  t3,zero,for2_end # false->end
    #----- for2-body start
    #calc &mat+(i*128+j)*4
    slli t4,t0,4      # i*MATSIZE
    add  t4,t4,t1     # i*MATSIZE+j
    slli t4,t4,3      # (.)*8
    add  t4,a0,t4     # &mat[i][j]
    add  t5,t0,t1     # i+j
    sd   t5,0(t4)     # mat[i][j]=i+j
   
    #----- for2-body end
    addi t1,t1,1      # ++j
    b    for2_ini
for2_end:  
    #----- for1-body end
    addi t0,t0,1      # ++i
    b    for1_ini
for1_end:

    li   s0,0         # k=0
for3_ini:
    slti t3,s0,10     # k<?10
    beq  t3,zero,for3_end # false->end
    #----- for3-body start
    jal transpose
    #----- for3-body end
    addi s0,s0,1      # ++i
    b    for3_ini
for3_end:

    li   t0,0         # i=0
    li   a0,0         # r=0
    li   a1,16        # MATSIZE
    la   a2,mat       # &mat

for4_ini:
    slt  t3,t0,a1     # i<?MATSIZE
    beq  t3,zero,for4_end # false->end
    #----- for4-body start
    #calc &mat+(0*MATSIZE+i)*8
    slli t4,zero,4    # 0*MATSIZE
    add  t4,t4,t0     # 0*MATSIZE+i
    slli t4,t4,3      # (.)*8
    add t4,a2,t4      # &mat[0][i]
    ld   t5,0(t4)     # mat[0][i]
    add a0,a0,t5      # r=r+(.)
    
    #----- for4-body end
    addi t0,t0,1      # ++i
    b    for4_ini
for4_end:
    li   a7,1         # print_int
    ecall

    ld   s0,0(sp)     # restore s0
    addi sp,sp,8      # free frame

    li   a7,10        # exit
    ecall