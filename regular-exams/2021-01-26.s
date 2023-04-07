#char buff[80] = "Architettura dei Calcolatori\n";
.data
buff:  .asciz "Architettura dei Calcolatori\n"
       .space 50
zerod: .double  0.0
punof: .float   1.0
munod: .double -1.0

.text
.globl main
#char to_upper(char c) {
#----------------------------------- 
to_upper:
#  if (c >= 'a' && c <= 'z') c -= 0x20;
	slti  t0, a0, 'a' # c <? 'a'
	bne   t0, x0, ret_to_upper
	addi  t1, x0, 'z'
	slt   t2, t1, a0  # 'z' <? c
	bne   t0, x0, ret_to_upper
	addi  a0, a0, -0x20
#  return (c);
#}
ret_to_upper:
	ret

#char *myfun(int n, int *m, char *p, char c, 
#            float f, double d) {
#  char *r, *s = p;
# a0=n, a1=m, a2=p, a3=c, fa0=f, fa1=d
#----------------------------------- 
myfun:
    addi  sp, sp, -44
    # 4 per ra, 4 fp, 24 arg., 8 per var loca
    sw    fp,  4(sp)  # salva fp
    mv    fp, sp      # iniz. nuovo frame pointer
    sw    ra,  0(fp)  # salva ra
    fsd   fa1, 8(fp)  # d  (double)
    fsw   fa0,16(fp)  # f
    sw    a3, 20(fp)  # c
    sw    a2, 24(fp)  # p  
    sw    a1, 28(fp)  # m
    sw    a0, 32(fp)  # n
    sw    s1, 36(fp)  # r
    sw    s2, 40(fp)  # s
    mv    s2, a2      # s=p
	
#  if (n == 0) return (p);
    bne   a0, x0, if1_end
    mv    a0, a2      # prepara p
    b     myfun_epilogo
if1_end:

#  while (*s != '\0' && n-- > 0) {
while_start:
    lb    t0, 0(s2)   # *s
    beq   t0, x0, while_end
    # salta se la prima cond. e' falsa
    mv    t1, a0      # n
    addi  a0, a0, -1  # n--
    slt   t2, x0, t1  # 0 <? n
    beq   t2, x0, while_end 
    # salta se la seconda cond. e' falsa

#    *s = to_upper(*s);
    sw    a0, 8(fp)   
    # salva a0, che serve a to_upper
    mv    a0, t0    # setup del parametro di input
    jal   to_upper  # chiama to_upper
    sb    a0, 0(s2) # memorizza resultato, *s = ...
    mv    t0, a0    # copia *s in t0
    lw    a0, 8(fp) # ripristina a0
	
#    if (*s == c) r = s;
    bne   t0, a3, if2_end # *s ==? c
    mv    s1, s2    # r = s
#    s++;
if2_end:
    addi  s2, s2, 1 # s++
#  } 
    b     while_start
while_end:

#  if (f * d < 0) {
    fcvt.d.s fa0,fa0     # (double)f
    fmul.d   ft1,fa0,fa1 # f*d
    la       t0, zerod
    fld      ft0, 0(t0)  # ft0=(double)0.0
    flt.d    t0,ft1,ft0  # f*d <? 0
    beq      t0, x0, if3_end
#    f = -f;
    fneg.d   fa0, fa0
    
#    r = myfun(n/2, m, r, c, f, d);
    sw   a0,32(fp)   # salva prec. a0
    sw   a2,24(fp)   # salva prec. a2
    li   t0, 2
    div  a0,a0,t0
    mv   a2, s1      # terzo param: r
    jal  myfun
    mv   s1,a0	     # r = param.ritorno
    lw   a0,32(fp)   # riprendi a0
    lw   a2,24(fp)   # riprendi a2
#  }
if3_end:
#  ++*m;
    lb   t0,0(a1)    # *m
    addi t0,t0,1     # ++
    sb   t0,0(a1)    # *m=...
#  return (r);
    mv   a0, s1      # parm. di ritorno r
#}
myfun_epilogo:
    lw   ra,  0(fp)
    fld  fa1, 8(fp)  # d
    flw  fa0,16(fp)  # f
    lw   a3, 20(fp)  # c
    lw   a2, 24(fp)  # p  
    lw   a1, 28(fp)  # m
#    lw   a0, 32(fp)  # non serve (sovrascritto)
    lw   s1, 36(fp)  # r
    lw   s2, 40(fp)  # s
    lw   fp,  4(fp)
    addi sp, sp, 44  # ripristina sp 
    ret
#
#int main() {
main:
#  char *p; int z = 1;
#  t0=p
    addi sp,sp,-8   
    sw   ra,  0(sp) # salva ra
    #         4(sp) # spazio per z
    li   t0,  1     # z=1
    sw   t0, 4(sp)  # aggiorna z
    
#  print_string(buff);
    la   a0, buff
    li   a7, 4
    ecall

#  p = myfun(28, &z, buff, 'E', 1, -1);
    li    a0, 28
    addi  a1, sp, 4 # &z
    la    a2, buff   
    li    a3, 'E'
    la    t0, punof
    flw   fa0, 0(t0)# (float)1.0 
    la    t0, munod
    fld   fa1, 0(t0)# (double)-1.0
    jal   myfun     # restituisce p in a0

#  print_string(p)
    # a0 contiene gia' p
    li    a7, 4
    ecall
	
#  print_int(z);
    lw    a0, 4(sp) # z
    li    a7, 1 
    ecall

#  exit(0);
    li    a7,10     # exit
    ecall
#}
    lw   ra, 0(sp)  # ripristina ra
    lw   s1, 4(sp)  # ripristina s1
    addi sp,sp,8    # ripristina sp
    ret
