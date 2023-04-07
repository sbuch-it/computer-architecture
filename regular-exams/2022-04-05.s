.data
p1:  .double 1.0
m1:  .double -1.0
a:   .double 11.0, 1.0, 2.0, 3.0, 12.0, 4.0, 1.0, 2.0, 13.0
x:   .space 72 
y:   .space 72

.text
.globl main
#------------------------------------------
sqr:
  fmul.d fa0, fa0, fa0 # x*x
  ret
#------------------------------------------
sign:
  fmv.d.x ft0,x0
  flt.d   t0,fa0,ft0 # x<?0.0
  bne     t0,x0,sign_exitp1 #si: ritorna +1
  feq.d   t0,fa0,ft0 # x=?0.0
  fmv.d   fa0,ft0   # x=0.0
  beq     t0,x0,sign_exitm1 #no: ritorna -1
  ret
sign_exitp1:
  la      t0, p1
  fld     fa0,0(t0) # ritorna +1
  ret
sign_exitm1:
  la      t0, m1
  fld     fa0,0(t0) # ritorna -1
  ret
#------------------------------------------
genqr:  # a0=a a1=q a2=r a3=s
  #PROLOGO
  addi sp,sp,-28
  sw  ra, 0(sp)
  sw  s0, 4(sp)
  sw  s1, 8(sp)
  sw  s2,12(sp)
  sw  s3,16(sp)
  sw  s4,20(sp)
  sw  s5,24(sp)

# save a0, a1, a2, a3
  mv  s0,a0
  mv  s1,a1
  mv  s2,a2
  mv  s3,a3
        
# for(i=0;i<s;++i){
  li  s4,0     # i=0
gqr_fori:
  slt t0,s4,s3 # i<?s
  beq t0,x0,gqr_foriend #no: forendi

#  c=0.0; for(k=0;k<s;++k) c=c+sqr(a[k][i]);
  fmv.d.x fs0,x0 #c = 0.0
  li s5,0      # k=0
gqr_fork1:
  slt t0,s5,s3 # k<?s
  beq t0,x0,gqr_fork1end
  mul t0,s5,s3 # k*s
  add t0,t0,s4 # k*s+i
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s0 # &a[k][i]
  fld fa0,0(t1)# a[k][i]
  call sqr
  fadd.d fs0,fs0,fa0 # c+=(.)
  addi s5,s5,1 # ++k
  b gqr_fork1
gqr_fork1end:
#  c=sqrt(c);
  fsqrt.d fs0,fs0 # sqrt(.)
  
#  r[i][i] = c;
  mul t0,s4,s3 # i*s
  add t0,t0,s4 # i*s+i
  slli t0,t0,3 # *8 (offset)
  add t0,t0,s2 # &r[i][i]
  fsd fs0,0(t0)# r[i][i]
  
#  for(k=0;k<s;++k) q[k][i]=a[k][i]/c;
  li s5,0      # k=0
gqr_fork2:
  slt t0,s5,s3 # k<?s
  beq t0,x0,gqr_fork2end
  mul t0,s5,s3 # k*s
  add t0,t0,s4 # k*s+i
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s0 # &a[k][i]
  fld ft0,0(t1)# a[k][i]
  fdiv.d ft1,ft0,fs0 # a/c
  add t1,t0,s1 # &q[k][i]
  fsd ft1,0(t1)# q[k][i]=(.)
  addi s5,s5,1 # ++k
  b gqr_fork2
gqr_fork2end:

#  for(j=0;j<i;++j) r[i][j] = 0.0;
  li t2,0      # j=0
  fmv.d.x ft0,x0 # 0.0
gqr_forj1:
  slt t0,t2,s4 # j<?i
  beq t0,x0,gqr_forj1end
  mul t0,s4,s3 # i*s
  add t0,t0,t2 # i*s+j
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s2 # &r[i][j]
  fsd ft0,0(t1)# r[i][j]=0.0
  addi t2,t2,1 #++j
  b gqr_forj1
gqr_forj1end:

#  for(j=i+1;j<s;++j) {
  addi t2,s4,1 # j=i+1
gqr_forj2:
  slt t0,t2,s3 # j<?s
  beq t0,x0,gqr_forj2end

#   c = 0.0; for(k=0;k<s;++k) c += q[k][i]*a[k][j];
  fmv.d.x ft0,x0 # 0.0
  li s5,0      # k=0
gqr_fork3:
  slt t0,s5,s3 # k<?s
  beq t0,x0,gqr_fork3end

  mul t0,s5,s3 # k*s
  add t0,t0,s4 # k*s+i
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s1 # &q[k][i]
  fld ft1,0(t1)# q[k][i]

  mul t0,s5,s3 # k*s
  add t0,t0,t2 # k*s+j
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s0 # &a[k][j]
  fld ft2,0(t1)# a[k][j]

  fmul.d ft1,ft1,ft2 # q*a
  fadd.d ft0,ft0,ft1 #c+= (.)

  addi s5,s5,1 # ++k
  b gqr_fork3
gqr_fork3end:

#   r[i][j] = c;
  mul t0,s4,s3 # i*s
  add t0,t0,t2 # i*s+j
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s2 # &r[i][j]
  fsd ft0,0(t1)# r[i][j]=(.)

#   for(k=0;k<s;++k) a[k][j] -= c * q[k][i];
  li s5,0 #k=0
gqr_fork4:
  slt t0,s5,s3 # k<?s
  beq t0,x0,gqr_fork4end
  
  mul t0,s5,s3 # k*s
  add t0,t0,s4 # k*s+i
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s1 # &q[k][i]
  fld ft1,0(t1)# q[k][i]
  
  fmul.d ft2, ft0, ft1 # c*q
  mul t0,s5,s3 # k*s
  add t0,t0,t2 # k*s+j
  slli t0,t0,3 # *8 (offset)
  add t1,t0,s0 # &a[k][j]
  fld ft3,0(t1)# a[k][j]
  fsub.d ft3,ft3,ft2 #a -= c*q
  fsd ft3,0(t1)# a[k][j]=(.)
   
  addi s5,s5,1 #++k
  b gqr_fork4
gqr_fork4end:

  addi t2,t2,1 #++j
  b gqr_forj2
#  }
gqr_forj2end:

  addi s4,s4,1 # ++i
  b gqr_fori
# }
gqr_foriend:
    
  #EPILOGO
  lw   s5,24(sp)
  lw   s4,20(sp)
  lw   s3,16(sp)
  lw   s2,12(sp)
  lw   s1, 8(sp)
  lw   s0, 4(sp)
  lw   ra, 0(sp)
  addi sp,sp,28
  ret
  
#------------------------------------------
main:
  la a0, a
  la a1, x
  la a2, y
  li a3, 3
  call genqr

#    print_double(y[2][2]);
  la   t0, y
  addi t0,t0,64 # &y[2][2]
  fld  fa0,0(t0)# y[2][2]
  li   a7, 3 # print_double
  ecall
  li   a7, 10 # exit
  ecall
  
  
