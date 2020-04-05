@ stm32f407 input test by laper_s (from 2019-01-28)
@ 
@   3v3 -> LED -> PF9
@   GND -> BTN -> PE4

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
    mov32 r1, 0x40023830  @ RCC_AHB1ENR address
    mov32 r0, 0x30        @ enable GPIOF & GPIOE
    str   r0, [r1]

    @ initialize gpio
    mov32 r1, 0x40021000  @ GPIOE_MODER address
    mov32 r0, 0x00000000
    str   r0, [r1]

    mov32 r1, 0x4002100c  @ GPIOE_PUPDR address
    mov32 r0, 0x00000100  @ pull up PE4
    str   r0, [r1]

    mov32 r1, 0x40021400  @ GPIOF_MODER address
    mov32 r0, 0x00040000  @ set PF9 as output
    str   r0, [r1]

loop:
    mov32 r1, 0x40021010  @ GPIOE_IDR
    ldr   r0, [r1]
    tst   r0, 0x00000010

    mov32 r1, 0x40021414  @ GPIOF_ODR address
    
    itt   ne

    movwne  r0, 0x0200    @ switch led off
    strne   r0, [r1]
    
    bne   loop
    
    movw  r0, 0x0000      @ switch led on
    str   r0, [r1]

    b     loop
