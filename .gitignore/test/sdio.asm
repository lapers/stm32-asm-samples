@ stm32f407 sdio test by laper_s (from 2019-02-05)

.thumb
.cpu cortex-m4
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



__sdio_test_data:
.asciz    "0123456789ABCDEF"
