	.data
spi:	.asciz "PI="
snl:	.asciz "\n"

	.text
	.globl main
picalc:
	fcvt.s.w fa5,a0 # (float)interv
	li	 t1,1       # 1
	fcvt.s.w fa1,t1     # fa1=(float)1
	
	fdiv.s	 fa6,fa1,fa5# fa6=dx=1/interv
	
	li       t1,4       # 4
	fcvt.s.w fa4,t1     # fa4=(float)4
	li       t1,2       # 2
	fcvt.s.w fa2,t1     # (float)2
	fdiv.s   fa2,fa1,fa2# fa2=0.5

	fcvt.s.w fa0,x0     # fa0=sum=0.0
		
	li	 t0,0       # i=0
for_ini:
	slt      t1,a0,t0   # interv<?i
	bne      t1,x0,for_end
	fcvt.s.w fa3,t0     # fa3=(float)i
	fsub.s fa5,fa3,fa2  # (i-0.5)
	fmul.s fa5,fa6,fa5  # dx*()
	fmul.s fa5,fa5,fa5  # x*x
	fadd.s fa5,fa5,fa1  # x*x+1.0
	fdiv.s fa5,fa4,fa5  # (4.0/()
	fadd.s fa0,fa0,fa5  # sum+=f
	addi   t0,t0,1      # i++
	b      for_ini
for_end:
	fmul.s fa0,fa6,fa0  # pi=dx*sum
	ret

main:
	li	a0,1000
	jal	picalc  # risultato in fa0
	la	a0,spi
	li	a7,4	# print_string
	ecall		# print "PI="
	li	a7,2	# print_float (fa0)
	ecall		# print 3.1455932
	la	a0,snl
	li	a7,4	# print_string
	ecall		# print "\n"
	li	a7,10   # exit
	ecall