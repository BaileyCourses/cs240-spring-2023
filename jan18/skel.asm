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

;;; Entry point for the program

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
