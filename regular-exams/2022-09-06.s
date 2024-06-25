.data
sp1: .asciz " "
vi:  .dword 0, 0, 0, 0, 1, 2, 3, 4, 5, 6
vj:  .dword 1, 2, 3, 4, 5, 5, 6, 6, 7, 7
visited: .space 72
G:   .space 72

.text
.globl main
#-----------------------------------
DFS:# a0=i 
    #_____CALL FRAME______________
    addi  sp,sp,-16  # Totale  16B
    sd    ra, 0(sp)  # save ra  8B
    sd    s0, 8(sp)  # save p   8B
    #_____________________________
    la    t0,G       # &G
    slli  t1,a0,3    # i*8
    add   t0,t0,t1   # &G[i]
    ld    s0,0(t0)   # p=G[i]
    li    t3,1       # 1
    la    t2,visited # &visited
    add   t2,t2,t1   # &visited[i]
    sd    t3,0(t2)   # visited[i]=1
    li    a7,1       # print_int (a0)
    ecall
    la 	a0, sp1    # UNO SPAZIO
    li    a7,4       # print_string
    ecall
dfs_iniwhile:
    beq   s0,zero,dfs_finewhile
    ld    a0,8(s0)   # a0=i=p->vertex
    la    t0,visited # &visited
    slli  t1,a0,3    # i*8
    add   t2,t0,t1   # &visited[i]
    ld    t3,0(t2)   # visited[i]
    bne   t3,zero,dfs_dopoif
    jal	DFS
dfs_dopoif:	
    ld    s0,0(s0)   # p=p->next
    b     dfs_iniwhile
dfs_finewhile:
    ld    ra, 0(sp)
    ld    s0, 8(sp)
    addi  sp,sp,16   # dealloca frame
    ret
#-----------------------------------
insert:
    # a0=vi a1=vj
    mv    t0,a0      # t0=vi
    li    a0,16      # sizeof(node)
    li    a7,9       # sbrk
    ecall            # a0=q
    sd    a1,8(a0)   # q->vertex=vj
    sd    zero,0(a0) # q->next=NULL
    la	t1,G	      # &G
    slli  t0,t0,3    # vi*8
    add   t0,t1,t0   # &G[vi]
    ld    t1,0(t0)   # G[vi]
    bne	t1,zero,i_else
    sd	a0,0(t0)   # G[vi]=q
    b     i_dopoif
i_else:
	# t1 is p=G[vi]
i_while:
    ld    t2,0(t1)   # p->next
    beq   t2,zero,i_dopowhile
    mv    t1,t2      # p=p->next
    b     i_while
i_dopowhile:
    sd    a0,0(t1)   # p->next=q
i_dopoif:	
    ret
#-----------------------------------
main:
    addi  sp,sp,-8
    sd    s0,0(sp)
    li    s0,0       # i=0
inifor: 
    slti  t3,s0,10   # i<?10
    beq   t3,zero,finefor
    slli  t0,s0,3    # i*8
    la    t1,vi      # &vi
    add   t1,t1,t0   # &vi[i]
    ld    a0,0(t1)   # v[i]
    la    t2,vj      # &vj
    add   t2,t2,t0   # &vj[i]
    ld    a1,0(t2)   # vj[i]
    jal   insert 
    addi  s0,s0,1    #++i
    b     inifor
finefor:
    li    a0,0       # 1st param.
    jal   DFS
    ld    s0,0(sp)
    addi  sp,sp,8
    li    a7,10      # exit
    ecall