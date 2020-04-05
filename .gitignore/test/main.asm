@ stm32f103 usart test by laper_s (from 2019-02-01)

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
    mov32 r0, 0x4005      @ enable AFIO & GPIOA & USART_1
    str   r0, [r1]

    mov32 r1, 0x40010804  @ GPIOA_CRH
    mov32 r0, 0x4b0       @ set PA9 as 50 MHz AF_PP & PA10 as floating input
    str   r0, [r1]

    mov32 r2, 0x40013800

    @ usart setup
    eor   r1, r1
    add   r1, r1, r2      @ USART1_BRR
    add   r1, r1, #0x8
    mov32 r0, 0x1d4c      @ set baudrate to 9600 (sysclk = 72MHz)
    str   r0, [r1]

    mov32 r1, 0x4001380c  @ USART1_CR1
    ldr   r0, [r1]
    orr   r0, 0x2000      @ enable USART1
    str   r0, [r1]

    mov32 r1, 0x4001380c  @ USART1_CR1
    ldr   r0, [r1]
    orr   r0, 0x8         @ enable transmitter
    str   r0, [r1]

.include "sysclk.inc"
    
    mov32 r3, 0x40013800  @ USART1_SR
    mov32 r2, 0x40013804  @ USART1_DR
    adr   r1, __usart_test_message
send_next_byte:
@ while(!TX_buffer_empty)
snb_l0:
    ldrb  r0, [r3]
    and   r0, #0x80
    cmp   r0, #0x80
    bne   snb_l0

    ldrb  r0, [r1], #1
    strb  r0, [r2]
    cmp   r0, #0
    bne   send_next_byte
    
end:
    b     end

__usart_test_message:
.asciz "Hello, world!\n"
