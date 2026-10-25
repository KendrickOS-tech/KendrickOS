[BITS 16]
[ORG 0x0000]

start:
    mov ax, 0x0003
    int 0x10
    call clear_screen
    jmp main_loop

main_loop:
    call draw_main_menu
    mov ah, 0x00
    int 0x16

    cmp al, '1'
    je terminal_app
    cmp al, '2'
    je clock_app
    cmp al, '3'
    je calculator_app
    cmp al, '4'
    je guessing_game
    cmp al, '5'
    je dice_roller
    cmp al, '6'
    je rps_game
    cmp al, '7'
    je notepad_app
    cmp al, '8'
    je info_app
    cmp al, '9'
    je reboot
    cmp al, 'q'
    je reboot

    jmp main_loop

reboot:
    int 0x19

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

str_equals:
    push si
    push di
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
    pop di
    pop si
    xor ax, ax
    ret
.equal:
    pop di
    pop si
    mov ax, 1
    ret

print_number:
    push bx
    push cx
    push dx
    cmp ax, 0
    jne .not_zero
    mov al, '0'
    call print_char
    jmp .done
.not_zero:
    mov bx, 10
    xor cx, cx
.loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne .loop
.print:
    pop dx
    mov al, dl
    add al, '0'
    call print_char
    dec cx
    cmp cx, 0
    jne .print
.done:
    pop dx
    pop cx
    pop bx
    ret

parse_number:
    xor ax, ax
.loop:
    mov cl, [si]
    cmp cl, '0'
    jb .done
    cmp cl, '9'
    ja .done
    sub cl, '0'
    mov bx, ax
    shl ax, 1
    mov dx, ax
    shl dx, 2
    add ax, dx
    add ax, cx
    inc si
    jmp .loop
.done:
    ret

parse_expression:
    call parse_number
    push ax
    mov cl, [si]
    cmp cl, '+'
    je .add
    cmp cl, '-'
    je .sub
    cmp cl, '*'
    je .mul
    cmp cl, '/'
    je .div
    mov ax, 0
    ret
.add:
    inc si
    call parse_number
    mov bx, ax
    pop ax
    add ax, bx
    ret
.sub:
    inc si
    call parse_number
    mov bx, ax
    pop ax
    sub ax, bx
    ret
.mul:
    inc si
    call parse_number
    mov bx, ax
    pop ax
    xor dx, dx
    mul bx
    ret
.div:
    inc si
    call parse_number
    cmp ax, 0
    je .zero_div
    mov bx, ax
    pop ax
    xor dx, dx
    mov cx, bx
    cmp cx, 0
    je .zero_div
    mov ax, ax
    cwd
    idiv bx
    ret
.zero_div:
    pop ax
    mov ax, 0
    ret

; ---------------------------------------------------------------------------
; Main menu
; ---------------------------------------------------------------------------

draw_main_menu:
    call clear_screen
    mov dh, 0
    mov dl, 0
    call set_cursor
    mov si, banner
    call print_string
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
    mov dh, 11
    mov dl, 4
    call set_cursor
    mov si, item7
    call print_string
    mov dh, 12
    mov dl, 4
    call set_cursor
    mov si, item8
    call print_string
    mov dh, 13
    mov dl, 4
    call set_cursor
    mov si, item9
    call print_string
    mov dh, 22
    mov dl, 0
    call set_cursor
    mov si, footer
    call print_string
    ret

; ---------------------------------------------------------------------------
; Terminal
; ---------------------------------------------------------------------------

terminal_app:
    call clear_screen
    mov si, term_banner
    call print_string
    call newline
    mov si, term_help
    call print_string
.terminal_loop:
    mov si, term_prompt
    call print_string
    call read_line
    mov si, input_buffer
    cmp byte [si], 0
    je .terminal_loop

    mov di, cmd_help
    call str_equals
    cmp ax, 1
    je .cmd_help

    mov di, cmd_clear
    call str_equals
    cmp ax, 1
    je .cmd_clear

    mov di, cmd_info
    call str_equals
    cmp ax, 1
    je .cmd_info

    mov di, cmd_game
    call str_equals
    cmp ax, 1
    je .cmd_game

    mov di, cmd_about
    call str_equals
    cmp ax, 1
    je .cmd_about

    mov di, cmd_quit
    call str_equals
    cmp ax, 1
    je .terminal_exit

    mov si, unknown_cmd
    call print_string
    call newline
    jmp .terminal_loop

