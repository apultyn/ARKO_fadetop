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

    mov esi, [ebp+8]     ; picture
    mov edx, [ebp+12]    ; width
    mov ecx, [ebp+16]    ; height
    mov edi, [ebp+20]    ; dist

    xor eax, eax
    xor ebx, ebx

    pop	ebp
	ret