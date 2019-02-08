@ stm32f103 system clock test by laper_s (from 2019-01-26)

.thumb
.cpu cortex-m3
.syntax unified

.word   0x20005000
.word   start + 1

b   start

.macro mov32 regnum,number
    movw \regnum,:lower16:\number
    movt \regnum,:upper16:\number
.endm

start:
    mov32 r1, 0x40021018  @ RCC_APB2ENR address
    mov32 r0, 0x10        @ enable GPIOC
    str   r0, [r1]

    mov32 r1, 0x40011004  @ GPIOC_CRH address
    mov32 r0, 0x44344444  @ set C13 as 50MHz push-pull output
    str   r0, [r1]

.include "sysclk.inc"
    
    mov32 r1, 0x4001100c  @ GPIOC_ODR address
loop:
    movw  r0, 0x0000
    str   r0, [r1]
    bl    delay_hs

    movw  r0, 0x2000
    str   r0, [r1]
    bl    delay_hs
    
    b     loop

delay_hs:                 @ delay half second
    mov32 r2, #5200000
dhs_l0:
    sub   r2, r2, #1
    and   r3, r2, 0xFFFFFFFF
    cmp   r3, #0
    bne   dhs_l0

    bx    lr
