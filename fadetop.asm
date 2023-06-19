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
    mov esi, [ebp+12]   ; width (px)
    mov ecx, [ebp+16]   ; height
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
    lea edi, [edi + eax]


loop_row:
    ; calculating coefficient for row

    xor edx, edx
    mov eax, ecx
    sub eax, [ebp+16]
    add eax, [ebp+20]
    mov ebx, 100
    mul ebx
    div dword [ebp+20]
    mov [ebp-4], eax

    mov ebx, [ebp-4]
    mov edx, [ebp-12]
    mov esi, [ebp-8]

    sub edi, [ebp-12]    ; skip extra bytes

loop_color:
    ; brightening loop
    cmp esi, 0
    je restart

    cmp ecx, 0
    je end

    dec edi
    dec esi
    mov edx, 255

    mov bl, byte [edi]  ; load color

    cmp ebx, edx
    je loop_color

    ; brightening
    sub edx, ebx
    imul edx, [ebp-4]
    mov eax, edx
    xor edx, edx
    mov ebx, 100
    idiv dword ebx
    xor ebx, ebx
    mov bl, byte [edi]
    add ebx, eax
    mov byte [edi], bl

    cmp esi, 0
    jne loop_color

restart:
    ; moving for next row
    mov esi, [ebp-8]
    dec ecx

    mov edx, [ebp+16]
    sub edx, [ebp+20]

    cmp ecx, edx
    jg loop_row

end:
    ; epilogue
    pop edi
    pop esi
    pop ebx

    mov esp, ebp
    pop	ebp
	ret