;;; Professor Bailey
;;; Fall 2022

include cs240.inc		; Include CS 240 library definitions
	
;;; Standard DOS definitions

DOSEXIT = 4C00h
DOS = 21h
BIOS = 10h
TIMER = 8h
	
.8086				; Restrict instructions to 8086

include lib.asm
	
.data
Alarms	LABEL	WORD
	WORD	20 DUP(0)
HandlerCount = ($ - Alarms) / 4
.code

CheckAlarms PROC
	
	pushf
	push	bx
	push	cx
	
	cmp	cs:timerTickCount, 0
	je	notick
	mov	cs:timerTickCount, 0

	;; for (cx = 0; cx < HandlerCount; cx += 4)...
	mov	cx, 0
	mov	bx, OFFSET Alarms ;
	jmp	cond
top:
	cmp	WORD PTR [bx], 0 ; See if this alarm is in use
	je	unused
	dec	WORD PTR [bx]	; Yup. Take a tick away
	cmp	WORD PTR [bx], 0 ; Did it go off?
	ja	running
	call	WORD PTR [bx + 2] ; Yup. Call the alarm code
	
running:	
unused:	
	add	bx, 4		; Skip to the next handler
	inc	cx
cond:	
	cmp	cx, HandlerCount
	jl	top
	
notick:	
	pop	cx
	pop	bx
	popf
	ret
CheckAlarms ENDP

GameLoop PROC
	pushf
	push	ax
	
	jmp	cond
top:	
	call	CheckAlarms
	call	UserAction
cond:
	cmp	GameOver, 0
	je	top
	
	pop	ax
	popf
	ret
GameLoop ENDP

RegisterAlarm PROC
	;; AX=tick count
	;; DX=Handler offset
	
	pushf
	push	bx
	push	cx

	mov	cx, 0
	mov	bx, OFFSET Alarms
	jmp	cond
top:
	cmp	WORD PTR [bx], 0
	jne	used
	mov	WORD PTR [bx], ax
	mov	WORD PTR [bx + 2], dx
	jmp	done
used:	
	inc	cx
	add	bx, 4
cond:	
	cmp	cx, HandlerCount
	jl	top
	
	WriteLn	"Error, out of handler slots"
	
done:	
	pop	cx
	pop	bx
	popf
	ret
RegisterAlarm ENDP

Tick5 PROC
	push	ax
	push	dx
	
	WriteLn	"5 clock tick handler called"
	mov	ax, 5
	mov	dx, OFFSET Tick5
	call	RegisterAlarm
	
	pop	dx
	pop	ax
	ret
Tick5 ENDP
	
Tick6 PROC
	WriteLn	"6 clock tick handler called"
	ret
Tick6 ENDP


game PROC
	call	CursorOff
	
	mov	ax, CharacterSpeed
	mov	dx, OFFSET MoveCharacter
	call	RegisterAlarm
	

	mov	ax, 5
	mov	dx, OFFSET Tick5
;	call	RegisterAlarm
	mov	ax, 6
	mov	dx, OFFSET Tick6
;	call	RegisterAlarm
	
	;; Start of DOS program...

	call	InstallTimerHandler

;	WriteLn	"Press a space to exit"
;	call	ReadCharNoEcho
	call	SplashScreen

	call	GameScreen
	
;	Status	"                                   Begin Play!"

;	mov	ax, 18*3
;	mov	dx, ClearStatus
;	call	RegisterAlarm
	
	call	GameLoop
	
	call	RestoreTimerHandler

	mov	al, 0
	call	ChangeVideoPage
	
	WriteLn	"Program successfully completed."

	call	CursorOn
	ret
game ENDP

main PROC
	mov	ax, @data	; Setup the data segment
	mov	ds, ax
	
	call	Game
	
	mov	ax, DOSEXIT	; Signal DOS that we are done
	int	DOS
main ENDP
END main
