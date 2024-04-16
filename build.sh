
# temporary build script, while figuring out the makefile

mkdir -p build/kernel/obj
mkdir -p build/kernel/obj/drivers

# compile
i686-elf-gcc -c src/kernel/kernel.c -o build/kernel/obj/kernel.o -Iinclude/kernel -ffreestanding -O2 -Wall -Wextra
i686-elf-gcc -c src/kernel/drivers/tty.c -o build/kernel/obj/drivers/tty.o -Iinclude/kernel -ffreestanding -O2 -Wall -Wextra
nasm -felf32 src/arch/i686/boot.asm -o build/kernel/obj/boot.o

# link
i686-elf-gcc -T src/arch/i686/linker.ld -o build/kernel/canoos.kernel -ffreestanding -O2 -nostdlib build/kernel/obj/boot.o build/kernel/obj/drivers/tty.o build/kernel/obj/kernel.o -lgcc

