# PARTE A (CODICE UTENTE)
.data
led:         .word 13
pushButton:  .word 2
buttonState: .word 0 
baudrate:    .word 9600
#HANDLER DATA
saveframe:   .space 36 #a0,a1,a2,t0..t4
_syscallmsg: .asciz "Syscall "
_nl:         .asciz "\n"
fc1:         .word 1190000
fc2:         .word 1843200

.text
.globl main
#--------------------------------------
# MAIN eseguito implicitam. da Arduino
main:
#loading the handler
la a3, handler 
csrrw zero, 5, a3 # set utvec
csrrsi zero, 0, 1 # set interrupt enable
jal setup
aloop:
jal loop
# j aloop      # GIUSTO
##SIM: per semplicita' invece esco subito
addi a7,x0,10  #EXIT
ecall

#--------------------------------------
# ARDUINO SETUP FUNCTION
setup:
#alloc.stackspace
addi sp, sp, -4
sw   ra, 0(sp)      #punta a led
la   t0, led
lw   a2, 0(t0)      #legge led
add  a1, x0, x0     #setta II param.
addi a7, x0,25      #pinMode
ecall
lui  a2, 9600
addi a7, x0,21      #Serial.begin
ecall 
la   t0, pushButton #punta pushButton
lw   a2, 0(t0)      #setta II param.
addi a1, x0, 1
addi a7, x0,25      #pinMode
ecall
lw   ra, 0(sp)      #deall.stackspace
addi sp, sp, 4
jr   ra

#--------------------------------------
# ARDUINO LOOP FUNCTION
loop:
#alloc.stackspace
addi sp, sp, -4
sw   ra, 0(sp)      #punta a led
la   t0, led
lw   a2, 0(t0)      #setta II param.
addi a1, x0, 1
addi a7, x0, 24     #digitalWrite
ecall
addi a2, x0, 1000
addi a7, x0, 26     #delay
ecall
la   t0, pushButton
lw   a2, 0(t0)      #legge pushButton
addi a7, x0, 23     #digitalRead
ecall
la   t0, buttonState
sw   a7, 0(t0)      #val. ritorno
add  a2, x0, a7     #prep. I param.
addi a7, x0, 22     #Serial.println
ecall
addi a2, x0, 10
addi a7, x0, 26     #delay
ecall
la   t0, led
lw   a2, 0(t0)      #setta II param.
addi a1, x0, 0
addi a7, x0, 24     #digitalWrite
ecall
addi a2, x0, 1000
addi a7, x0, 26     #delay
ecall
lw   ra, 0(sp)      #dealloca stackspace
addi sp, sp, 4
jr   ra 

#--------------------------------------
####EXCEPTION HANDLER -- SUPERVISOR MODE####
handler:        #saving registers
csrrw x0,64,a4
la   a4 , saveframe
sw   a0,  0(a4)
sw   a2,  4(a4)
sw   a1,  8(a4)
sw   t0, 12(a4)
sw   t1, 16(a4)
sw   t2, 20(a4)
sw   t3, 24(a4)
sw   t4, 28(a4)  #print_str
sw   a7, 32(a4) 

la    a0, _syscallmsg
addi  a7, x0, 4
ecall #printf syscall str
lw    a0, 32(a4 ) # print_int
addi  a7, x0, 1
ecall# print_str
la    a0, _nl
addi  a7, x0, 4
ecall
# Switch to mysyscall code
lw    a0,  0(a4)  # pop a0
lw    a2,  4(a4)  # pop a2
lw    a1,  8(a4)  # pop a1
lw    a7, 32(a4)
addi  t0, x0, 21
beq   t0, a7, syscall21
addi  t0, x0, 22
beq   t0, a7, syscall22
addi  t0, x0, 23
beq   t0, a7, syscall23
addi  t0, x0, 24
beq   t0, a7, syscall24
addi  t0, x0, 25
beq   t0, a7, syscall25
addi  t0, x0, 26
beq   t0, a7, syscall26
isr_ret:
# a0 (can be mysyscall output)
lw    a5,  0(a4)  # pop a0
addi  t0, x0, 13
beq   t0, a5 , dno_v0
lw    a0,  0(a4)  # pop a0
lw    a7, 32(a4)  #pop a7 parameter
dno_v0:
lw    a2,  4(a4)  # pop a2
lw    a1,  8(a4)  # pop a1
lw    t0, 12(a4)  # pop t0
lw    t1, 16(a4)  # pop t1
lw    t2, 20(a4)  # pop t2
lw    t3, 24(a4)  # pop t3
lw    t4, 28(a4)  # standard except.exit
lw    a7, 32(a4)
csrrw a4, 65,x0   #update EPC
addi  a4, a4, 4
csrrw x0, 65, a4
uret
#--------------------------------------
### SUPERVISOR CODE (DRIVER)###
syscall21:
# a2=BR
lui  t0, 0x10010
ori  t0, t0, 0x01e0
addi t1, x0, 0xAB
# bit2=1stopbit, bit1-0=8bitframe
sb   t1, 3(t0)
sb   t1, 3(t0)
#calculate the time constant
slli t2,a2 , 4    #&fc2
la   t1, fc2
lw   t1, 0(t1)     #C=fc1/(BR*16)
div  t1, t1, t2    #valore DL
sb   t1, 0(t0)     #DLL (byte -signif)
srli t1, t1, 8     #val DLM in byte +sig.
sb   t1, 0(t0)     # LCRval.(DLAB=0)
addi t1, x0, 0x2B
sb   t1, 3(t0)
j isr_ret

