;==========================================================
; fadetop - brigthning bmp file
; Andrzej Pultyn
;==========================================================
section	.text
global fadetop

fadetop:
    ; SETUP
    push ebp
    mov	ebp, esp

    mov eax, 0
    mov ebx, 0
    mov edi, [ebp+8]    ; picture
    mov esi, [ebp+12]   ; width
    mov ecx, [ebp+16]   ; height
    mov edx, [ebp+20]   ; dist

    cmp edx, 0          ; verify, if dist greater than 0
    jle end

    mov esi, [ebp+12]   ; set column to the last color of last pixel in row
    imul esi, 3

    add edi, esi        ; set pointer to the last element of data
    add edi, ecx

loop_row:
    mov esi, [ebp+12]   ; set column to the last color of last pixel in row
    imul esi, 3

    mov edx, 0          ; calculate the percentage
    add eax, ecx
    sub eax, [ebp+16]
    add eax, [ebp+20]

    mov dword [ebp-4], eax

    fld dword [ebp-4]
    fld dword [ebp+20]
    fdiv ST0, ST1

loop_color:
    cmp byte [edi], 0
    jl done_pixel

    mov ebx, 255
    sub al, byte [edi]

    mov dword [ebp-8], ebx
    fld dword [ebp-8]
    fdiv ST0, ST1

done_pixel:
    dec edi
    dec esi

    test esi, esi
    jnz loop_color

    dec ecx

    mov ebx, [ebp+16]
    sub ebx, [ebp+20]
    cmp ecx, ebx
    jge loop_row

    test ecx, ecx
    jnz loop_row

end:
    pop esi
    pop edi
    mov esp, ebp
    pop	ebp
	ret