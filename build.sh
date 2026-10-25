#!/usr/bin/env bash
set -euo pipefail

mkdir -p build

nasm -f bin -o build/bootloader.bin bootloader.asm
nasm -f bin -o build/kernel.bin kernel.asm

# Create a bootable 1.44MB floppy image.
rm -f build/kendrickos.img
dd if=/dev/zero of=build/kendrickos.img bs=512 count=2880 status=none

dd if=build/bootloader.bin of=build/kendrickos.img conv=notrunc bs=512 count=1 status=none
dd if=build/kernel.bin of=build/kendrickos.img seek=1 conv=notrunc bs=512 count=6 status=none

printf "Built build/kendrickos.img\n"
