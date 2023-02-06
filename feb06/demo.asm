;;; Professor Bailey
;;; Spring 2023

include cs240.inc
	
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

	mov	ax, 65
	call	DumpRegs
	mov	ax, [10]
	mov	ax, 10

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
