# KendrickOS

**A custom operating system built entirely in Assembly.**

KendrickOS is a BIOS-based x86 operating system demo written from scratch in assembly. It includes a text-mode desktop shell, a terminal, a clock app, a simple calculator placeholder, and a guessing game, all running in a bootable disk image.

## ✨ Features

- 🧱 **Bootloader + kernel linked together**
- 🖥️ **Desktop-style menu interface**
- 🖲️ **Terminal with simple commands**
- ⏰ **Clock app**
- 🧮 **Calculator app stub**
- 🎮 **Guessing game**
- 💾 **Bootable floppy-style `.img` test image**

## 🛠️ Build and run

From the repository root:

```bash
bash build.sh
```

This assembles the bootloader and kernel and creates a bootable image:

- `build/kendrickos.img`
- `KendrickOS.img`

## 📥 Download the test image

If you want to test it in QEMU or another x86 emulator, download the generated image here:

- [KendrickOS.img](KendrickOS.img)

Example emulator command:

```bash
qemu-system-i386 -fda KendrickOS.img
```

You can also boot the image in VirtualBox or Bochs using the floppy image.

## 🧪 Included apps and shell

- `Terminal` — simple command interface with `help`, `clear`, `echo`, `game`, `about`, and `quit`
- `Clock` — shows current BIOS time
- `Calculator` — placeholder app screen
- `Guessing Game` — pick a number between 1 and 20
- `About` — overview of the OS demo

## 🚧 Project Status

KendrickOS is an educational assembly-based OS project under active development. The current version is a text-mode demo focused on boot sequencing and basic user interface flow.

## 📜 License

KendrickOS is licensed under the [MIT License](LICENSE).

---

**KendrickOS — Built from scratch. Written in Assembly.**
