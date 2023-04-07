.data
X: .space 4
L: .space 4
.text
.globl main
hilb1:
    mv       a6,a0      # n
    mulw     t0,a6,a6   # n*n
    slli     a0,t0,2    # * sizeof(float)
    li	 a7,9           # sbrk
    ecall               
    mv       a1,a0      # a1=&L
    la       t6,L       # &L
    sw       a1,0(t6)   # store &L
    slli     a0,t0,2    # * sizeof(float)
    li	 a7,9           # sbrk
    ecall               # a0=&X
    la       t6,X       # &X
    sw       a0,0(t6)   # store &X
    #fori
    add      t0,x0,x0   # i=0
h1_fori_start:
	slt      t6,t0,a6   # i<?n
	beq      t6,x0,h1_fori_end
	# f = (float) 1 / (i + 1)
	addi     t6,t0,1    # i+1
	fcvt.s.w ft0,t6     # (float)(.)
	li       t6,1       # 1
	fcvt.s.w ft1,t6     # (float)1
	fdiv.s   ft9,ft1,ft0# f=1/(i+1)
	# forj
	add      t1,x0,x0   # j=0
h1_forj_start:
	slt      t6,t1,a6   # j<?n
	beq      t6,x0,h1_forj_end
	# prepara &X[i,j]
	mul	 t6,t0,a6       # i*n
	add	 t6,t6,t1       # l=i*n+j
	slli     t6,t6,2    # 4*(i*n+j)
	add      a5,t6,a0   # a5=&X[i,j]
    # prepara &L[i,j]
	add	 a4,t6,a1       # a4=&L[i,j]
	# prepara valore da assegnare
	add      t6,t0,t1   # i+j
	addi     t6,t6,1    # i+j+1
	fcvt.s.w ft0,t6     #(float)(.)
    mul      t6,a6,a6   # n*n
    fcvt.s.w ft1,t6     # (float)(.)
    fdiv.s   ft2,ft1,ft0# (n*n)/(i+j+1)
    fmul.s   ft3,ft1,ft2# (n*n)*(.)   
    # assegna valori
    fsw      ft3,0(a5)  # X[i,j]=(.)
    sw       x0,0(a4)   # L[i,j]=0
    # if (i>=j) {
	slt	 t6,t1,a6       # j<?l
	beq	 t6,x0,h1_end_if
h1_if1:
	sub      t6,t0,t1   # i-j
    addi     t6,t6,1    # i-j+1  
    fcvt.s.w ft4,t6     # float(.)
	fdiv.s   ft5,ft4,ft0# (.)/(i+j+1)
	fmul.s   ft9,ft9,ft5# f*(.)
	add      t6,t1,t1   # 2*j
	addi     t6,t6,1    # 2*j+1
	fcvt.s.w ft6,t6     # (float)(.)
	fsqrt.s  ft6,ft6    # sqrt(.)
	fmul.s   ft6,ft1,ft6# n*n*(.)
	fmul.s   ft6,ft6,ft9# (.)*f
	fsw      ft6,0(a4)  # L[i,j]=(.)
h1_end_if:
	addi	 t1,t1,1    # ++j
	b	 h1_forj_start
h1_forj_end:	
	addi	 t0,t0,1    # ++i
	b        h1_fori_start
h1_fori_end:
        ret
        
main:
	addi    sp,sp,-4
	fsw     fs0,0(sp)   # save fs0
    fmv.s.x fs0,zero    # s=fs0 = 0
    li      a0,4        # a0=4
    call    hilb1
        
    la      a0,L        # &L
    la      a1,X        # &X       
    lw      a4,0(a0)    # *L
    lw      a5,0(a1)    # *X
    li      t0,0        # t0=k = 0
main_for_ini:
	slti    t1, t0, 16
	beq     t1, x0, main_for_end
	
    flw     ft0,0(a4)   # L[k}
    flw     ft1,0(a5)   # X[k]
    fadd.s  fs0,fs0,ft0
    fadd.s  fs0,fs0,ft1
    addi    a4,a4,4     # next elem
    addi    a5,a5,4     # next elem
      
    addi    t0,t0,1     # ++k
    b       main_for_ini
main_for_end:
    fmv.s   fa0,fs0     # fa0=s
    li	a7,2            # print_float
    ecall
	li	a7,10	        # exit
	ecall
	flw     fs0,0(sp)
	addi    sp,sp,4
