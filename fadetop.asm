;==========================================================
; fadetop - brigthning bmp file (24 bits per pixel)
; Andrzej Pultyn
;==========================================================
section	.text
global fadetop

fadetop:
    ; SETUP
    push ebp
    mov	ebp, esp
    sub esp, 4

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

    mov eax, esi        ; set pointer to last pixel
    imul eax, ecx
    add edi, eax

    inc esi

loop_row:
    xor edx, edx        ; calculate coefficient
    mov eax, ecx
    sub eax, [ebp+16]
    add eax, [ebp+20]
    imul eax, 100
    idiv dword [ebp+20]
    mov [ebp-4], eax

    xor ebx, ebx
    mov ebx, [ebp-4]

loop_color:
    dec edi
    dec esi
    mov edx, 255        ; set up register

    mov bl, byte [edi]  ; load color

    cmp ebx, edx        ; check if
    je loop_color

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

    cmp ecx, 0
    je end

    cmp esi, 0
    jne loop_color

    mov esi, [ebp+12]   ; set element in row count to last
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