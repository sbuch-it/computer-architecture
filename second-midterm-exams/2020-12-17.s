.data
delta:  .float 0.1
epserr: .float 0.0001
space:  .asciz " "
acapo:  .asciz "\n"
 
.text
#----------------------------------- 
#float f (float x) {
f: #fa0=x
#    return (x*x + 3*x - 1.75);
#}
fmul.s ft0,fa0,fa0 #x*x
addi   t0,x0,3
fcvt.s.w ft1,t0   #3.0
fmul.s ft2,ft1,fa0#3*x
addi   t0,x0,2
fcvt.s.w ft3,t0   #2.0
fadd.s fa0,ft0,ft2#x*x+3*x
fsub.s fa0,fa0,ft3#(.)-2
ret

#----------------------------------- 
#float df(float x) {
df:
addi   sp,sp,-16  #alloco frame
sw     ra,0(sp)   #salvo ra
fsw    fs0,4(sp)  #salvo prec fs0
fsw    fs1,8(sp)  #salvo prec fs1
fsw    fs2,12(sp) #salvo prec fs2
fmv.s  fs0,fa0    #salvo x
la     t0,delta   #&delta
flw    fs1,0(t0)  #0.1
fsub.s fa0,fs0,fs1#x-0.1
jal    f          #f(x-0.1)
fmv.s  fs2,fa0    #salvo f(x-0.1)
fadd.s fa0,fs0,fs1#x+0.1
jal    f          #f(x+0.1)
fsub.s fa0,fs2,fa0#f(.)-f(.)
fadd.s fs1,fs1,fs1#0.2
fdiv.s fa0,fa0,fs1#(.)/0.2
#    return ((f(x-0.01)-f(x+0.01))/0.02);
lw     ra,0(sp)   #ripristino ra
flw    fs0,4(sp)  #ripristino prec fs0
flw    fs1,8(sp)  #ripristino prec fs1
flw    fs2,12(sp) #ripristino prec fs2
addi   sp,sp,16   #dealloco frame
ret
#}

#-----------------------------------
# void myprintf(float fm1, float xmd, 
#               float a, float b) {
myprintf:
#fa0 gia' a posto #stampa fm1
li a7,2           #print_float
ecall
la a0,space       #spazio 
li a7,4           #print_string
ecall
fmv.s fa0,fa1     #stampa xmd
li a7,2           #print_float
ecall
la a0,space       #spazio
li a7,4           #print_string
ecall
fmv.s fa0,fa2     #stampa a
li a7,2           #print_float
ecall
la a0,space       #spazio
li a7,4           #print_string
ecall
fmv.s fa0,fa3     #stampa b
li a7,2           #print_float
ecall
la a0,acapo       #a capo
li a7,4           #print_string
ecall
ret

#-----------------------------------    
#float bisect(float a, float b) {
bisect: 
#   fs0=xmd fs1=a fs2=b fs3=epserr fs4=fm 
addi   sp,sp,-24  #alloco frame
sw     ra,0(sp)   #salvo ra
fsw    fs0,4(sp)  #salvo prec fs0
fsw    fs1,8(sp)  #salvo prec fs1
fsw    fs2,12(sp) #salvo prec fs2
fsw    fs3,16(sp) #salvo prec fs3
fsw    fs4,20(sp) #salvo prec fs4

fmv.s  fs1,fa0    #a
fmv.s  fs2,fa1    #b
#   epserr=0.0001
la     t0,epserr  #&epserr
flw    fs3,0(t0)  #epserr=0.0001
 
dowhile_ini:   #  do {
#xmd=(a+b) / 2
fadd.s fa0,fs1,fs2
addi   t2,x0,2
fcvt.s.w ft0,t2   #2.0
fdiv.s fs0,fa0,ft0#xmd=(a+b)/2
fmv.s  fa0,fs0    #prep. arg
#  fm=f(xmd);
jal    f          #chiamo f()
fmv.s  fs4,fa0    #fm=f()
#  if (fabs(fm) < epserr) {
fabs.s ft0,fs4    #fabs(fm)
flt.s  t3,ft0,fs3 #fabs()<epserr
beq    t3,x0,if1_else #se falso-->else
#    return 0;
fmv.s  fa0,fs0    #ritorno xmd
j      fine
#} else  {
if1_else:
#    if (f(a)*fm < 0)
fmv.s  fa0,fs1    #preparo arg
jal    f          #chiamo f()
fmul.s ft1,fa0,fs4#f(a)*fm
fcvt.s.w ft0,x0   #0.0
flt.s  t0,ft1,ft0 #f(a)*fm < 0
beq    t0,x0,if2_else#se < e' falso: else2
#        b=xmd;
fmv.s  fs2,fs0    #b=xmd
j      if2_fine
#    else
if2_else:
fmv.s  fs1,fs0    #a=xmd;
if2_fine:

fmv.s  fa0,fs4    #fm
fmv.s  fa1,fs0    #xmd
fmv.s  fa2,fs1    #a
fmv.s  fa3,fs2    #b
jal    myprintf

# while (fabs(fm) >= epserr);
fabs.s ft4,fs4    #fabs(fm)
flt.s  t0,ft4,fs3 #fabs(fm)<epserr
beq    t0,x0,dowhile_ini#se < e' falso: >= e' vero: while_ini

# return xmd;
fmv.s  fa0,fs0    # return xmd  
 
fine:
lw     ra,0(sp)   #ripristino ra
flw    fs0,4(sp)  #ripristino prec fs0
flw    fs1,8(sp)  #ripristino prec fs1
flw    fs2,12(sp) #ripristino prec fs2
flw    fs3,16(sp) #ripristino prec fs3
flw    fs4,20(sp) #ripristino prec fs4
addi   sp,sp,24   #dealloco frame
ret

#-----------------------------------    
#int main() {
.globl main
main:
addi sp,sp,-8    #alloco frame
sw   ra,0(sp)    #salvo ra
fsw  fs0,4(sp)   #salvo prec fs0

#    float dy=0;
fmv.s.x fs0,x0   #0.0

#    x = bisect(-2, 1);
li     t0,-2
fcvt.s.w fa0,t0  #-2.0
li     t0,1
fcvt.s.w fa1,t0  #1.0
jal  bisect      #out: fa0=x

#    if (x != 0) dy=df(x);
fmv.s.x ft0,x0   # 0.0
feq.s  t0,fa0,ft0# x==?0.0
bne    t0,x0,m_if_fine#se vero: m_if_fine
jal    df        #in: fa0=x, out: fa0=dy
fmv.s  fs0,fa0   #dy=(.)
m_if_fine:

#    print_float(dy); print_string("\n");
fmv.s  fa0,fs0   #dy
li     a7,2
ecall            #print_float dy
la     a0,acapo
li     a7,4
ecall            #print_str acapo

#return 0;
li     a0,0      #0
#}
lw     ra,0(sp)  #ripristino ra
flw    fs0,4(sp) #ripristino prec fs0
addi   sp,sp,8   #dealloco frame
ret