[BITS 16]
[ORG 0x0000]

start:
    mov ax, 0x0003
    int 0x10
    call clear_screen

main_loop:
    call draw_gui
    mov ah, 0x00
    int 0x16
    cmp al, '1'
    je .terminal
    cmp al, '2'
    je .clock
    cmp al, '3'
    je .calculator
    cmp al, '4'
    je .game
    cmp al, '5'
    je .about
    cmp al, '6'
    je .reboot
    cmp al, 'q'
    je .reboot
    jmp main_loop

.terminal:
    call terminal_app
    jmp main_loop

.clock:
    call clock_app
    jmp main_loop

.calculator:
    call calculator_app
    jmp main_loop

.game:
    call guessing_game
    jmp main_loop

.about:
    call about_app
    jmp main_loop

.reboot:
    int 0x19

init_cursor:
    mov dh, 0
    mov dl, 0
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    ret

clear_screen:
    mov ah, 0x06
    mov al, 0x00
    mov bh, 0x07
    mov ch, 0x00
    mov cl, 0x00
    mov dh, 0x18
    mov dl, 0x4F
    int 0x10
    ret

set_cursor:
    mov ah, 0x02
    mov bh, 0x00
    int 0x10
    ret

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

print_char:
    mov ah, 0x0E
    mov bh, 0x00
    int 0x10
    ret

newline:
    mov al, 13
    call print_char
    mov al, 10
    call print_char
    ret

print_at:
    push dx
    call set_cursor
    call print_string
    pop dx
    ret

read_key:
    mov ah, 0x00
    int 0x16
    ret

read_line:
    pusha
    mov di, input_buffer
    xor cx, cx
.loop:
    mov ah, 0x00
    int 0x16
    cmp al, 13
    je .done
    cmp al, 8
    je .backspace
    cmp al, 32
    jb .loop
    mov [di], al
    inc di
    inc cx
    mov ah, 0x0E
    mov bh, 0x00
    int 0x10
    jmp .loop
.backspace:
    cmp cx, 0
    je .loop
    dec cx
    dec di
    mov byte [di], 0
    mov al, 8
    call print_char
    mov al, 32
    call print_char
    mov al, 8
    call print_char
    jmp .loop
.done:
    mov byte [di], 0
    popa
    ret

trim_newline:
    mov si, input_buffer
    xor cx, cx
.check:
    mov al, [si]
    cmp al, 0
    je .done
    cmp al, 13
    je .done
    cmp al, 10
    je .done
    inc si
    inc cx
    jmp .check
.done:
    mov byte [si], 0
    ret

strcmp_0:
    mov si, input_buffer
    mov di, cmd_help
    .loop:
        mov al, [si]
        mov bl, [di]
        cmp al, bl
        jne .not_equal
        cmp al, 0
        je .equal
        inc si
        inc di
        jmp .loop
.not_equal:
    xor ax, ax
    ret
.equal:
    mov ax, 1
    ret

; ---------------------------------------------------------------------------
; GUI shell drawing
; ---------------------------------------------------------------------------

draw_gui:
    call clear_screen
    mov dh, 0
    mov dl, 0
    call set_cursor
    mov si, banner
    call print_string
    mov dh, 1
    mov dl, 0
    call set_cursor
    mov si, line_bar
    call print_string
    mov dh, 3
    mov dl, 2
    call set_cursor
    mov si, menu_title
    call print_string
    mov dh, 5
    mov dl, 4
    call set_cursor
    mov si, item1
    call print_string
    mov dh, 6
    mov dl, 4
    call set_cursor
    mov si, item2
    call print_string
    mov dh, 7
    mov dl, 4
    call set_cursor
    mov si, item3
    call print_string
    mov dh, 8
    mov dl, 4
    call set_cursor
    mov si, item4
    call print_string
    mov dh, 9
    mov dl, 4
    call set_cursor
    mov si, item5
    call print_string
    mov dh, 10
    mov dl, 4
    call set_cursor
    mov si, item6
    call print_string
    mov dh, 22
    mov dl, 0
    call set_cursor
    mov si, footer
    call print_string
    ret

terminal_app:
    call clear_screen
    mov dh, 0
    mov dl, 0
    call set_cursor
    mov si, term_banner
    call print_string
    call newline
    mov si, term_help
    call print_string
    call newline
    mov si, term_prompt
    call print_string
    call read_line
    mov si, input_buffer

    ; command parser
    cmp byte [si], 'h'
    je .help
    cmp byte [si], 'c'
    je .clear
    cmp byte [si], 'e'
    je .echo
    cmp byte [si], 'g'
    je .game
    cmp byte [si], 'a'
    je .about
    cmp byte [si], 'q'
    je .exit
    cmp byte [si], 0
    je .done

    mov si, unknown_cmd
    call print_string
    call newline
    jmp .done

.help:
    mov si, help_text
    call print_string
    call newline
    jmp .done

