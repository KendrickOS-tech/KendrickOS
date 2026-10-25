# KendrickOS

**A custom operating system built entirely in Assembly.**

KendrickOS is a from-scratch operating system project focused on low-level programming, classic PC architecture, and learning how operating systems work under the hood.

## ✨ Features

- 🔧 **100% Assembly** — All operating system code is written in Assembly.
- 🖥️ **Built from Scratch** — Developed as an independent operating system project.
- ⚙️ **Low-Level Control** — Exploring direct hardware interaction and system resources.
- 🎨 **Classic PC Style** — Inspired by classic desktop operating systems.

## 🛠️ Technology

- **Language:** Assembly (ASM)
- **Architecture:** x86
- **Boot Method:** Legacy BIOS

## Bootloader and kernel

This repository now includes a minimal BIOS-based bootloader and kernel connected together:

- `bootloader.asm` loads the kernel from disk into memory at `0x1000:0x0000` and jumps into it.
- `kernel.asm` is the entry point for the loaded kernel and prints a welcome message.
- `build.sh` assembles both files and creates a bootable `build/kendrickos.img` image.

Run the build with:

```bash
bash build.sh
```

## 🚧 Project Status

KendrickOS is currently under development. Features and compatibility may change as development continues.

## 📦 Source Code

The source code will be made available on GitHub as development progresses.

## 📜 License

KendrickOS is licensed under the [MIT License](LICENSE).

You are free to use, copy, modify, merge, publish, distribute, sublicense, and sell copies of the software, subject to the terms of the MIT License.

---

**KendrickOS — Built from scratch. Written in Assembly.**
