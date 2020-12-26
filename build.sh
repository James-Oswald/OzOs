export XCompPath=/home/james/os/cross/bin
export OsName=OsOs 

rm build/*
$XCompPath/i686-elf-as src/boot.s -o build/boot.o ||
    { echo "boot assemble failed"; exit 1; }
$XCompPath/i686-elf-gcc -c src/kernel.c -o build/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra ||
    { echo "kernel compile failed"; exit 1; }
$XCompPath/i686-elf-gcc -T src/linker.ld -o build/$OsName.bin -ffreestanding -O2 -nostdlib build/boot.o build/kernel.o -lgcc ||
    { echo "linking failed"; exit 1; }
if grub-file --is-x86-multiboot build/$OsName.bin; then
    echo multiboot confirmed
else
    echo the file is not multiboot
    exit 1
fi
exit 0