# KendrickOS

**A custom operating system built entirely in Assembly.**

KendrickOS is a BIOS-based x86 operating system demo written from scratch in assembly. It includes a desktop-style menu, terminal, clock, calculator, multiple mini-games, a notepad, and system info tools.

## ✨ Features

- 🧱 **BIOS bootloader + assembly kernel**
- 🖥️ **Desktop-style menu interface**
- 🖲️ **Terminal with simple commands**
- ⏰ **Clock app**
- 🧮 **Functional calculator**
- 🎮 **Guessing game, dice roller, and rock-paper-scissors**
- 📝 **Notepad and system info apps**
- 💾 **Bootable floppy-style `.img` test image**

## 🛠️ Build the image

From the repository root, run:

```bash
bash build.sh
```

This creates:

- `build/kendrickos.img`
- `KendrickOS.img`

If the file is missing, run the build again. The image is generated locally from the assembly source and is not committed as a binary artifact by default.

## ▶️ Run it in QEMU

```bash
qemu-system-i386 -fda KendrickOS.img
```

You can also upload `KendrickOS.img` to copy.sh or another x86 emulator as a floppy disk image.

## 🧪 Included apps

- `Terminal` — simple shell with commands such as `help`, `clear`, `info`, `game`, `about`, and `quit`
- `Clock` — shows BIOS time
- `Calculator` — accepts expressions like `12+5`, `20-3`, `6*7`, and `30/5`
- `Guessing Game` — pick a number between 1 and 20
- `Dice Roller` — rolls a six-sided die
- `Rock Paper Scissors` — play against the system
- `Notepad` — sample notes screen
- `System Info` — overview screen

## 🚧 Project Status

This is a lightweight educational operating system demo which focuses on bootloading, BIOS services, text-mode apps, and low-level assembly design.

## 📜 License

KendrickOS is licensed under the [MIT License](LICENSE).

---

**KendrickOS — Built from scratch. Written in Assembly.**