syscall22:
lui  t0, 0x10010
ori  t0, t0, 0x01e0
sb   a2 , 0(t0)    #write data byte
j isr_ret

syscall23:
addi t0, x0, 13    #LED
beq  a2 , t1, isled1 #PUSHBUTTON
addi t0, x0, 2
beq  a2 , t1, ispsh1 #ispushbutton
j iserror1
isled1:
lui  t0, 0x10010
ori  t0,t0, 0x01e0
lui  t4, 0x5678
or   t0,t0, t4
lb   t2, 0(t0)     #mask bit 4
andi t2, t2, 0x10
srli a0, t2, 4
j fine1
ispsh1:
lui  t0, 0x10010
ori  t0, t0, 0x01e0
lui  t4, 0x4321
or   t0, t0, t4
lb   t2, 0(t0)     #mask bit 7
andi t2, t2, 0x80
srli a0, t2, 7
j fine1

iserror1:
#do nothing for now
fine1:
j isr_ret

syscall24:
addi t0, x0, 13     #LED
beq  a2, t1, isled2 #PUSHBUTTON
addi t0, x0, 2
beq  a2, t1, ispsh2 #ispushbutton
j iserror2
isled2:
lui  t0, 0x10010
ori  t0, t0, 0x01e0
lui  t4, 0x5678
or   t0, t0,t4
andi t1, a1, 1
srli t1, t1, 4      #select bit4
lb   t2, 0(t0)      #clear bit4
andi t2, t2, 0xEF
or   t3, t2, t1     #set bit4
sb   t3, 0(t0)      #store
j fine2
ispsh2:
lui  t0, 0x10010
ori  t0, t0, 0x01e0
lui  t4, 0x4321
or   t0, t0, t4
andi t1, a1, 1
srli t1, t1, 7      #select bit7
lb   t2, 0(t0)      #clear bit7
andi t2, t2, 0x7F
or   t3, t2, t1     #set bit7
sb   t3, 0(t0)      #store
j fine2
iserror2:
#do nothing for now
fine2:
j isr_ret

syscall25:
addi t0, x0, 13      #LED
beq  a2, t1, isled3  #PUSHBUTTON
addi t0, x0, 2
beq  a2, t1, ispsh3  #ispushbutton
j iserror3
isled3:
lui  t0, 0x10010
ori  t0, t0, 0x01e0
lui  t4, 0x5678
or   t0, t0, t4
lb   t2, 0(t0)      #mask bit0 of a1
andi t1, a1, 1      #clear bit0
andi t2, t2, 0xFE
or   t3, t2, t1     #set bit0
sb   t3, 0(t0)
j fine3
ispsh3:
lui  t0, 0x10010
ori  t0, t0, 0x01e0
lui  t4, 0x4321
or   t0, t0, t4
lb   t2, 0(t0)      #mask bit0 of a1
andi t1, a1, 1      #clear bit0
andi t2, t2, 0xFE
or   t3, t2, t1     #set bit0
j fine3
iserror3:
#do nothing for now
fine3:
j isr_ret

syscall26:
# a2=delay
lui  t0, 0x10010
ori  t0, t0, 0x0040
la   t0, fc1        #1.19 MHz
lw   t0, 0(t0)
mul  t2, a2 , t0    #count=delta*fc
addi t2, t2, -1     #count=delta*fc-1
andi t3, t2, 0xFF   #LSB
srli t4, t2, 8      #MSB
andi t4, t4, 0xFF
addi t1, x0, 0x30   #bit7-6=counter0,
                    #bit5-4=LSB+MSB,
                    #bit3-1=mode-0,
                    #bit0=binary counter                
la   t0, fc1        #1.19 MHz 
sb   t1, 3(t0)      #write value in CWR
sb   t3, 0(t0)      #write LSB in CR0
sb   t4, 0(t0)      #write MSB in CR0
#start counting 
addi t1, x0, 0xC2   #red CR0
 #counter latch cmd
sw   a2, 0(t0)      #SIMULA CONT.(init)
add  t2, x0, a2 
check:
addi t2, t2, -1     #SIMULA CONT.(dec)
sw   t2, 0(t0)       #SIMULA CONT.(upd)
sb   t1, 3(t0)      #CR0 counter latch cmd
lh   t2, 0(t0)      #CR0-LSB (GIUSTO: lb)
lh   t3, 0(t0)      #CR0-MSB (GIUSTO: lb)
bne  t3, x0, check
bne  t2, x0, check
#count finished CR0==0
j isr_ret
