%define KERNEL_SEGMENT 0x1000
%define KERNEL_OFFSET  0x0000
%define KERNEL_SECTORS 12

[BITS 16]
[ORG 0x7C00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    sti

    mov si, loading_msg
    call print_string

    mov ah, 0x02
    mov al, KERNEL_SECTORS
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    mov dl, 0x00
    mov bx, KERNEL_OFFSET
    mov es, KERNEL_SEGMENT
    int 0x13
    jc disk_error

    mov si, loaded_msg
    call print_string

    jmp KERNEL_SEGMENT:KERNEL_OFFSET

print_string:
    pusha
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0x00
    int 0x10
    jmp .loop
.done:
    popa
    ret

disk_error:
    mov si, disk_error_msg
    call print_string
    cli
    hlt
    jmp $

loading_msg db "Loading KendrickOS kernel...", 13, 10, 0
loaded_msg db "Kernel loaded. Jumping to kernel...", 13, 10, 0
disk_error_msg db "Disk read error.", 13, 10, 0

times 510 - ($ - $$) db 0
dw 0xAA55
