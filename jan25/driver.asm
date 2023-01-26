;;; Professor Bailey
;;; Spring 2023

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

tolower PROTO


DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
.code


;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...
	
	mov	bx, '!'
	mov	cx, '~' - ' '
top:	

.data
prompt	BYTE	"Enter a character: ", 0
.code

;	mov	dx, OFFSET prompt
;	call	WriteString
;	call	ReadChar

	mov	dx, bx
	inc	bx

	call	WriteChar
	call	tolower

	call	WriteChar
	mov	dl, ' '
	call	WriteChar
	loop	top

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
