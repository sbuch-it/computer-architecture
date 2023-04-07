.text
.globl main
hada1:
        mv       a6,a0      # l
        fmv.s.x  fa5,zero   # fa5=0.0
        fcvt.s.w fa4,a6     # (float)l
        fsqrt.s  fa3,fa4    # fa4=m=sqrt(l)
    
        mulw     a0,a6,a6   # l*l
        slli     a0,a0,2    # * sizeof(float)
        li	 a7,9       # sbrk
        ecall               # a0=&H
        
        add      t0,x0,x0   # i=0
h1_fori_start:
	slt      t6,t0,a6   # i<?l
	beq      t6,x0,h1_fori_end
	
	add      t1,x0,x0   # j=0
h1_forj_start:
	# prepara &H[i,j]
	mul	 t6,t0,a6   # i*l
	add	 t6,t6,t1   # i*l+j
	slli     t6,t6,2    # 4*(i*l+j)
	add      a5,t6,a0   # a5=&H[i,j]

	slt	 t6,t1,a6   # j<?l
	beq	 t6,x0,h1_forj_end
h1_if1:
	bne      t0,x0,h1_else# i!=0: h1_else
	bne	 t1,x0,h1_else# k!=0: h1_else
	li	 t6,1       # t6=1
	fcvt.s.w fa1,t6     # fa1=(float)1.0
	fdiv.s   fa2,fa1,fa3# fa1=1.0/sqrt(l)

	fsw      fa2,0(a5)  # H[i,j]=(.)
	b        h1_end_else
h1_else:
	add      t2,x0,x0   # k=0
h1_fork_start:
	slti	 t6,t2,11   # k<=?10
	beq	 t6,x0,h1_fork_end
#---- h1_fork body_start
	li	 t5,1
	sll	 t5,t5,t2   # t5=t=1<<k
h1_if2:
	slt      t6,t0,t5   # i<?t
    	bne      t6,x0,h1_if2_end
	slt      t6,t1,t5   # j<?t
	beq      t6,x0,h1_if2_end
		
	sub      t6,t0,t5   # i-t
	mul      t6,t6,a6   # (i-t)*l
	add      t6,t6,t1   # (i-t)*l+j
	slli     t6,t6,2    # 4*(.)
	add	 t6,t6,a0   # &H[i-t,j] 
	flw      fa2,0(t6)  # H[.]
	fsw	 fa2,0(a5)  # H[i,j]=(.)
h1_if2_end:
#---- h1_fork body_end
	addi	 t2,t2,1    # ++k
	b	 h1_fork_start
h1_fork_end:
h1_end_else:
	addi	 t1,t1,1    # ++j
	b	 h1_forj_start
h1_forj_end:	
	addi	 t0,t0,1    # ++i
	b        h1_fori_start
h1_fori_end:
        ret                 # a0=&H
        
main:
        fmv.s.x fa0,zero    # s = 0
        li      a0,4        # a0=N=4
        call    hada1       # returns &H
        addi    a5,a0,64    # end of H (next-byte)
main_for:
        flw     fa4,0(a0)   # H[k}
        fadd.s  fa0,fa0,fa4 # s+=H[k]
        addi    a0,a0,4     # update k*4
        bne     a0,a5,main_for
        li	a7,2        # print_float
        ecall
	li	a7,10	    # exit
	ecall
