@ stm32f103 timer & interrupt test by laper_s (from 2019-02-02)

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

    mov32 r1, 0x4002101c  @ RCC_APB1ENR address
    mov32 r0, 0x4         @ enable TIM4
    str   r0, [r1]

    mov32 r1, 0x40011004  @ GPIOC_CRH
    mov32 r0, 0x44344444  @ set PC13 as 50 MHz PP output
    str   r0, [r1]

    mov32 r1, 0x40000824  @ TIM4_CNT
    movw  r0, 0xc8        @ set counter
    strh  r0, [r1]

    mov32 r1, 0x40000828  @ TIM4_PSC
    movw  r0, 0x270f      @ set prescaler
    strh  r0, [r1]

    mov32 r1, 0x4000080c  @ TIM4_DIER
    movw  r0, 0x1         @ enable update interrupt
    strh  r0, [r1]

    mov32 r1, 0xE000E100  @ NVIC_ISER0
    ldr   r0, [r1]
    orr   r0, #0x40000000 @ enable interrupt #30
    str   r0, [r1]

    mov32 r1, 0xE000ED08  @ SCB_VTOR address
    mov32 r0, 0x20000000  @ address to new vectors table
    str   r0, [r1]

    mov32 r1, 0x200000B8  @ TIM4 interrupt address
    adr   r0, tim4_interrupt_observer
    str   r0, [r1]

    mov32 r1, 0x40000800  @ TIM4_CR1
    ldrh  r0, [r1]
    orr   r0, 0x1         @ enable counter
    strh  r0, [r1]
    
    mov32 r1, 0xE000E200  @ NVIC_ISPR0
    ldr   r0, [r1]
    orr   r0, #0x40000000 @ set pending interrupt #30
    str   r0, [r1]

    mov32   r1, 0x4001100c  @ GPIOC_ODR
    mov32   r2, 0xE000E300
    ldr     r0, [r2]
    and     r0, #0x40000000
    cmp     r0, #0x40000000

    itt     eq

    movweq  r0, 0x2000
    streq   r0, [r1]

loop:
    b     loop

tim4_interrupt_observer:
    mov32 r1, 0x40000810  @ TIM4_SR
    movw  r0, 0x0         @ clear interrupt flag
    str   r0, [r1]

    mov32   r1, 0x4001100c  @ GPIOC_ODR
    ldr     r0, [r1]
    and     r0, #0x2000
    cmp     r0, #0x2000

    ite     eq

    movweq  r0, 0x0000
    movwne  r0, 0x2000
    str     r0, [r1]

    bx      lr
