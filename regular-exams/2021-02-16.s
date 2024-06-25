#char buff[80] = "2*3+4/5";
.data
buff: .asciz "2*3+4/5"
      .space  72
nl:   .asciz "\n"

.text
.globl main
#
#char find_op(char *s) {
# a0=s
find_op:
   mv t0, a0  # s
#  char op = '\0';
   li   a0, 0   # op = '\0' 
#  while (*s != '\0') {
fo_while:
   lb	t6, 0(t0)	
   # carica il carattere *s  
   beq	t6, x0, fo_while_end
   # se *s==0 termina il ciclo

#    if (*s < '0' || *s > '9') {
   slti	t1, t6, '0' 	# *s <? '0'
   li   t2, '9'
   slt  t3, t2, t6      # *s >? '9'
   or	t4, t1, t3      # t1 || t3
   beq	t4, x0, fo_if_else
   # se la cond. e' vera ho finito
#      op = *s; break;
   mv   a0, t6          # op=*s
   b    fo_while_end
#    } else {
#      ++s;
fo_if_else:
   addi t0, t0, 1  # ...altrimenti s++
#    }
#  }
   b	fo_while   # e continuo il while
fo_while_end:
#  return (op); op # sta gia in a0
   ret
#}

#
#void printnl(char *b) {
printnl:
#  print_string(b); print_string("\n");
   li a7,4
   ecall
   la  a0, nl
   ecall
   ret
#}

#
#int main() {
main:
   addi sp, sp, -56
   sw   ra, 0(sp)
   sw   s0, 4(sp) # p
   sw   s1, 8(sp) # a
   sw   s2,12(sp) # b 
   sw   s3,16(sp) # d
   fsd fs0,20(sp) # f
   fsd fs1,28(sp) # g
   fsd fs2,36(sp) # h
   fsw fs3,44(sp) # w
   fsw fs4,48(sp) # x
   fsw fs5,52(sp) # y
   
#  int a, b=2, d=3;
#  s3 = a, s1 = b, s2 = d
   li   s2, 2        # b=2
   li   s3, 3        # d=3
#  double f=4, g=5, h;
#  fs0 = f, fs1 = g, fs2 = h
   li   t0, 4
   fcvt.d.w fs0,t0   # f=4
   li   t0, 5
   fcvt.d.w fs1,t0   # g=5

#  float w, x=7, y=8; 
#  fs3 = w, fs4 = x, fs5 = y	
   li   t0, 7
   fcvt.s.w fs4,t0   # x=7
   li   t0, 8
   fcvt.s.w fs5,t0   # y=8

#  char c, *p = buff;
#  t0=c, s0=p
   la   s0, buff     # p = buff

#  do {
m_dowhile:
#    switch (c = find_op(p++)) {
   mv   a0, s0       # p
   addi s0, s0, 1    # p++
   jal  find_op      # ritorna c=a0
#      case '+': a = b + d; break;
m_sw1:
   li   t0, '+'      # case '+' ?
   bne  a0,t0,m_sw2  # se no caso succ.
   add  s1, s2, s3   # se si', a=b+d
   b	m_sw_end     # break
#      case '*': f = g * x; break;
m_sw2:
   li   t0, '*'	     # case '*' ?
   bne  a0,t0,m_sw3  # se no caso succ.
   fcvt.d.s ft4,fs4  # (double)x
   fmul.d fs0,fs1,ft4# se si', f=g*x
   b	m_sw_end     # break
#      case '/': w = x/y; break;
m_sw3:
   li   t0, '/'	     # case '/' ?
   bne a0,t0,m_sw_end# se no fine switch
   fdiv.s fs3,fs4,fs5# se si', w=x/y
          	     # break
#    }
m_sw_end:
#  } while (c != '\0');
   bne a0,x0,m_dowhile
   # c !=? '\0', se si' dowhile
   
#  h = a * w;
   fcvt.s.w ft0,s1   # (float)a
   fmul.s ft0,ft0,fs3# a*w
   fcvt.d.s fs2,ft0 # (double)h
#  printnl(buff); 
   la a0, buff
   jal printnl
#  print_double(h);
   fmv.d fa0,fs2
   li a7,3  # print_double
   ecall
#  exit(0);
   li a7,10 # exit (servizio #10)
   ecall
   
   lw   ra, 0(sp)
   lw   s0, 4(sp)
   lw   s1, 8(sp)
   lw   s2,12(sp)
   lw   s3,16(sp)
   fld fs0,20(sp)
   fld fs1,28(sp)
   fld fs2,36(sp)
   flw fs3,44(sp)
   flw fs4,48(sp)
   flw fs5,52(sp)
   addi sp,sp,56
   ret
#}
