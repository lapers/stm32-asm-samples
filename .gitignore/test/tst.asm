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
    mov32 r0, 0x4015      @ enable AFIO & GPIOA & USART_1
    str   r0, [r1]

    mov32 r1, 0x40011004  @ GPIOC_CRH
    mov32 r0, 0x44344444  @ set PC13 as 50 MHz PP output
    str   r0, [r1]

    mov32 r1, 0x40010804  @ GPIOA_CRH
    mov32 r0, 0x4b0       @ set PA9 as 50 MHz AF_PP & PA10 as floating input
    str   r0, [r1]

    @ usart setup
    mov32 r1, 0x40013808  @ USART1_BRR
    mov32 r0, 0x341       @ set baudrate to 9600 (sysclk = 72MHz)
    str   r0, [r1]

    mov32 r1, 0x4001380c  @ USART1_CR1
    ldr   r0, [r1]
    orr   r0, 0x2000      @ enable USART1
    str   r0, [r1]

    mov32 r1, 0x4001380c  @ USART1_CR1
    ldr   r0, [r1]
    orr   r0, 0x8         @ enable transmitter
    str   r0, [r1]



    mov32 r1, 0x4002101c  @ RCC_APB1ENR address
    mov32 r0, 0x4         @ enable TIM4
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

    mov32 r1, 0x200000B8  @ TIM4 interrupt address
    adr   r0, tim4_interrupt_observer
    str   r0, [r1]

    mov32 r1, 0x40000800  @ TIM4_CR1
    ldrh  r0, [r1]
    orr   r0, 0x1         @ enable counter
    strh  r0, [r1]


    
    mov32 r1, 0xE000E100

    mov32 r2, 0x40013800  @ USART1_SR
    mov32 r3, 0x40013804  @ USART1_DR

    adr   r4, __const_hex_vals

    @ while(!TX_buffer_empty)
snb_l0:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l0

    ldr   r0, [r1]
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]

    @ while(!TX_buffer_empty)
snb_l1:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l1

    ldrb  r0, [r1], #1
    lsr   r0, #4
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]
    
    @ while(!TX_buffer_empty)
snb_l2:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l2

    ldrb  r0, [r1]
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]

    @ while(!TX_buffer_empty)
snb_l3:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l3

    ldrb  r0, [r1], #1
    lsr   r0, #4
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]
    
    @ while(!TX_buffer_empty)
snb_l4:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l4

    ldrb  r0, [r1]
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]

@ while(!TX_buffer_empty)
snb_l5:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l5

    ldrb  r0, [r1], #1
    lsr   r0, #4
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]
    
    @ while(!TX_buffer_empty)
snb_l6:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l6

    ldrb  r0, [r1]
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]

    @ while(!TX_buffer_empty)
snb_l7:
    ldrb  r0, [r2]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l7

    ldrb  r0, [r1]
    lsr   r0, #4
    and   r0, #0xF
    ldrb  r0, [r4, r0]
    strb  r0, [r3]

end:
    b     end

tim4_interrupt_observer:
    mov32 r1, 0x40000810  @ TIM4_SR
    movw  r0, 0x0         @ clear interrupt flag
    str   r0, [r1]

    mov32   r1, 0x4001100c  @ GPIOC_ODR
    movw  r0, 0x2000
    str     r0, [r1]

    bx      lr

__const_hex_vals:
.ascii    "0123456789ABCDEF"
