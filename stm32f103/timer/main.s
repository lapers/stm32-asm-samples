@ stm32f103 usart test by laper_s (from 2019-02-01)

.thumb
.cpu cortex-m3
.syntax unified

.include "nvic.inc"

b   start

.macro mov32 regnum,number
    movw \regnum,:lower16:\number
    movt \regnum,:upper16:\number
.endm

start:
    mov32 r1, 0x40021018  @ RCC_APB2ENR address
    mov32 r0, 0x10        @ enable GPIOs & AFIO
    str   r0, [r1]

    mov32 r1, 0x40011004  @ GPIOC_CRH address
    mov32 r0, 0x44344444  @ set C13 as 50MHz push-pull output
    str   r0, [r1]

.include "sysclk.inc"
    
    mov32 r1, 0x4001100c  @ GPIOC_ODR address
loop:
    movw  r0, 0x0000
    str   r0, [r1]
    bl    ...

    movw  r0, 0x2000
    str   r0, [r1]
    bl    ...
    
    b     loop
    
end:
    b     end
