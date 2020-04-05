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
  mov32 r0, 0x15        @ enable GPIOs & AFIO
  str   r0, [r1]

  mov32 r1, 0x40011004  @ GPIOC_CRH address
  mov32 r0, 0x44344444  @ set C13 as 50MHz push-pull output
  str   r0, [r1]

  mov32 r1, 0x40010800  @ GPIOA_CRL address
  mov32 r0, 0x44444448  @ PA0 as input
  str   r0, [r1]

  mov32 r1, 0x4001080C  @ GPIOA_ODR address
  mov32 r0, 0x00000001  @ PA0 pull-up
  str   r0, [r1]

  mov32 r1, 0x40021004       @ RCC_CFGR address
  ldr   r0, [r1]
  orr   r0, r0, #0x07000000  @ MCO is PLL/2
  str   r0, [r1]

.include "sysclk.inc"

  @ configure EXTI0
  mov32 r1, 0x40010414  @ EXTI_PR address
  mov32 r0, 0x00000001  @ EXTI0 flag drop
  str   r0, [r1]

  mov32 r1, 0x40010400  @ EXTI_IMR address
  mov32 r0, 0x00000001  @ EXTI0 enable
  str   r0, [r1]

  mov32 r1, 0x40010408  @ EXTI_RTSR address
  mov32 r0, 0x00000001  @ EXTI0 trigger on rising edge
  str   r0, [r1]

  mov32 r1, 0x4001040C  @ EXTI_FTSR address
  mov32 r0, 0x00000001  @ EXTI0 trigger on falling edge
  str   r0, [r1]

  mov32 r1, 0x40010008  @ AFIO_EXTICR1 address
  mov32 r0, 0x00000000  @ EXTI0 select PA0
  str   r0, [r1]

  @ configure NVIC
  mov32 r1, 0xE000E100  @ NVIC_ISER0 address
  mov32 r0, 0b01000000  @ EXTI0 enable
  str   r0, [r1]

end:
    b   end

nvic_exti0:
  push  { lr }

  mov32 r1, 0x40010414  @ EXTI_PR address
  mov32 r0, 0x00000001  @ EXTI0 flag drop
  str   r0, [r1]

  mov32 r1, 0x4001100C  @ GPIOC_CRH address
  ldr   r0, [r1]
  eor   r0, 0x2000      @ toggle pin state
  str   r0, [r1]

  pop   { pc }
  