.clear:
    call clear_screen
    jmp .done

.echo:
    inc si
    cmp byte [si], ' '
    jne .done
    inc si
    mov si, si
    call print_string
    call newline
    jmp .done

.game:
    call guessing_game
    jmp .done

.about:
    call about_app
    jmp .done

.exit:
    mov si, shell_exit
    call print_string
    call newline
    ret

.done:
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

clock_app:
    call clear_screen
    mov si, clock_banner
    call print_string
    call newline
    mov ah, 0x02
    int 0x1A
    ; CH = hours, CL = minutes, DH = seconds
    mov al, ch
    call print_decimal_byte
    mov al, ':'
    call print_char
    mov al, cl
    call print_decimal_byte
    mov al, ':'
    call print_char
    mov al, dh
    call print_decimal_byte
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

print_decimal_byte:
    push ax
    push bx
    push cx
    mov ah, 0
    mov bl, 10
    mov cl, 0
    mov ch, 0
    cmp al, 10
    jb .single
    mov ah, 0
    mov bl, 10
    xor ah, ah
    div bl
    mov cl, al
    mov al, ah
    add al, '0'
    call print_char
    mov al, cl
    add al, '0'
    call print_char
    jmp .done
.single:
    add al, '0'
    call print_char
.done:
    pop cx
    pop bx
    pop ax
    ret

calculator_app:
    call clear_screen
    mov si, calc_banner
    call print_string
    call newline
    mov si, calc_text
    call print_string
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

about_app:
    call clear_screen
    mov si, about_banner
    call print_string
    call newline
    mov si, about_text
    call print_string
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

guessing_game:
    call clear_screen
    mov si, game_banner
    call print_string
    call newline
    mov ah, 0x00
    int 0x1A
    mov ax, dx
    xor dx, dx
    mov bx, 20
    div bx
    inc dx
    mov byte [secret_number], dl
    mov si, game_prompt
    call print_string
    call read_line
    mov si, input_buffer
    mov ax, 0
.parse:
    mov bl, [si]
    cmp bl, 0
    je .done_parse
    cmp bl, '0'
    jb .done_parse
    cmp bl, '9'
    ja .done_parse
    sub bl, '0'
    mov bh, 0
    add ax, bx
    inc si
    jmp .parse
.done_parse:
    cmp al, 0
    je .bad
    cmp al, [secret_number]
    je .win
    jb .low
    mov si, high_msg
    call print_string
    call newline
    jmp .end
.low:
    mov si, low_msg
    call print_string
    call newline
    jmp .end
.win:
    mov si, win_msg
    call print_string
    call newline
    jmp .end
.bad:
    mov si, invalid_msg
    call print_string
    call newline
.end:
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

banner db "KendrickOS v0.1", 13, 10, 0
line_bar db "----------------------------------------", 13, 10, 0
menu_title db "Main Menu", 13, 10, 0
item1 db "[1] Terminal", 13, 10, 0
item2 db "[2] Clock", 13, 10, 0
item3 db "[3] Calculator", 13, 10, 0
item4 db "[4] Guessing Game", 13, 10, 0
item5 db "[5] About", 13, 10, 0
item6 db "[6] Reboot", 13, 10, 0
footer db "Use 1-6 or q to reboot. Press a key...", 0

term_banner db "KendrickOS Terminal", 13, 10, 0
term_help db "Commands: help, clear, echo, game, about, quit", 13, 10, 0
term_prompt db "root@kendrickos> ", 0
help_text db "Available commands:", 13, 10,
    "  help      show commands", 13, 10,
    "  clear     clear screen", 13, 10,
    "  echo x    print x", 13, 10,
    "  game      launch guess game", 13, 10,
    "  about     show system info", 13, 10,
    "  quit      exit terminal", 13, 10, 0
unknown_cmd db "Unknown command. Try help.", 13, 10, 0
shell_exit db "Leaving terminal...", 13, 10, 0
press_any db "Press any key to continue...", 13, 10, 0

clock_banner db "Clock App", 13, 10, 0
calc_banner db "Calculator App", 13, 10, 0
calc_text db "Simple arithmetic helper available in a future build.", 13, 10, 0
about_banner db "About KendrickOS", 13, 10, 0
about_text db "KendrickOS is a BIOS-based x86 OS demo. It runs in text mode and includes a desktop-style menu, terminal, and mini games.", 13, 10, 0

game_banner db "Guessing Game", 13, 10, 0
game_prompt db "Enter a number from 1 to 20: ", 0
low_msg db "Too low!", 13, 10, 0
high_msg db "Too high!", 13, 10, 0
win_msg db "Correct! You win!", 13, 10, 0
invalid_msg db "Invalid guess.", 13, 10, 0
secret_number db 0
input_buffer times 64 db 0

; pad to fill one sector if needed
; the bootloader is already in sector 1, and kernel data can extend past the first sector.
