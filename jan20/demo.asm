;;; Professor Bailey
;;; Spring 2023

;;; Skeleton program

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086				; Restrict instructions to 8086

.data
	
hello	BYTE	"Hello, world!", 0
goodbye	BYTE	"Goodbye, world!", 0

;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here

;;; Entry point for the program

hi PROC
	push	cx
	push	dx

	mov	dx, OFFSET hello
	call	WriteString
	call	NewLine

	pop	dx
	pop	cx
	ret
hi ENDP

first PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	call	hi
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
first ENDP
END first
