
.data
sp1:
.asciz " "
nl1:
.asciz "\n"
vi:
.word 0, 0, 0, 0, 1, 2, 3, 4, 5, 6
vj:
.word 1, 2, 3, 4, 5, 5, 6, 6, 7, 7
G:
.space 80
visited:
.space 80
n:
.word 8
.text
.globl main

DFS:
# p in s0, i in s1
addi sp, sp, -16
sw s0, 0(sp)
add s0, sp, x0
sw ra, 4(sp)
sw s2, 8(sp)
sw s1, 12(sp)

add s1, a0 , x0# print_int (a0)
addi a7,x0,1
ecall

la a0 , sp1# print_string
addi a7,x0,4
ecall# &G
la t0, G
add t1, s1, s1
add t1, t1, t1
add t0, t0, t1# &G + i*4
lw s2, 0(t0)# 1
addi t2, x0, 1# & visited
la t0, visited
add t0, t0, t1# &visited+i*4
sw t2, 0(t0)# visited[i]=1
dfs_iniwhile:

beq s2, x0, dfs_finewhile
lw a0 , 4(s2)# & visited
la t0, visited
add t4, a0 , a0
add t4, t4, t4
add t0, t0, t4
lw t3, 0(t0)# visited[i]
bne t3, x0, dfs_dopoif
jal DFS
dfs_dopoif:

lw s2, 0(s2)# p=p->next
j dfs_iniwhile
dfs_finewhile:

lw s1, 12(sp)
lw s2, 8(sp)
lw ra, 4(sp)
lw s0, 0(sp)
addi sp, sp, 16
ret
insert:
# vi(a0) in s0, vj(a1) in s1
add a6, x0, a2

addi a0 , x0, 8
addi a7,x0,9
ecall# a0= q

sw a1, 4(a0)# q->vertex=vj
sw x0, 0(a0)# &G
la t0, G
add t4, a6, a6
add t4, t4, t4
add t0, t0, t4# &G+4*vi
lw t1, 0(t0)# G[vi]
bne t1, x0, i_else
sw a0, 0(t0)# G[vi]=q
j i_dopoif
i_else:
# t1 is p=G[vi]
i_while:

lw t2, 0(t1)# p->next
beq t2, x0, i_dopowhile
add t1, x0, t2# p=p->next
j i_while
i_dopowhile:

sw a0, 0(t1)# p->next=q
i_dopoif:
ret

read_graph:
# i in s0, j in s1, n in s2
addi sp, sp, -20
sw s0, 0(sp)
add s0, sp, x0
sw ra, 4(sp)
sw s2, 8(sp)
sw s1, 12(sp)
sw s3, 16(sp)# &n
la t1, n
lw s3, 0(t1)# i=0
addi s2, s2, 0
rg_inifor1:

slt t2, s2, s3# i<?n
beq t2, x0, rg_finefor1# &G
la t0, G
add t4, s2, s2
add t4, t4, t4
add t0, t0, t4# &G+4*i
sw x0, 0(t0)# j=0
addi s1, x0, 0
rg_inifor2:
# 10
addi t3, x0, 10
slt t2, s1, t3# i<?n
beq t2, x0, rg_finefor2
la t5, vi
la t6, vj
add t4, s1, s1
add t4, t4, t4
add t5, t5, t4# &vi[j]
add t6, t6, t4# &vj[j]
lw a2 , 0(t5)# vi[j]
lw a1, 0(t6)# vj[j]
jal insert# ++j
addi s1, s1, 1
j rg_inifor2
rg_finefor2:
# ++i
addi s2, s2, 1
j rg_inifor1
rg_finefor1:

lw s3, 16(sp)
lw s1, 12(sp)
lw s2, 8(sp)
lw ra, 4(sp)
lw s0, 0(sp)
addi sp, sp, 20
ret 
#-----------------------------------

main:

jal read_graph
add t0, x0, x0# &n
la t1, n
lw t1, 0(t1)# & visited
la t3, visited
inifor:

slt t2, t0, t2
beq t2, x0, finefor
add t4, t0, t0
add t4, t4, t4
add t3, t3, t4# &t3 + i*4
sw x0, 0(t3)# ++i
addi t0, t0, 1
j inifor
finefor:

add a0, x0, x0# 1st param = 0
jal DFS
la a0, nl1#print_string
addi a7,x0,4
ecall#exit

addi a7,x0,10
ecall