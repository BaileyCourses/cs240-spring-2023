;;; Professor Bailey
;;; Spring 2023

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h

.8086

.data
	
.code

tolower PROC
	;; DL - the value to be converted
	;; Returns: the lowercase value in DL

	pushf
	cmp	dl, 'A'
	jb	outside
	cmp	dl, 'Z'
	ja	outside
	add	dl, 'a' - 'A'
outside:
	
	popf
	ret
tolower ENDP

END
