.data
X:	.space	800		# 200 interi
Z:	.space	800		# 200 interi
nl:	.asciz "\n"		# new-line

.text
.globl main

Loop3:
	# a3=a0=n, a1=X, a2=Y
	# t0=i, new a0=Q
	# t1=tmp, t2=tmp
	mv	a3,a0		# n
	li 	a0, 0		# Q=0
	li	t0, 0		# i=0
l1:
	slt	t2, t0, a3	# t2=(i<n)
	beq	t2, zero, endl1	# Condizione falsa -> termine ciclo
	slli	t1, t0, 2  	# t1=i<<2 (=i*4)
	add	t2, a1, t1	# t2=&X[i]
	lw	t2, 0(t2)	# t2=X[i]
	add	t3, a2, t1	# t3=&Y[i]
	lw	t3, 0(t3) 	# t3=Y[i]
	mul  	t4,t2, t3	# t4=X[i]*Y[i] (su 32 bit)
	add  	a0, a0, t4	# Q+=X[i]*Y[i]
	addi 	t0, t0, 1	# i++
	b	l1		# Ripeti il ciclo
endl1:
	ret			# Esci da funzione

main:
	# s0=n, s1=k, s2=i, s3=V, s4=X, s5=Z
	# t0=tmp, t2=222
	la	s4, X		# s4=&X[0]
	la	s5, Z		# s5=&Z[0]
	li	s0, 100		# n=100
	li	s3, 0		# V=0
	li	t2, 222		# t2=222
	li	s1, 0		# k=0
l2:
	slt	t0, s1, s0	# t0=(k<n)
	beq	t0, zero, endl2	# Condizione falsa -> termine ciclo
	slli	t0, s1, 2	# t0=k<<2 (=k*4)
	add	t1, s4, t0	# t1=&X[k]
	sw	t2, 0(t1)	# X[k]=222
	add	t1, s5, t0	# t1=&Z[k]
	sw	t2, 0(t1)	# Z[k]=222
	addi	s1, s1, 1	# k++
	b	l2		# Ripeti il ciclo
endl2:
	li	s2, 0		# i=0
l3:
	slt	t0, s2, s0	# t0=i<n
	beq	t0, zero, endl3	# Condizione falsa -> termine ciclo
	mv	a0, s0		# I argomento per Loop3
	mv	a1, s4		# II argomento per Loop3
	mv	a2, s5		# III argomento per Loop3
	jal	Loop3		# Loop3(n,X,Z)
	add	s3, s3, a0	# V+=Loop3(n,X,Z)
	addi 	s2, s2, 1	# i++
	b	l3		# Ripeti il ciclo
endl3:
	mv  	a0, s3		# I argomento
	li 	a7, 1		# print_int()
	ecall
	la	a0, nl
	li	a7, 4		# print_str()			
	ecall

	li 	a7, 10		# a7=codice per la exit
	ecall			# exit()
