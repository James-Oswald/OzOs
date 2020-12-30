#!/bin/bash

curDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $curDir/..
source ./tools/config.cfg

rm -r build/*
mkdir -p build/objects
mkdir -p build/debug
mkdir -p build/asm
mkdir -p build/isoSrc/boot/grub

#compile all assembly source files
for file in $(find ./src -name *.c)
do 
    $XCompPath/i686-elf-gcc $file -o build/objects/$(basename $file).o \
        -std=gnu99 -ffreestanding -O$OptLevel $Debug -c \
        -Isrc -Isrc/coreLib -Isrc/initLib -Isrc/runLib || \
        { echo "compile failed for file $file"; exit 1; }
done

for file in $(find ./src -name *.s)
do 
    $XCompPath/i686-elf-as $Debug $file -o build/objects/$(basename $file).o || \
        { echo "assemble failed for $file"; exit 1; }
done

$XCompPath/i686-elf-gcc -T src/linker.ld -o build/isoSrc/boot/$OsName.bin \
    -ffreestanding -O$OptLevel $Debug -nostdlib $(find ./build/objects -name *.o) -lgcc || \
    { echo "linking failed"; exit 1; }

grub-file --is-x86-multiboot build/isoSrc/boot/$OsName.bin || { echo "the file is not multiboot"; exit 1; }
cp src/grub.cfg build/isoSrc/boot/grub/grub.cfg 
grub-mkrescue -quiet -o build/$OsName.iso build/isoSrc>/dev/null ||
    { echo "iso build failed"; exit 1; }

if [ $Debug = "-g" ]; then
    echo "Debuging is enabled"
    #objcopy -O binary build/debug/$OsName.elf build/isoSrc/boot/$OsName.bin
fi

exit 0