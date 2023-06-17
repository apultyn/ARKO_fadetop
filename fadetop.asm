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
    ; SETUP
    push ebp
    mov	ebp, esp
    sub esp, 12

    push ebx
    push esi
    push edi

    mov edi, [ebp+8]    ; picture, nie do użytku w obliczeniach
    mov esi, [ebp+12]   ; width, nie do użytku w obliczeniach
    mov ecx, [ebp+16]   ; height, nie do użytku w obliczeniach
    mov edx, [ebp+20]   ; dist

    mov eax, 0
    mov ebx, 0

    cmp edx, 0          ; verify, if dist greater than 0
    jle end

    mov eax, [ebp+12]   ; calculate bytes in row to brighten, and added bytes
    imul eax, 3
    mov [ebp-8], eax
    mov esi, eax
    and eax, 0x3
    mov ebx, 4
    sub ebx, eax
    and ebx, 0x3
    mov [ebp-12], ebx

    mov eax, [ebp-8]        ; set pointer to last pixel
    add eax, [ebp-12]
    imul eax, ecx
    add edi, eax


loop_row:
    xor edx, edx        ; calculate coefficient for row
    mov eax, ecx
    sub eax, [ebp+16]
    add eax, [ebp+20]
    imul eax, 100
    idiv dword [ebp+20]
    mov [ebp-4], eax

    mov ebx, [ebp-4]    ; load coefficient value
    mov edx, [ebp-12]   ; load extra bytes value
    inc edx
    inc edi

skip_extra:
    dec edi
    dec edx
    test edx, edx
    jnz skip_extra

loop_color:
    cmp esi, 0
    je restart

    cmp ecx, 0
    je end

    dec edi
    dec esi
    mov edx, 255        ; set up register

    mov bl, byte [edi]  ; load color

    cmp ebx, edx        ; check if
    je loop_color

    sub edx, ebx        ; brightening
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
    mov esi, [ebp-8]   ; set element in row count to last
    dec ecx

    mov edx, [ebp+16]
    sub edx, [ebp+20]

    cmp ecx, edx
    jg loop_row

end:
    pop edi
    pop esi
    pop ebx

    mov esp, ebp
    pop	ebp
	ret