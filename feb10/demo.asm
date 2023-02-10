;;; Professor Bailey
;;; Spring 2023

include cs240.inc
	
DOSEXIT = 4C00h
DOS = 21h

mWriteLine MACRO text
	local string
.data
string	BYTE	text, 0
.code	
	push	dx
	mov	dx, OFFSET string
	call	WriteString
	call	NewLine
	pop	dx
ENDM

FatalError MACRO text
	local string
.data
string	BYTE	text, 0
.code	
	push	dx
	mov	dx, OFFSET string
	call	WriteString
	call	NewLine
	pop	dx
	mov	ax, DOSEXIT
	int	DOS
ENDM

.8086

.data
	
filename	BYTE	"data.dat", 0

.code

openFile PROC
	comment !
AH = 3Dh
AL = access and sharing modes (see #01402)
DS:DX -> ASCIZ filename
CL = attribute mask of files to look for (server call only)

Return:
CF clear if successful
AX = file handle
CF set on error
AX = error code (01h,02h,03h,04h,05h,0Ch,56h) (see #01680 at AH=59h)

	!
	ret
openFile ENDP


	;; Open: 3D
	;; Read: 3F

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	call	OpenFile

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
