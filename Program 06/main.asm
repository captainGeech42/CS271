TITLE Program Template     (main.asm)

; Author: Alexander Nead-Work
; Last Modified:
; OSU email address: neadwora@oregonstate.edu
; Course number/section: CS 271, section 400
; Project Number: 6A                Due Date: 12/2/2018
; Description: Get user input and manually build ints on it

INCLUDE Irvine32.inc

;Name: getString
;Description: Prints a prompt and gets a string from the user
;Registers used: ecx, edx (both are restored at the end of the macro)
;Pre-conditions: `prompt` points to a valid str, `buffer` is a valid mem location
;Post-conditions: User input stored in buffer
getString MACRO prompt, buffer
	push	ecx
	push	edx

	mov		edx, OFFSET prompt
	call	WriteString

	mov		edx, OFFSET buffer
	mov		ecx, (SIZEOF buffer) - 1 ;nullbyte
	call	ReadString
	
	pop		edx
	pop		ecx
ENDM

;Name: displayString
;Description: Prints a given string
;Registers used: edx (restored at the end of the macro)
;Pre-conditions: String points to a valid string
;Post-conditions: None
displayString MACRO string
	push	edx

	mov		edx, OFFSET string
	call	WriteString

	pop		edx
ENDM

.data
intro1			BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",0
intro2			BYTE	"Written by: Alexander Nead-Work",0
intro3			BYTE	"Please provide 10 unsigned decimal integers.",0
intro4			BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
intro5			BYTE	"After you have finished inputting the raw numbers I will display a list",0
intro6			BYTE	"of the integers, their sum, and their average value.",0
inputPrompt		BYTE	"Please enter an unsigned int: ",0
inputError		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.",0
listHeader		BYTE	"You entered the following numbers:",0
listDelim		BYTE	", ",0
sumHeader		BYTE	"The sum of these numbers is: ",0
avgHeader		BYTE	"The average of these numbers is: ",0
goodbyte		BYTE	"Thanks for playing!"

dwordStr		BYTE	20 DUP(?)
inputArray		DWORD	10 DUP(?)
tempInput		DWORD	?

.code

;Name: 
;Description: 
;Registers used: 
;Pre-conditions:
;Post-conditions: 
main PROC

	push	OFFSET intro6
	push	OFFSET intro5
	push	OFFSET intro4
	push	OFFSET intro3
	push	OFFSET intro2
	push	OFFSET intro1
	call	intro

	push	OFFSET inputPrompt
	push	OFFSET dwordStr
	push	OFFSET tempInput
	push	OFFSET inputArray
	call	buildArray ;buildArray(&array, &tempInput, &dwordStr, &inputPrompt)
	call	CrLf

	push	OFFSET dwordStr
	push	OFFSET inputArray
	call	printArray ;printArray(&array, &buffer)
	call	CrLf

	push	OFFSET tempInput
	push	OFFSET inputArray
	call	sumArray ;sumArray(&array, &result)
	displayString sumHeader
	push	OFFSET dwordStr
	push	OFFSET tempInput
	call	writeVal ;writeVal(num, &buffer)
	call	CrLf

	exit
main ENDP

;Name: intro
;Description: Prints program introduction
;Registers used: edx
;Pre-conditions: str[1-6] point to valid strs
;Post-conditions: None
intro PROC ;intro(&str1, &str2, &str3, &str4, &str5, &str6)
	push	ebp
	mov		ebp, esp
	push	edx

	mov		edx, [ebp+08h]
	call	WriteString
	call	CrLf
	mov		edx, [ebp+0ch]
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, [ebp+10h]
	call	WriteString
	call	CrLf
	mov		edx, [ebp+14h]
	call	WriteString
	call	CrLf
	mov		edx, [ebp+18h]
	call	WriteString
	call	CrLf
	mov		edx, [ebp+1ch]
	call	WriteString
	call	CrLf
	call	CrLf

	pop		edx
	leave
	ret		24
intro ENDP

buildArray PROC ;buildArray(&array, &tempInput, &dwordStr, &inputPrompt)
	push	ebp
	mov		ebp, esp

	mov		ecx, 10
	mov		edi, [ebp+08h]

