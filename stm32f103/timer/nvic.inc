@ NVIC table
@ DO NOT FORGET USE +1 SHIFT FOR ADDRESS ON THUMB

.word   0x20005000           @     stack pointer
.word   start + 1            @     reset

.word   nvic_error_l0 + 1    @     NMI
.word   nvic_error_l0 + 1    @     HardFault
.word   nvic_error_l0 + 1    @     MemManage
.word   nvic_error_l0 + 1    @     BusFault
.word   nvic_error_l0 + 1    @     UsageFault
.word   nvic_error_l0 + 1    @     ----
.word   nvic_error_l0 + 1    @     ----
.word   0x00000000           @     ----
.word   nvic_error_l0 + 1    @     ----
NVIC_SVCALL:
.word   nvic_error_l0 + 1    @     SVCall
.word   nvic_error_l0 + 1    @     DebugMonitor
.word   nvic_error_l0 + 1    @     ----
.word   nvic_error_l0 + 1    @     PendSV
.word   nvic_error_l0 + 1    @     SysTick


.word   nvic_error_l0 + 1    @  0   WWDG
.word   nvic_error_l0 + 1    @  1   PVD
.word   nvic_error_l0 + 1    @  2   TAMPER
.word   nvic_error_l0 + 1    @  3   RTC
.word   nvic_error_l0 + 1    @  4   FLASH
.word   nvic_error_l0 + 1    @  5   RCC
.word   nvic_error_l0 + 1    @  6   EXTI0
.word   nvic_error_l0 + 1    @  7   EXTI1
.word   nvic_error_l0 + 1    @  8   EXTI2
.word   nvic_error_l0 + 1    @  9   EXTI3
.word   nvic_error_l0 + 1    @ 10   EXTI4
.word   nvic_error_l0 + 1    @ 11   DMA1_Channel1
.word   nvic_error_l0 + 1    @ 12   DMA1_Channel2
.word   nvic_error_l0 + 1    @ 13   DMA1_Channel3
.word   nvic_error_l0 + 1    @ 14   DMA1_Channel4
.word   nvic_error_l0 + 1    @ 15   DMA1_Channel5
.word   nvic_error_l0 + 1    @ 16   DMA1_Channel6
.word   nvic_error_l0 + 1    @ 17   DMA1_Channel7
.word   nvic_error_l0 + 1    @ 18
.word   nvic_error_l0 + 1    @ 19
.word   nvic_error_l0 + 1    @ 20
.word   nvic_error_l0 + 1    @ 21
.word   nvic_error_l0 + 1    @ 22
.word   nvic_error_l0 + 1    @ 23
.word   nvic_error_l0 + 1    @ 24
.word   nvic_error_l0 + 1    @ 25
.word   nvic_error_l0 + 1    @ 26
.word   nvic_error_l0 + 1    @ 27
.word   nvic_error_l0 + 1    @ 28	TIM2
.word   nvic_tim3 + 1        @ 29	TIM3
.word   nvic_error_l0 + 1    @ 30	TIM4
.word   nvic_error_l0 + 1    @ 31	I2C1_EV
.word   nvic_error_l0 + 1    @ 32	I2C1_ER
.word   nvic_error_l0 + 1    @ 33	I2C2_EV
.word   nvic_error_l0 + 1    @ 34	I2C2_ER
.word   nvic_error_l0 + 1    @ 35	SPI1
.word   nvic_error_l0 + 1    @ 36	SPI2
.word   nvic_error_l0 + 1    @ 37	USART1
.word   nvic_error_l0 + 1    @ 38	USART2
.word   nvic_error_l0 + 1    @ 39	USART3
.word   nvic_error_l0 + 1    @ 40	EXTI15_10
.word   nvic_error_l0 + 1    @ 41	RTCAlarm
.word   nvic_error_l0 + 1    @ 42	USBWakeup

nvic_error_l0:
  b   nvic_error_l0

