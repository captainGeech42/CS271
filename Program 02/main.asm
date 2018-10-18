TITLE Program Template     (main.asm)

; Author: Alexander Nead-Work
; Last Modified:
; OSU email address: neadwora@oregonstate.edu
; Course number/section: CS 271, section 400
; Project Number: 2                Due Date: 10/14/18
; Description: Calculate n number of Fibonacci numbers as specified by the user

INCLUDE Irvine32.inc


.data
cUpperLimit		DWORD	46															;max size

sPreamble1		BYTE	"Fibonacci Numbers", 0										;program header 1/2
sPreamble2		BYTE	"Programmed by Alexander Nead-Work", 0						;program header 2/2
sEC1			BYTE	"**EC: Numbers displayed in aligned columns", 0				;EC #1
sNamePrompt		BYTE	"What's your name? ", 0										;prompt for user's name
sGreeting		BYTE	"Hello, ", 0												;greet the user
sPrePrompt1		BYTE	"Enter the number of Fibonacci terms to be displayed", 0	;preprompt 1/2
sPrePrompt2		BYTE	"Give the number as an integer in the range [1 .. 46].", 0	;preprompt 2/2
sPrompt			BYTE	"How many Fibonacci terms do you want? ", 0					;prompt for num terms
sInputError		BYTE	"Out of range. Enter a number in [1 .. 46]", 0				;input out of range
sExit1			BYTE	"Results certified by Alexander Nead-Work.", 0				;exit 1/2
sExit2			BYTE	"Goodbye, ", 0												;exit 2/2

vUserName		BYTE	50 DUP(0)													;allocate 50 bytes for user name
vNumTerms		DWORD	?															;num fibonacci terms to calculate
vFib1			DWORD	1															;temp var 1 for sequence
vFib2			DWORD	0															;temp var 2 for sequence

.code
main PROC

introduction:
	mov		edx, OFFSET sPreamble1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET sPreamble2
	call	WriteString
	call	CrLf
	mov		edx, OFFSET sEC1
	call	WriteString
	call	CrLf
	call	CrLf

;get/greet the user
	mov		edx, OFFSET sNamePrompt
	call	WriteString
	mov		edx, OFFSET vUserName
	mov		ecx, 49
	call	ReadString
	mov		edx, OFFSET sGreeting
	call	WriteString
	mov		edx, OFFSET vUserName
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
	mov		vNumTerms, eax
	cmp		eax, 1
	jl		InputError
	mov		ebx, cUpperLimit
	cmp		eax, ebx
	jg		InputError
	call	CrLf
	jmp		displayFibs

inputError:
	mov		edx, OFFSET sInputError
	call	WriteString
	call	CrLf
	jmp		GetUserData

displayFibs:
	;edi will be used as a counter for printing the newlines
	mov		ecx, vNumTerms
	dec		ecx
	mov		edi, 1
	mov		eax, 1
	call	WriteDec
	mov		eax, 9
	call	WriteChar
	call	WriteChar
	;weird edge case occurs when n=1 (infinite loop/overflow), so manually handle this case b/f loop
	;probably due to `dec ecx` above
	cmp		vNumTerms, 1
	je		loopEnd
fibLoop:
	mov		eax, vFib1
	add		eax, vFib2
	;fib[n]=eax, fib[n-1]=vfib1, fib[n-2]=vfib2
	mov		ebx, vFib1
	mov		vFib2, ebx
	mov		vFib1, eax
	call	WriteDec
	mov		eax, 9
	call	WriteChar
	;at fib[35], we only need one tab
	cmp		ecx, 11
	jle		no2Tab
	call	WriteChar
no2Tab:
	inc		edi
	cmp		edi, 5
	jne		afterNewLine
	mov		edi, 0
	call	CrLf
afterNewLine:
	loop	fibLoop
loopEnd:
	call	CrLf
	call	CrLf

farewell:
	mov		edx, OFFSET sExit1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET sExit2
	call	WriteString
	mov		edx, OFFSET vUserName
	call	WriteString
	mov		eax, 46
	call	WriteChar
	call	CrLf

	exit
main ENDP

END main