getints:
	;get int
	push	[ebp+0ch]
	push	[ebp+10h]
	push	[ebp+14h]
	call	readVal ;readVal(&prompt, &buffer, &result)

	;check if valid
	mov		eax, [ebp+0ch]
	cmp		eax, -1
	inc		ecx
	je		getints
	dec		ecx

	;store int
	mov		[edi], eax
	add		edi, 4
	loop	getints

	leave
	ret		16
buildArray ENDP

;Name: readVal
;Description: Reads an unsigned int from the user
;Registers used: eax, ebx, ecx, edx, esi, edi
;Pre-conditions: prompt, buffer, and error are valid strings
;Post-conditions: result int stored in &result
readVal PROC ;readVal(&prompt, &buffer, &result)
	push	ebp
	mov		ebp, esp
	pusha

	mov		eax, [ebp+08h]
	mov		ebx, [ebp+0ch]
	getString	inputPrompt, dwordStr

	;ecx is loop counter
	;ebx is factor
	;edi is result
	;esi is string

	mov		esi, [ebp+0ch]
	mov		edx, esi
	call	StrLength
	add		esi, eax ;get to end of the string
	dec		esi
	mov		ecx, eax
	xor		edi, edi
	mov		ebx, 1
	std

convert:
	lodsb
	;check for valid input
	cmp		eax, 30h
	jb		bad_input
	cmp		eax, 39h
	ja		bad_input

	sub		eax, 30h
	mul		ebx
	add		edi, eax

	;inc factor
	mov		eax, 10
	mul		ebx
	mov		ebx, eax
	loop	convert

	mov		eax, edi
	jmp		fin

bad_input:
	displayString	inputError
	call	CrLf
	mov		eax, -1

fin:
	mov		edi, [ebp+14h]
	mov		[edi], eax
	popa
	leave
	ret		12
readVal ENDP

;Name: writeVal
;Description: Writes an int to the console
;Registers used: eax, ebx, ecx, edx, esi, edi (all restored)
;Pre-conditions: num is a valid int, buffer is a valid string that can hold a DWORD
;Post-conditions: none
writeVal PROC ;writeVal(num, &buffer)
	push	ebp
	mov		ebp, esp
	pusha

	;esi is source int
	;edi is buffer
	;ecx is loop counter
	mov		esi, [ebp+08h]
	mov		esi, [esi]
	mov		edi, [ebp+0ch]
	mov		edx, esi
	mov		ecx, eax
	xor		eax, eax
	mov		ebx, 10

convert:
	mov		eax, esi
	div		ebx
	add		edx, 30h
	mov		esi, eax
	sub		ecx, eax
	mov		eax, edx
	stosb
	cmp		ecx, 0
	jne		convert

	mov		[ebp+0ch], eax

	displayString	dwordStr

	popa
	leave
	ret		8
writeVal ENDP

;Name: printArray
;Description: print an array
;Registers used: eax, ebx, ecx, esi
;Pre-conditions: array points to 10 dwords, result is dword
;Post-conditions: none
printArray PROC ;printArray(&array, &buffer)
	push	ebp
	mov		ebp, esp
	pusha

	displayString listHeader
	call	CrLf

	mov		esi, [ebp+08h]

print:
	;get val
	mov		eax, [esi]

	;print val
	push	[ebp+0ch]
	push	eax
	call	writeVal ;writeVal(num, &buffer)
	displayString listDelim

	;next
	add		esi, 4
	loop	print

	popa
	leave
	ret		8
printArray ENDP

;Name: sumArray
;Description: sum an array
;Registers used: eax, ebx, ecx, esi
;Pre-conditions: array points to 10 dwords, result is dword
;Post-conditions: sum stored in result
sumArray PROC ;sumArray(&array, &result)
	push	ebp
	mov		ebp, esp
	pusha

	xor		eax, eax
	mov		ecx, 10
	mov		esi, [ebp+08h]

sum:
	mov		ebx, [esi]
	add		eax, ebx
	add		esi, 4
	loop	sum

	mov		[ebp+0ch], eax

	popa
	leave
	ret		8
sumArray ENDP

END main
