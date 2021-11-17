        .section .text
        .globl _start;
        len = 9 #Размер массива
        enroll = 2 #Количество обрабатываемых элементов за одну итерацию
        elem_sz = 4 #Размер одного элемента массива

_start:
        la x1, _x
        addi x20, x1, elem_sz*(len) #Адрес элемента, следующего за последним
        lw x31, 0(x1)
        lw x2, 4(x1)
        lw x3, 8(x1)
        addi x1, x1, elem_sz*1
lp:
        bltu x2, x31, lt1
        add x31, x0, x2
lt1:    bltu x3, x31, lt2
        add x31, x0, x3
lt2:
        add x1, x1, elem_sz*enroll
        lw x2, 0(x1)
        lw x3, 4(x1)
        bne x1, x20, lp
lp2: j lp2

        .section .data
_x:     .4byte 0x1
        .4byte 0x2
        .4byte 0x3
        .4byte 0x4
        .4byte 0x5
        .4byte 0x6
        .4byte 0x7
        .4byte 0x31
        .4byte 0x9