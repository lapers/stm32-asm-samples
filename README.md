# stm32-asm-samples
ARM Assembly samples for stm32

## Running code on your stm32
### Linux:
~~~bash
  arm-none-eabi-as -o main.o main.asm
	arm-none-eabi-objcopy -O binary main.o main.bin
	st-flash write 'main.bin' 0x8000000
~~~