.cmd_help:
    mov si, help_text
    call print_string
    call newline
    jmp .terminal_loop

.cmd_clear:
    call clear_screen
    jmp .terminal_loop

.cmd_info:
    mov si, info_text
    call print_string
    call newline
    jmp .terminal_loop

.cmd_game:
    call guessing_game
    jmp .terminal_loop

.cmd_about:
    call info_app
    jmp .terminal_loop

.terminal_exit:
    mov si, shell_exit
    call print_string
    call newline
    ret

; ---------------------------------------------------------------------------
; Clock
; ---------------------------------------------------------------------------

clock_app:
    call clear_screen
    mov si, clock_banner
    call print_string
    call newline
    mov ah, 0x02
    int 0x1A
    mov al, ch
    call print_clock_byte
    mov al, ':'
    call print_char
    mov al, cl
    call print_clock_byte
    mov al, ':'
    call print_char
    mov al, dh
    call print_clock_byte
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

print_clock_byte:
    push bx
    push cx
    mov bl, 10
    xor ah, ah
    cmp al, 10
    jb .single
    mov ah, 0
    mov cl, al
    mov al, cl
    mov dl, 0
    mov al, cl
    mov ah, 0
    mov ch, 0
    mov cl, 10
    div cl
    mov bl, al
    mov al, ah
    add al, '0'
    call print_char
    mov al, bl
    add al, '0'
    call print_char
    jmp .done
.single:
    add al, '0'
    call print_char
.done:
    pop cx
    pop bx
    ret

; ---------------------------------------------------------------------------
; Calculator
; ---------------------------------------------------------------------------

calculator_app:
    call clear_screen
    mov si, calc_banner
    call print_string
    call newline
    mov si, calc_prompt
    call print_string
    call read_line
    mov si, input_buffer
    call parse_expression
    mov bx, ax
    mov si, calc_result_prefix
    call print_string
    mov ax, bx
    call print_number
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

; ---------------------------------------------------------------------------
; Guessing game
; ---------------------------------------------------------------------------

guessing_game:
    call clear_screen
    mov si, game_banner
    call print_string
    call newline
    mov ah, 0x00
    int 0x1A
    xor dx, dx
    mov ax, cx
    mov bx, 20
    div bx
    inc dx
    mov byte [secret_number], dl
    mov si, game_prompt
    call print_string
    call read_line
    mov si, input_buffer
    call parse_number
    cmp al, 0
    je .invalid
    cmp ax, [secret_number]
    je .win
    jb .low
    mov si, high_msg
    call print_string
    call newline
    jmp .done
.low:
    mov si, low_msg
    call print_string
    call newline
    jmp .done
.win:
    mov si, win_msg
    call print_string
    call newline
    jmp .done
.invalid:
    mov si, invalid_msg
    call print_string
    call newline
.done:
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

; ---------------------------------------------------------------------------
; Dice roller
; ---------------------------------------------------------------------------

dice_roller:
    call clear_screen
    mov si, dice_banner
    call print_string
    call newline
    mov ah, 0x00
    int 0x1A
    xor dx, dx
    mov ax, dx
    mov bx, 6
    div bx
    inc dx
    mov ax, dx
    mov si, dice_prefix
    call print_string
    call print_number
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

; ---------------------------------------------------------------------------
; Rock paper scissors
; ---------------------------------------------------------------------------

rps_game:
    call clear_screen
    mov si, rps_banner
    call print_string
    call newline
    mov si, rps_prompt
    call print_string
    call read_line
    mov si, input_buffer
    call parse_number
    mov bx, ax
    mov ah, 0x00
    int 0x1A
    xor dx, dx
    mov ax, dx
    mov cx, 3
    div cx
    inc dx
    mov ax, dx
    mov cx, ax
    mov ax, bx
    cmp ax, cx
    je .tie
    cmp ax, 1
    je .one
    cmp ax, 2
    je .two
    cmp ax, 3
    je .three
    jmp .bad

.one:
    cmp cx, 2
    je .win
    mov si, rps_lose
    call print_string
    call newline
    jmp .done
