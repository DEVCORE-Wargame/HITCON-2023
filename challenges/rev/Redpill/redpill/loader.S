%include "boot.inc"

section loader vstart=KERNEL_BASE_ADDR
    mov sp, LOADER_BASE_ADDR
    mov al, 3
    mov ah, 0
    int 0x10
    xor bx,bx
    mov bx, 0x02
    call nl0
nl0:
    pop ax
    mov ax, nl1
    push ax
    retf
nl1:
    call draw
pass:
    mov cx, 30
    mov dh, 0x11
    mov dl, 18
    mov bx, 0x02
    int 0x10
    add dl, 12
    mov ah,0x2
    int 0x10
    dec ah
    mov cx, 0x0007
    int 0x10

    mov bp, password
read_loop:
    xor ah, ah
    int 0x16
    cmp al, 0x0d
    je check_input
    cmp al, 0x08
    jne ninput
    cmp bp, password
    je read_loop
    mov al, 0x20
    dec bp
    dec dl
    mov byte [bp], 0
    mov ah,0x2
    int 0x10
    mov cx, 1
    mov ah, 0xa
    int 0x10
    jmp read_loop
ninput:
    mov cx, 1
    mov ah, 0xa
    int 0x10
    mov [bp], al
set_cur:
    inc bp
    inc dl
    cmp bp, password_end
    je check_input
    mov ah,0x2
    int 0x10
    jmp read_loop

check_input:
.remove_cursor:
    mov ah, 01
    mov cx, 0x2607
    int 0x10
.nl4:
    pop ax
    mov ax, .nl5
    push ax
    retf
.nl5:
.check:
    mov    ebp, esp
    lea    eax, [blob]
    lea    ecx, [password]
    lea    edi, [blob_end]
    mov    DWORD  [ebp-0x14], eax
    mov    DWORD  [ebp-0x10], edi
.lop1:
    movsx  edx, BYTE  [ecx+0x1]
    movsx  esi, BYTE  [ecx]
    add    ecx, 0x2
    lea    edi, [edx+edx*1]
    lea    ebx, [esi+esi*2]
    imul   edx, edx, 0x7
    sub    ebx, edi
    sub    DWORD  [eax], ebx
    lea    edx, [edx+esi*4]
    sub    DWORD  [eax+0x4], edx
    add    eax, 0x8
    cmp    DWORD  [ebp-0x10], eax
    jne    .lop1
    mov    eax, DWORD  [ebp-0x14]
    xor    edx, edx
    lea    ecx, [eax+0xa8]
.lop2
    add    edx, DWORD  [eax]
    add    eax, 0x4
    cmp    eax, ecx
    jne    .lop2
    mov    eax, edx
    test   eax, eax
    jne    .fail
    jmp    .success
.fail:
    mov bx, 0xcf
    call draw
    mov bp, fail
    mov cx, 30
    mov dh, 0x10
    mov dl, 25
    mov bx, 0x0c
    int 0x10
    jmp .end
.success:
    mov bx, 0x02
    call draw
    mov bp, Admin
    mov cx, 30
    mov dh, 0x10
    mov dl, 25
    mov bx, 0x1f
    int 0x10
.end:
    jmp $
draw:
    mov bp, loadermsg
    mov dh, 0
    mov dl, 0
    mov cx, 1
clean_sc:
    mov ax, 0x1301 
    int 0x10 
    inc dl
    cmp dl, 0xff
    jb clean_sc
    xor dl,dl
    inc dh
    cmp dh, 0x17
    jb clean_sc

    mov bp, loadermsg
    mov dh, 0
    mov dl, 10
banner:
    mov cx, 60
    mov ax, 0x1301 
    int 0x10 
    add bp,60
    add dh,1
    cmp bp, loadermsg_end
    jl banner 
    ret

loadermsg:

db "         oooooooooo.   oooooooooooo oooooo     oooo        ",10,
db "         `888'   `Y8b  `888'     `8  `888.     .8'         ",10,
db "          888      888  888           `888.   .8'          ",10,
db "          888      888  888oooo8       `888. .8'           ",10,
db "          888      888  888             `888.8'            ",10,
db "          888     d88'  888       o      `888'             ",10,
db "         o888bood8P'   o888ooooood8       `8'              ",10,
db "                                                           ",10,
db "                                                           ",10,
db "      .oooooo.     .oooooo.   ooooooooo.   oooooooooooo    ",10,
db "     d8P'  `Y8b   d8P'  `Y8b  `888   `Y88. `888'     `8    ",10,
db "    888          888      888  888   .d88'  888            ",10,
db "    888          888      888  888ooo88P'   888oooo8       ",10,
db "    888          888      888  888`88b.     888            ",10,
db "    `88b    ooo  `88b    d88'  888  `88b.   888       o    ",10,
db "     `Y8bood8P'   `Y8bood8P'  o888o  o888o o888ooooood8    ",0




loadermsg_end:
db  'ACCESS CODE:               ',0
fail:
db  '          ACESS DENY          ',0
Admin:
db  ' Welcome agent, processing.... ',0
password:
   times 42 db 0
password_end:

blob:
dd 66, 755, 124, 813, 73, 890, -39, 1137, -72, 1006, -37, 869, 255, 833, 91, 1059, 226, 775, 69, 1136, 79, 1246, -73, 966, 119, 1077, 95, 1190, 53, 1192, 210, 773, 67, 1143, 181, 773, 132, 1191, 66, 668, -61, 1127
blob_end:
counter:
dd 0
times 0x900-($-$$) db 0