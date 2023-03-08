;;; Professor Bailey
;;; Spring 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
.code

CopyMem PROC
	;; ES:SI = source
	;; DS:DI = dest
	;; CX = count
	
	pushf
	push	ax
	push	dx
	push	si
	push	di

	mov dx, 0
	jmp cond
top:
	mov	al, es:[si]
	mov	[di], al
	inc	dx
	inc	di
	inc	si
	inc	si
cond:	
	cmp	dx, cx
	jb	top

	pop	di
	pop	si
	pop	dx
	pop	ax
	popf
	ret
CopyMem ENDP

;;; Entry point for the program

.data
buffer	BYTE 80 dup('X'), 0
.code

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	ax, 0B800h
	mov	es, ax
	mov	di, OFFSET buffer
	mov	si, 480
	mov	cx, 80
	call	CopyMem
	mov	dx, OFFSET buffer
	call	WriteString
	call	NewLine

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
