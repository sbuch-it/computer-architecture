main:   addi x5, x0, 5      # initialize x5 = 5     0      00500293
        addi x6, x0, 12     # initialize x6 = 12    4      00c00313
        addi x7, x6, -9     # initialize x7 = 3     8      ff730393
        add  x3, x0, x0     # coded as x3,x0,x0     c      000001b3
        or   x8, x7, x5     # x8 = (3 OR 5) = 7    10      0053e433
        and  x9, x6, x8     # x9 = (12 AND 7) = 4  14      008374b3
        add  x9, x9, x8     # x9 = 4 + 7 = 11      18      008484b3
        beq  x9, x7, end    # shouldn't be taken   1c      02748263
        slt  x8, x6, x8     # x8 = 12 < 7 = 0      20      00832433
        beq  x8, x0, around # should be taken      24      00040463
        addi x9, x0, 0      # shouldn't happen     28      00000493
around: slt  x8, x7, x5     # x8 = 3 < 5 = 1       2c      0053a433
        add  x7, x8, x9     # x7 = 1 + 11 = 12     30      009403b3
        sub  x7, x7, x5     # x7 = 12 - 5 = 7      34      405383b3
        add  x9, x3, x6     # x9 = 0 + 12   38      006184b3
        sw   x7, 68(x9)     # [10008050] = 7       3c      0474a223
end:    lw   x5, 80(x3)     # x5 = [10008050] = 7  40      0501a283
