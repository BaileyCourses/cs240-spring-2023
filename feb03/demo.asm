;;; Professor Bailey
;;; Spring 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
wide	WORD	0
height	WORD	0
.code


doit PROC
	;; AX = height of box
	;; DX = width of box

	mov	wide, dx
	mov	height, ax

	mov	dl, '+'
	call	WriteChar

	mov	cx, wide
bartop:	
	mov	dl, '-'
	call	WriteChar
	loop	bartop

	mov	dl, '+'
	call	WriteChar
	call	NewLine


	mov	cx, height
topp:	
	mov	dl, '|'
	call	WriteChar

	push	cx
	mov	cx, wide
top:	
	mov	dl, ' '
	call	WriteChar
	loop	top

	pop	cx

	mov	dl, '|'
	call	WriteChar
	call	NewLine

	loop	topp

	mov	dl, '+'
	call	WriteChar

	mov	cx, wide
barbottom:	
	mov	dl, '-'
	call	WriteChar
	loop	barbottom

	mov	dl, '+'
	call	WriteChar
	call	NewLine


	ret
doit ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	ax, 3
	mov	dx, 10
	call	doit

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
