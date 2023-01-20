;;; Professor Bailey

include cs240.inc


DOSEXIT = 4C00h
DOS = 21h

.8086

.data

	;; Place data definitions here

.code

main PROC
	;; ax = @data
	mov	ax, @data
	;; ds = ax
	mov	ds, ax

	call	DumpRegsexit
	

	mov	ax, DOSEXIT
	int	DOS
main ENDP


end main
