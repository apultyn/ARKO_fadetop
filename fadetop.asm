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
    idiv dword [ebp+20]

loop_color:
    mov edx, [edi] ; get color
    dec edi
    dec esi

    mov ebx, dword 255
    sub ebx, edx

end:
    mov esp, ebp
    pop	ebp
	ret