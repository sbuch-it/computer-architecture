
#esame 07-07-2017 esercizio 1 MIPS
.data
count:
.word 0
hdr: .asciz "\nNo. "
sep: .asciz "\n-----"
nl1: .asciz "\n"
.text
.globl main

solve:
# allocate frame+loc.var
addi sp, sp, -32
sw a0 , 0(sp)# save n
sw a1, 4(sp)# save col
sw a2, 8(sp)# save *hist
sw s0, 12(sp)# save old fp
sw ra, 16(sp)# 20(sp) is for 's'
sw s2, 24(sp)# saved i
sw s1, 28(sp)# saved j
add s0, sp, x0
sb x0, 21(s0)# i:s0, j:s1
bne a1, a0 , endif# print the header

la a0, hdr# print_str
addi a7,x0,4
ecall# &count

la t0, count
lw a0 , 0(t0)#++count
addi a0 , a0 , 1
sw a0 , 0(t0)# print_str
addi a7,x0,1
ecall# print the separator

la a0 , sep# print_str
addi a7,x0,4
ecall
lw a0 , 0(sp)# i=0
addi s2, x0, 0

fori1:
slt a6, s2, a0
beq a6, x0, endfori1# j=0
addi s1, x0, 0

forj1:
slt a6, s1, a0
beq a6, x0, endforj1#forj1 body start
slli t2,s2, 2# i*4
add t2, a2, t2# &hist+i*4
lw t3, 0(t2)# t3:hist[i]
bne t3, s1, ter2# i!=j -> ter2
addi t4, x0, 81
sb t4, 20(s0)#s[0]='Q'
j nextforj1

ter2:
add t2, s2, s1# (i+j)&1
andi t3, t2, 1
bne t3, x0, ter3
addi t4, x0, 32
sb t4, 20(s0)#s[0]=' '
j nextforj1

ter3:
addi t4, x0, 46
sb t4, 20(s0)#forj1 body end

nextforj1:
# ++j
addi s1, s1, 1# &s
addi a0 , s0, 20# print_str
addi a7,x0,4
ecall
lw a0 , 0(sp)#restore A0A0
j forj1

endforj1:
# i++
addi s2, s2, 1# print just 1 newline
la a0, nl1# print_str
addi a7,x0,4
ecall

lw a0 , 0(sp)#restore A0A0
j fori1

endfori1:
j goreturn

endif:
# i=0
addi s2, x0, 0
fori2:
slt a6, s2, a0# i<?n
beq a6, x0, endfori2# j=0
addi s1, x0, 0

forj2:
slt a6, s1, a1# j<?col
beq a6, x0, endforj2#ifnot endforj2
slli t2,s1, 2# j*4
add t2, a2, t2# &hist+j*4
lw t3, 0(t2)# t3:hist[j]
beq t3, s2, endforj2#hist[j]==?i, ifyes endforj2
sub t4, t3, s2# hist[j]-i
slt t5, t4, x0# (hist[j]-i)<?0
beq t5, x0, posit
sub t4, s2, t3# i-hist[j]

posit:
sub t5, a1, s1# col-j
beq t4, t5, endforj2# j++
addi s1, s1, 1
j forj2

endforj2:
slt a6, s1, a1# j<?col
bne a6, x0, gocont# continue
slli t2,a1, 2# col*4
add t2, a2, t2# &hist+col*4
sw s2, 0(t2)# col+1
addi a1, a1, 1
jal solve
lw a1, 4(s0)#fori1 body end

gocont:
# i++
addi s2, s2, 1
j fori2
endfori2:

goreturn:

lw a0 , 0(sp)
lw a1, 4(sp)
lw a2, 8(sp)
lw s0, 12(sp)
lw ra, 16(sp)
lw s2, 24(sp)
lw s1, 28(sp)
addi sp, sp, 32
ret

main:
# allocate "int hist[8]"
addi sp, sp, -32# n
addi a0 , x0, 8# col
addi a1, x0, 0
add a2, sp, x0# *hist
jal solve# deallocate "int hist[8]"
addi sp, sp, 32

addi a7,x0,10
ecall
