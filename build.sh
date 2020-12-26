
source config.sh

rm -r build/*
mkdir -p build/objects
mkdir -p build/isoSrc/boot/grub
$XCompPath/i686-elf-as src/boot.s -o build/objects/boot.o ||
    { echo "boot assemble failed"; exit 1; }
$XCompPath/i686-elf-gcc -c src/kernel.c -o build/objects/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra -Isrc ||
    { echo "kernel compile failed"; exit 1; }
$XCompPath/i686-elf-gcc -T src/linker.ld -o build/isoSrc/boot/$OsName.bin -ffreestanding -O2 -nostdlib build/objects/boot.o build/objects/kernel.o -lgcc ||
    { echo "linking failed"; exit 1; }
grub-file --is-x86-multiboot build/isoSrc/boot/$OsName.bin || { echo "the file is not multiboot"; exit 1; }
cp src/grub.cfg build/isoSrc/boot/grub/grub.cfg 
grub-mkrescue -o build/$OsName.iso build/isoSrc ||
    { echo "iso build failed"; exit 1; }
exit 0