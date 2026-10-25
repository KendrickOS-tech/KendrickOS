#!/usr/bin/env bash
set -euo pipefail

mkdir -p build

nasm -f bin -o build/bootloader.bin bootloader.asm
nasm -f bin -o build/kernel.bin kernel.asm

rm -f build/kendrickos.img KendrickOS.img

dd if=/dev/zero of=build/kendrickos.img bs=512 count=2880 status=none

dd if=build/bootloader.bin of=build/kendrickos.img conv=notrunc bs=512 count=1 status=none
dd if=build/kernel.bin of=build/kendrickos.img seek=1 conv=notrunc bs=512 count=6 status=none
cp build/kendrickos.img KendrickOS.img

printf "Built build/kendrickos.img and KendrickOS.img\n"
