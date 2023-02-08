;;; Professor Bailey
;;; Spring 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h


mWrite MACRO text
	LOCAL string
.data
string	BYTE text, 0
.code	
	push	dx
	mov	dx, OFFSET string
	call	WriteString
	call	NewLine
	pop	dx
ENDM

.8086

.data

	
.code

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mWrite	"Macros rock!"
	mWrite	"They sure do!"


	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
