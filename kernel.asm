[BITS 16]
[ORG 0x0000]

start:
    cli
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFE
    sti

    mov si, welcome_msg
    call print_string

    ; A minimal kernel loop: stay alive and print nothing else.
    cli
.halt:
    hlt
    jmp .halt

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

welcome_msg db "KendrickOS kernel loaded successfully!", 13, 10, 0
