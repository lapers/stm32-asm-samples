all:
	arm-none-eabi-as --statistics -o bin/main.o main.asm
	arm-none-eabi-objcopy -O binary bin/main.o bin/main.bin
	st-flash write 'bin/main.bin' 0x8000000

assembly:
	arm-none-eabi-as --statistics -o bin/main.o main.asm