.two:
    cmp cx, 3
    je .win
    mov si, rps_lose
    call print_string
    call newline
    jmp .done
.three:
    cmp cx, 1
    je .win
    mov si, rps_lose
    call print_string
    call newline
    jmp .done
.tie:
    mov si, rps_tie
    call print_string
    call newline
    jmp .done
.win:
    mov si, rps_win
    call print_string
    call newline
    jmp .done
.bad:
    mov si, invalid_msg
    call print_string
    call newline
.done:
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

; ---------------------------------------------------------------------------
; Notepad app
; ---------------------------------------------------------------------------

notepad_app:
    call clear_screen
    mov si, notepad_banner
    call print_string
    call newline
    mov si, notepad_text
    call print_string
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

; ---------------------------------------------------------------------------
; System info app
; ---------------------------------------------------------------------------

info_app:
    call clear_screen
    mov si, info_banner
    call print_string
    call newline
    mov si, info_text
    call print_string
    call newline
    mov si, press_any
    call print_string
    mov ah, 0x00
    int 0x16
    ret

banner db "KendrickOS v0.2", 13, 10, 0
line_bar db "----------------------------------------", 13, 10, 0
menu_title db "Desktop Menu", 13, 10, 0
item1 db "[1] Terminal", 13, 10, 0
item2 db "[2] Clock", 13, 10, 0
item3 db "[3] Calculator", 13, 10, 0
item4 db "[4] Guessing Game", 13, 10, 0
item5 db "[5] Dice Roller", 13, 10, 0
item6 db "[6] Rock Paper Scissors", 13, 10, 0
item7 db "[7] Notepad", 13, 10, 0
item8 db "[8] System Info", 13, 10, 0
item9 db "[9] Reboot", 13, 10, 0
footer db "Choose an app. Press a key...", 0

term_banner db "KendrickOS Terminal", 13, 10, 0
term_help db "Commands: help, clear, info, game, about, quit", 13, 10, 0
term_prompt db "root@kendrickos> ", 0
cmd_help db "help", 0
cmd_clear db "clear", 0
cmd_info db "info", 0
cmd_game db "game", 0
cmd_about db "about", 0
cmd_quit db "quit", 0
help_text db "Available commands:", 13, 10,
    "  help   show this menu", 13, 10,
    "  clear  clear screen", 13, 10,
    "  info   system info", 13, 10,
    "  game   guess game", 13, 10,
    "  about  app overview", 13, 10,
    "  quit   exit terminal", 13, 10, 0
unknown_cmd db "Unknown command. Try help.", 13, 10, 0
shell_exit db "Leaving terminal...", 13, 10, 0
info_text db "KendrickOS is a BIOS-driven x86 OS demo. Built in NASM assembly.", 13, 10,
    "Features include terminal, clock, calculator, games, and notes.", 13, 10, 0

clock_banner db "Clock App", 13, 10, 0
calc_banner db "Calculator", 13, 10, 0
calc_prompt db "Enter expression (example: 12+5): ", 0
calc_result_prefix db "Result: ", 0

notepad_banner db "Notepad", 13, 10, 0
notepad_text db "Welcome to KendrickOS!", 13, 10,
    "- Build apps in assembly.", 13, 10,
    "- Keep learning low-level systems.", 13, 10,
    "- Extend the desktop with more tools.", 13, 10, 0

info_banner db "System Info", 13, 10, 0

press_any db "Press any key to continue...", 13, 10, 0

game_banner db "Guessing Game", 13, 10, 0
game_prompt db "Guess a number 1-20: ", 0
low_msg db "Too low!", 13, 10, 0
high_msg db "Too high!", 13, 10, 0
win_msg db "Correct! You win!", 13, 10, 0
invalid_msg db "Invalid input.", 13, 10, 0
secret_number db 0

rps_banner db "Rock Paper Scissors", 13, 10, 0
rps_prompt db "Choose 1=Rock 2=Paper 3=Scissors: ", 0
rps_win db "You win!", 13, 10, 0
rps_lose db "Computer wins!", 13, 10, 0
rps_tie db "It's a tie!", 13, 10, 0

dice_banner db "Dice Roller", 13, 10, 0
dice_prefix db "Rolled: ", 0

input_buffer times 64 db 0
