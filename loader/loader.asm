; loader.asm

jmp near start

VEDIO_BASE  equ 0xb800

vedio_point dw 0x0000

str_display db 'L', 0x07, 'a', 0x07, 'b', 0x07, 'e', 0x07, 'l', 0x07
string db '1+2+3+4+...+100='

start:
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    mov ax, 0x07c0
    mov ds, ax

    mov ax, 0xb800
    mov es, ax

    cld
    mov si, str_display
    mov di, 0
    mov cx, (string - str_display)
    rep movsb
    mov word [vedio_point], di

    xor ax, ax
    mov ss, ax
    mov sp, ax

    ;打印1+2+3+4+...+100=
    mov si, string
    mov cx, start - string
    mov ah, 0x07
    mov dh, 2
    mov dl, 10
    call print_str

    ;计算结果并打印
    mov dx, ax
    mov cx, 100
    xor ax, ax
    .loop_add:
        add ax, cx
        loop .loop_add
    mov cx, 0x0700
    call print_digit

    jmp $

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 打印字符串
; 参数: ds:si 字符串地址, cx 字符串长度, ah 字符串显示属性,
;      dh:dl 显示位置(行0~24:列0~79)
; 返回: ah:al 字符串结束的位置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_str:
    push bp
    mov bp, sp

    push si
    push di
    push bx
    push cx
    push dx
    push es

    mov bx, VEDIO_BASE
    mov es, bx
    mov bh, ah
    mov ax, 80
    mul dh
    xor dh, dh
    add ax, dx
    mov bl, 2
    mul bl
    mov di, ax
    mov ah, bh
    .loop:
        mov al, [si]
        mov [es: di], ax
        add di, 2
        inc si
        loop .loop
    xor dx, dx
    mov ax, di
    mov bx, 2
    div bx
    mov bl, 80
    div bl
    mov bl, al
    mov al, ah
    mov ah, bl

    .out:
        pop es
        pop dx
        pop cx
        pop bx
        pop di
        pop si
        mov sp, bp
        pop bp
        ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 打印数字
; 参数: ax 要打印的数字, ch 打印的属性,
;      dh:dl 打印的位置(行0~24:列0~79)
; 返回: 无
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print_digit:
    push bp
    mov bp, sp

    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov bx, VEDIO_BASE
    mov es, bx
    mov bx, ax
    mov ax, 80
    mul dh
    xor dh, dh
    add ax, dx
    mov dl, 2
    mul dl
    mov di, ax
    mov ax, bx

    mov si, 0
    .loop_div_num:
        xor dx, dx
        mov bx, 10
        div bx
        mov cl, dl
        add cl, 0x30
        push cx
        inc si
        cmp ax, 0
        jnz .loop_div_num
    mov cx, si
    .loop_print:
        pop ax
        mov [es: di], ax
        add di, 2
        loop .loop_print

    .out:
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        mov sp, bp
        pop bp
        ret

times 510 - ($-$$) db 0
dw 0xaa55