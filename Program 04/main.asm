TITLE Program Template     (main.asm)

; Author: Alexander Nead-Work
; Last Modified: 11/05/2018
; OSU email address: neadwora@oregonstate.edu
; Course number/section: CS 271, section 400
; Project Number: 4                Due Date: 11/04/2018 (used 1 grace day)
; Description: Computes & displays composite numbers

INCLUDE Irvine32.inc

lowerLimit=1
upperLimit=400

.data

sIntro1		BYTE	"Composite Numbers",9,"by Alexander Nead-Work",0
sIntro2		BYTE	"Enter the number of composite numbers you would like to see.",0
sIntro3		BYTE	"I'll accept orders for up to 400 composites.",0
sEC1		BYTE	"**EC1: Output is aligned in columns",0
sPrompt		BYTE	"Enter the number of composites to display [1 .. 400]: ",0
sInputError	BYTE	"Out of range. Try again.",0
sEnd		BYTE	"Results certified by Alexander Nead-Work. Goodbye.",0

vCount		DWORD	?
vNumToTest	DWORD	0

.code
main PROC

	call	introduction

	call	getUserData

	call	showComposites

	call	farewell

	exit

main ENDP

introduction PROC USES edx

	mov		edx, OFFSET sIntro1
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET sEC1
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET sIntro2
	call	WriteString
	call	CrLf

	mov		edx, OFFSET sIntro3
	call	WriteString
	call	CrLf
	call	CrLf

	ret

introduction ENDP

getUserData PROC USES eax edx

	getInput:
	mov		edx, OFFSET sPrompt
	call	WriteString
	call	ReadDec

	call	validate
	cmp		ebx, 1
	je getInput ;take jump if bad input
	
	mov		vCount, eax
	
	call	CrLf

	ret

getUserData ENDP

;int to check in eax
;0 in ebx is good, 1 is bad
validate PROC USES edx

	cmp		eax, upperLimit
	jg		bad
	cmp		eax, lowerLimit
	jl		bad
	jmp		good

	bad:
	mov		edx, OFFSET sInputError
	call	WriteString
	call	CrLf
	mov		ebx, 1
	ret

	good:
	xor		ebx, ebx
	ret

validate ENDP

showComposites PROC USES eax ebx ecx edx esi

	;ebx is num printed
	;edx is num to test
	;ecx is loop counter

	mov		ecx, vCount
	xor		edx, edx
	xor		ebx, ebx

	printNums:
	mov		edx, vNumToTest
	inc		edx
	mov		vNumToTest, edx
	call	isComposite
	cmp		eax, 0
	jne		no
	jmp		yes

	no:
	inc		ecx
	loop	printNums
	jmp		done

	yes:
	inc		ebx
	mov		eax, ebx
	mov		esi, 10
	cdq
	div		esi
	cmp		edx, 0
	je		printNewLine
	mov		eax, vNumToTest
	call	WriteDec
	mov		eax, 9 ;tab
	call	WriteChar
	loop	printNums
	jmp		done

	printNewLine:
	call	CrLf
	loop	printNums
	jmp		done

	done:
	call	CrLf
	call	CrLf
	ret

showComposites ENDP

;0 in ebx is good, 1 is bad
isComposite PROC USES ebx ecx edx esi

	mov		eax, vNumToTest

	;this is super inefficient but it works
	;divide everything until you get to n/2
	;if nothing divides, return 1, else return 0

	;n<4 is false, and might mess this up, so just return out
	cmp		eax, 4
	jl		bad

	;compute n/2
	mov		ebx, 2
	cdq
	div		ebx
	;eax now has n/2
	mov		ecx, eax
	;ecx = loop counter = n/2
	mov		esi, eax
	;esi now has saved n/2
	;dec		ecx
	inc		esi
	;|ecx-esi| > 0, avoid div by 0

	;esi is n/2
	;ebx is n
	checkLoop:
	mov		ebx, ecx
	sub		ebx, esi
	imul	ebx, -1
	inc		ebx
	;call	WriteDec
	;ebx is 1..n/2

	mov		eax, vNumToTest
	cdq
	div		ebx

	cmp		edx, 0
	je		good
	;jmp taken if no remainder, meaning we have a composite

	loop	checkLoop

	bad:
	mov		eax, 1
	ret

	good:
	xor		eax, eax
	ret

isComposite ENDP

farewell PROC

	mov		edx, OFFSET sEnd
	call	WriteString
	ret

farewell ENDP

END main
