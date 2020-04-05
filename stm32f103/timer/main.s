@ stm32f103 interrupt test by laper_s (from 2020-04-05)
@ toggle led on pin c13 on externall interrupt from pin a0

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
  mov32 r0, 0x11        @ enable GPIOs & AFIO
  str   r0, [r1]

  mov32 r1, 0x40011004  @ GPIOC_CRH address
  mov32 r0, 0x44344444  @ set C13 as 50MHz push-pull output
  str   r0, [r1]

.include "sysclk.inc"

  @ configure TIM3
  mov32 r1, 0x4002101C  @ RCC_APB1ENR address
  mov32 r0, 0x2         @ enable TIM3
  str   r0, [r1]

  mov32 r1, 0x40000428  @ TIM3_PSC address
  mov32 r0, 7199        @ prescaler
  str   r0, [r1]

  mov32 r1, 0x4000042C  @ TIM3_ARR address
  mov32 r0, 9999        @ counter
  str   r0, [r1]

  mov32 r1, 0x4000040C  @ TIM3_DIER address
  mov32 r0, 0x1         @ update interrupt enable
  str   r0, [r1]



  mov32 r1, 0x40000400  @ TIM3_CR1 address
  mov32 r0, 0x1         @ enable
  str   r0, [r1]

  @ configure NVIC
  mov32 r1, 0xE000E100  @ NVIC_ISER0 address
  mov32 r0, 0x20000000  @ TIM3 enable
  str   r0, [r1]

end:
    b   end

nvic_tim3:
  push  { lr }

  mov32 r1, 0x40000410  @ TIM3_SR address
  ldr   r0, [r1]
  eor   r0, 0x1         @ update interrupt flag drop
  str   r0, [r1]

  mov32 r1, 0x4001100C  @ GPIOC_CRH address
  ldr   r0, [r1]
  eor   r0, 0x2000      @ toggle pin state
  str   r0, [r1]

  pop   { pc }
  