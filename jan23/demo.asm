;;; Professor Bailey
;;; Spring 2023

;;; Skeleton program

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086				; Restrict instructions to 8086

.data
	
;;; Place data definitions here

.code				; Switch to the code segment

;;; Place code here

min PROC
	pushf

	cmp	ax, dx
	ja	AXisbigger
	jmp	done

AXisbigger:	
	mov	ax, dx

done:	
	popf
	ret
min ENDP

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	ax, 6
	mov	dx, -7
	call	min		; Leaves the value in AX

	call	DumpRegs

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
