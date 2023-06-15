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

    mov eax, 0
    mov ebx, 0
    mov edi, [ebp+8]    ; picture
    mov esi, [ebp+12]   ; width
    mov ecx, [ebp+16]   ; height
    mov edx, [ebp+20]   ; dist

    cmp edx, 0          ; verify, if dist greater than 0
    jle end

    mov eax, esi
    imul eax, ecx
    add edi, eax
    sub edi, 1

loop_row:

    ; set column to the last color of last pixel in row
    ; calc percentage

loop_color:
    mov bl, byte [edi]
    dec edi
    jmp loop_color

end:
    pop esi
    pop edi
    mov esp, ebp
    pop	ebp
	ret