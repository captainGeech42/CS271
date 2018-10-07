TITLE Program Template     (main.asm)

; Author: Alexander Nead-Work
; Last Modified:
; OSU email address: neadwora@oregonstate.edu
; Course number/section: CS 271, section 400
; Project Number: 2                Due Date: 10/14/18
; Description: Calculate n number of Fibonacci numbers as specified by the user

INCLUDE Irvine32.inc

.data

sPreamble1		BYTE	"Fibonacci Numbers", 0										;program header 1/2
sPreamble2		BYTE	"Programmed by Alexander Nead-Work", 0						;program header 2/2
sNamePrompt		BYTE	"What's your name? ", 0										;prompt for user's name
sGreeting		BYTE	"Hello, ", 0												;greet the user
sPrePrompt1		BYTE	"Enter the number of Fibonacci terms to be displayed", 0	;preprompt 1/2
sPrePrompt2		BYTE	"Give the number as an integer in the range [1 .. 46].", 0	;preprompt 2/2
sPrompt			BYTE	"How many Fibonacci terms do you want? ", 0					;prompt for num terms
sInputError		BYTE	"Out of range. Enter a number in [1 .. 46]", 0				;input out of range
sExit1			BYTE	"Results certified by Alexander Nead-Work.", 0				;exit 1/2
sExit2			BYTE	"Goodbye, ", 0												;exit 2/2

vUserName		BYTE	50 DUP(0)													;allocate 50 bytes for user name
vNumTerms		BYTE	?															;num fibonacci terms to calculate

.code
main PROC

introduction:
	mov		edx, OFFSET sPreamble1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET sPreamble2
	call	WriteString
	call	CrLf
	call	CrLf

;get/greet the user
	mov		edx, OFFSET sNamePrompt
	call	WriteString
	; get user name (ReadString something something?)
	call	CrLf
	mov		edx, OFFSET sGreeting
	call	WriteString
	mov		edx, OFFSET vuserName
	call	WriteString
	call	CrLf

userInstructions:
	mov		edx, OFFSET sPrePrompt1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET sPrePrompt2
	call	WriteString
	call	CrLf
	call	CrLf

getUserData:
	mov		edx, OFFSET sPrompt
	call	WriteString
	call	ReadInt
	mov		vNumTerms, al
	cmp		eax, 1
	jl		InputError
	cmp		eax, 46
	jg		InputError
	jmp		displayFibs

inputError:
	mov		edx, OFFSET sInputError
	call	WriteString
	call	CrLf
	jmp		GetUserData

displayFibs:

farewell:

	exit
main ENDP

END main
