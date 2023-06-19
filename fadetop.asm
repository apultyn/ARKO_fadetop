;==========================================================
; fadetop - brigthning bmp file (24 bits per pixel)
; Andrzej Pultyn
; variables:
; ebp-4 - coefficient for row
; ebp-8 - bytes in row to brighten
; ebp-12 - extra bytes
;==========================================================
section	.text
global fadetop

fadetop:
    ; Prologue
    push ebp
    mov	ebp, esp
    sub esp, 12

    push ebx
    push esi
    push edi

    mov edi, [ebp+8]    ; picture
    mov ecx, [ebp+12]   ; width (px)
    mov esi, [ebp+16]   ; height
    mov edx, [ebp+20]   ; dist

    ; calculate width of picture in bytes
    mov eax, [ebp+12]
    lea eax, [eax*3]
    mov [ebp-8], eax

    ; calculate extra bytes to skip
    and eax, 0x3
    mov ebx, 4
    sub ebx, eax
    and ebx, 0x3
    mov [ebp-12], ebx

    ; setting pointer to last pixel
    mov eax, [ebp-8]
    add eax, [ebp-12]
    mul dword [ebp+16]
    lea edi, [edi + eax - 1]


loop_row:
    ; calculating coefficient for row

    xor edx, edx
    mov eax, esi
    sub eax, [ebp+16]
    add eax, [ebp+20]
    mov ebx, 100
    mul ebx
    div dword [ebp+20]
    mov [ebp-4], eax

    ; setup loop through colors
    mov ecx, [ebp-8]

    ; skip extra bytes
    sub edi, [ebp-12]

loop_color:
    ; brightening loop
    mov bl, byte [edi]  ; load color

    ; brightening
    mov al, 0xff
    sub al, bl
    mul byte [ebp-4]

    mov bl, 100
    div bl

    mov bl, byte [edi]
    add bl, al
    mov byte [edi], bl

    dec edi

    loop loop_color

restart:
    ; moving for next row
    mov ecx, [ebp-8]
    dec esi

    mov edx, [ebp+16]
    sub edx, [ebp+20]

    cmp esi, edx
    jg loop_row

end:
    ; epilogue
    pop edi
    pop esi
    pop ebx

    mov esp, ebp
    pop	ebp
	ret