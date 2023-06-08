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

    mov edi, [ebp+8]    ; picture
    mov ebx, [ebp+12]   ; width
    mov ecx, [ebp+16]   ; height
    mov edx, [ebp+20]   ; dist

    mov esp, ebp
    pop	ebp
	ret