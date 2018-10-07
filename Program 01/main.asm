TITLE Program 01     (main.asm)

; Author: Alexander Nead-Work
; Last Modified: 10/7/2018 @ 13:30 PST
; OSU email address: neadwora@oregonstate.edu
; Course number/section: CS 271, section 400
; Project Number: 1                Due Date: Oct 7, 2018
; Description: Compute the sum, difference, product,
; quotient, and remainder of two given numbers

INCLUDE Irvine32.inc

.data

sHeader			BYTE	9, "Elemenatry Arithmetic", 9, 9, "by Alexander Nead-Work", 0	;header
sPrompt1		BYTE	"Enter 2 numbers, and I'll show you the sum, difference,", 0	;prompt part 1
sPrompt2		BYTE	"product, quotient and remainder.", 0							;prompt part 2
sEC1			BYTE	"**EC: Program repeats until user chooses to quit.", 0			;show 1st extra credit
sEC2			BYTE	"**EC: Program verifies second number less than first.", 0		;show 2nd extra credit
sNum1Prompt		BYTE	"First number: ", 0												;prompt for first num
sNum2Prompt		BYTE	"Second number: ", 0											;prompt for second num
sPlus			Byte	" + ", 0														;plus sign
sMinus			Byte	" - ", 0														;minus sign
sMult			Byte	" x ", 0														;multiplication sign
sDiv			Byte	" / ", 0														;division sign
sRemainder		BYTE	" remainder ", 0												;remainder
sEquals			BYTE	" = ", 0														;equals sign
sEC2Error		BYTE	"The second number must be less than the first!", 0				;If second num > first num, exit w/ error
sExitPrompt		BYTE	"Enter 0 to repeat, or anything else to exit: ", 0				;Prompt to exit/repeat
sFin			BYTE	"Impressed? Bye!", 0											;tagline

vNum1			DWORD	?																;Num 1 value
vNum2			DWORD	?																;Num 2 value
vSum			DWORD	?																;Sum value
vDiff			DWORD	?																;Difference value
vProd			DWORD	?																;Product value
vQuot			DWORD	?																;Quotient value
vRem			DWORD	?																;Remainder value

.code
main PROC

;print header
	mov		edx, OFFSET sHeader
	call	WriteString
	call	CrLf

;print extra credit
	mov		edx, OFFSET sEC1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET sEC2
	call	WriteString
	call	CrLf
	call	CrLf

;print pre-prompt
	mov		edx, OFFSET sPrompt1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET sPrompt2
	call	WriteString
	call	CrLf

;get num 1
get_nums:
	mov		edx, OFFSET sNum1Prompt
	call	WriteString
	call	ReadInt
	mov		vNum1, eax

;get num 2
	mov		edx, OFFSET sNum2Prompt
	call	WriteString
	call	ReadInt
	call	CrLf
	mov		vNum2, eax
	mov		ebx, vNum1
	cmp		eax, ebx
	jge		EC2Exit

;sum
	mov		eax, vNum1
	mov		ebx, vNum2
	add		eax, ebx
	mov		vSum, eax

	mov		eax, vNum1
	call	WriteInt
	mov		edx, OFFSET sPlus
	call	WriteString
	mov		eax, vNum2
	call	WriteInt
	mov		edx, OFFSET sEquals
	call	WriteString
	mov		eax, vSum
	call	WriteInt
	call	CrLf

;difference
	mov		eax, vNum2	;flip the sign
	mov		ebx, -1
	imul	ebx
	mov		ebx, vNum1
	add		ebx, eax
	mov		vDiff, ebx

	mov		eax, vNum1
	call	WriteInt
	mov		edx, OFFSET sMinus
	call	WriteString
	mov		eax, vNum2
	call	WriteInt
	mov		edx, OFFSET sEquals
	call	WriteString
	mov		eax, vDiff
	call	WriteInt
	call	CrLf

;product
	mov		eax, vNum1
	mov		ebx, vNum2
	imul	ebx
	mov		vProd, eax
	
	mov		eax, vNum1
	call	WriteInt
	mov		edx, OFFSET sMult
	call	WriteString
	mov		eax, vNum2
	call	WriteInt
	mov		edx, OFFSET sEquals
	call	WriteString
	mov		eax, vProd
	call	WriteInt
	call	CrLf

;quotient/remainder
	mov		eax, vNum1
	mov		ebx, vNum2
	mov		edx, 0		;this fixes the remainder stuff
	idiv	ebx
	mov		vDiff, eax
	mov		vRem, edx
	
	mov		eax, vNum1
	call	WriteInt
	mov		edx, OFFSET sDiv
	call	WriteString
	mov		eax, vNum2
	call	WriteInt
	mov		edx, OFFSET sEquals
	call	WriteString
	mov		eax, vDiff
	call	WriteInt
	mov		edx, OFFSET sRemainder
	call	WriteString
	mov		eax, vRem
	call	WriteInt
	call	CrLf
	call	CrLf

;check if user wants to run again
	mov		edx, OFFSET sExitPrompt
	call	WriteString
	call	ReadChar
	call	CrLf
	cmp		al, 48
	je		get_nums
	jmp		EOP

;exit if second num > first num
EC2Exit:
	mov		edx, OFFSET sEC2Error
	call	WriteString
	call	CrLf
	call	CrLf

;print footer
EOP:
	mov		edx, OFFSET sFin
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
