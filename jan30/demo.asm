;;; Professor Bailey
;;; Spring 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
motto	BYTE	"Hamilton rocks the DOSBox!", 0
hello	BYTE	"Hello!", 0
garbage	BYTE	01, 02, 03, 04

.code

strlen PROC
	;; DX = offset of the subject string
	;; Returns: AX = the length of the string

	pushf
	push	bx
	push	si
	

	mov	si, 0
	mov	bx, dx
	mov	dh, 34

top:	
	mov	dl, [bx + si]
	cmp	dx, 0
	je	done
	inc	si
	jmp	top

done:	
	mov	ax, si
	
	pop	si
	pop	bx
	popf

	ret
strlen ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	DX, OFFSET motto
	call	strlen
	call	DumpRegs

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
