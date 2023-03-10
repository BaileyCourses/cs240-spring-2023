;;; Professor Bailey
;;; Spring 2023

include cs240.inc
include lib.inc
include gamelib.inc
	
CheckAlarms PROTO
RegisterAlarm PROTO
GameUserAction PROTO	

DOSEXIT = 4C00h
DOS = 21h

TIMER = 1Ch

.8086

.data
	
EXTERNDEF GameOver: BYTE
GameOver BYTE 0

.code

;; NOTE: in code segment

OriginalTimerHandler DWORD	0AAAA5555h

crumb	BYTE	0

NewTimerHandler PROC
	inc	cs:crumb
	jmp	cs:OriginalTimerHandler
NewTimerHandler ENDP

Delay PROC
	push	bx
	push	cx

	mov	cx, 15
toptop:	
	push	cx

	mov	cx, 0
top:	
	inc	bx
	loop	top

	pop	cx
	loop	toptop

	pop	cx
	pop	bx
	ret
Delay ENDP

UserAction PROC
	pushf
	push	ax
	
	call	KeyPress	; Character in AL (or 0 for no character)
	cmp	al, 0		; Was a key pressed?
	je	ignore		; No, return
	
	cmp	al, 27		; Is it the ESC key?
	je	endGame
	
	jmp	ignore
	
endGame:	
	mov	GameOver, 1
	
ignore:	
done:	
	pop	ax
	popf
	ret
UserAction ENDP

GameLoop PROC
	pushf
	push	ax
	
	jmp	cond
top:	
	call	CheckAlarms
;	call	GameUserAction
	call	UserAction
cond:
	cmp	GameOver, 0
	je	top
	
	pop	ax
	popf
	ret
GameLoop ENDP

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	mWriteLn	"Starting configuration"

	mov	al, TIMER
	call	WriteInstalledVector ; AL = interrupt number
	call	NewLine

	mov	bx, OFFSET OriginalTimerHandler
	call	WriteInterruptVector ; CS:BX = vector to display
	call	NewLine

	mWriteLn	"Saving interrupt vector"

	mov	al, TIMER
	mov	bx, OFFSET OriginalTimerHandler
	call	SaveInterruptVector ; AL = interrupt number, CS:BX = location

	mov	bx, OFFSET OriginalTimerHandler
	call	WriteInterruptVector ; CS:BX = vector to display
	call	NewLine

	mWriteLn	"Setting interrupt vector"

	call	InstallTimerHandler
;	mov	al, TIMER
;	mov	dx, OFFSET NewTimerHandler
;	call	SetInterruptVector ; AL = interrupt vector, CS:DX = offset of code

	mov	al, TIMER
	call	WriteInstalledVector ; AL = interrupt number
	call	NewLine

	call	Delay

	mWriteLn	"Restoring interrupt vector"

	call	RestoreTimerHandler
;	mov	al, TIMER
;	mov	bx, OFFSET OriginalTimerHandler
;	call	RestoreInterruptVector ; AL = interrupt number, CS:BX = location

	mov	al, TIMER
	call	WriteInstalledVector ; AL = interrupt number
	call	NewLine

	mov	dh, 0
	mov	dl, cs:crumb
	call	WriteHexWord
	call	NewLine

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP

Tick5 PROC
	push	ax
	push	dx
	
	mWriteLn	"5 clock tick handler called"
	mov	ax, 5
	mov	dx, OFFSET Tick5
	call	RegisterAlarm
	
	pop	dx
	pop	ax
	ret
Tick5 ENDP
	
Tick6 PROC
	mWriteLn	"6 clock tick handler called"
	ret
Tick6 ENDP

demo PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax


	call	InstallTimerHandler

	;; Timer is ticking

	mov	ax, 100
	mov	dx, OFFSET Tick6
	call	RegisterAlarm

	mov	ax, 5
	mov	dx, OFFSET Tick5
	call	RegisterAlarm

top:	
	call	CheckAlarms
	call	KeyPress
	cmp	al, 0
	je	top

	call	RestoreTimerHandler

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
demo ENDP

WriteVideoString PROC
	;; BP = offset of string
	;; AH = row
	;; AL = col
	;; BH = attribute
	;; DX = video page
	pushf
	push	bx
	push	bp
	push	ax
	mov	bl, ds:[bp]
	jmp	cond
top:	
	call	WriteVideoChar
	inc	bp
	inc	al
	mov	bl, ds:[bp]
cond:	
	cmp	bl, 0
	jne	top

	pop	ax
	pop	bp
	pop	bx
	popf
	ret
WriteVideoString ENDP
	

WriteVideoChar PROC
	;; AH = row
	;; AL = col
	;; BL = char
	;; BH = attribute
	;; DX = video page
	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	push	es
	push	si
	push	di
	
	mov	si, 0B800h
	mov	es, si
	mov	si, bx
	shl	al, 1
	mov	cl, 12
	shl	dx, cl
	add	dl, al
	mov	di, dx

	mov	bl, ah
	mov	bh, 0
	mov	ax, 160
	mul	bx
	add	di, ax

	mov	es:[di], si

	pop	di
	pop	si
	pop	es
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	popf
	ret
WriteVideoChar ENDP

.data
Splash	BYTE '--------------------------------------------------------------------------------', 0
	BYTE '          X                                                                     ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                             This is my cool spash screen                       ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '                                                                                ', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '|                                                                              |', 0
	BYTE '--------------------------------------------------------------------------------', 0
.code

ShowScreen PROC
	;; AX = offset
	;; DX = page
	;; BH = attribute
	
	mov	bp, ax
	mov	ah, 0
	mov	al, 0
	mov	cx, 0
	jmp	cond
top:	
	;; BP = offset of string
	;; AH = row
	;; AL = col
	;; BH = attribute
	;; DX = video page
	call	WriteVideoString

	add	bp, 81
	inc	ah
	inc	cx
cond:
	cmp	cx, 25
	jl	top

	ret
ShowScreen ENDP


.data
message	BYTE "Computer Science is a Team SPORT!", 0
.code

game PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax

	;; Start of DOS program...

	call	CursorOff

 	mov	ax, 3
 	mov	dx, OFFSET MoveCharacter
; 	call	RegisterAlarm

	call	InstallTimerHandler

;	call	SplashScreen
;	call	GameScreen

;	call	GameLoop

 	mov	al, 1
 	call	ChangeVideoPage

	mov	ax, OFFSET Splash
	mov	dx, 1
	mov	bh, 00010111b
	call	ShowScreen

	jmp	over
	mov	dx, 1
	mov	ah, 12
	mov	al, 10
	mov	bl, '!'
	mov	bh, 11110001b
	mov	bp, OFFSET message
	call	WriteVideoString
over:	
	call	ReadCharNoEcho	; Returns in AL

 	mov	al, 0
 	call	ChangeVideoPage

	call	RestoreTimerHandler
	call	CursorOn

	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
game ENDP
END game
