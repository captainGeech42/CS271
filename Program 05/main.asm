TITLE Program Template     (main.asm)

; Author: Alexander Nead-Work
; Last Modified:
; OSU email address: neadwora@oregonstate.edu
; Course number/section: CS 271, section 400
; Project Number: 5                Due Date: 11/18/2018
; Description: Compute & sort a list of random numbers

INCLUDE Irvine32.inc

min=10	;minimum number of random ints (user input)
max=200	;maximum number of random ints (user input)
lo=100	;minimum value of random int
hi=999	;maximum value of random int

.data
sIntro1			BYTE	"Sorting Random Integers",9,9,"Programmed by Alexander Nead-Work",0
sIntro2			BYTE	"This program generates random numbers in the range [100 .. 999]",0
sIntro3			BYTE	"displays the original list, sorts the list, and calculates the",0
sIntro4			BYTE	"median value. Finally, it displays the list sorted in descending order.",0
sInputPrompt	BYTE	"How many numbers should be generated? [10 .. 200]: ",0
sInputError		BYTE	"Invalid input",0
sUnsortedHeader	BYTE	"The unsorted random numbers:",0
sMedian			BYTE	"The median is: ",0
sSortedHeader	BYTE	"The sorted list:",0

request			DWORD	?			;num rands to generate
array			DWORD	max DUP(?)	;array of rands

.code
main PROC
	call	Randomize ;irvine srand

	push	OFFSET sIntro4
	push	OFFSEt sIntro3
	push	OFFSET sIntro2
	push	OFFSET sIntro1
	call	introduction ;introduction(sIntro1, sIntro2, sIntro3, sIntro4)

	push	OFFSET sInputError
	push	OFFSET sInputPrompt
	push	OFFSET request
	call	getData ;getData(&request, sInputPrompt, sInputError)
	call	CrLf

	push	OFFSET array
	push	request
	call	fillArray ;fillArray(request, &array)

	push	OFFSET sUnsortedHeader
	push	OFFSET array
	push	request
	call	displayList ;displayList(request, &array, &str)
	call	CrLf
	call	CrLf

	push	OFFSET array
	push	request
	call	sortArray ;sortArray(request, &array)
	
	push	OFFSET sMedian
	push	OFFSEt array
	push	request
	call	displayMedian ;displayMedian(request, &array, &str)
	call	CrLf

	push	OFFSET sSortedHeader
	push	OFFSET array
	push	request
	call	displayList ;displayList(request, &array, &str)
	
	exit
main ENDP

;Name: introduction
;Description: Prints the introductory statements to the screen
;Registers used: edx
;Pre-conditions: All 4 args point to valid strings
;Post-conditions: None
introduction PROC ;introduction(sIntro1, sIntro2, sIntro3, sIntro4)
	push	ebp
	mov		ebp, esp

	mov		edx, [ebp+08h] ;sIntro1
	call	WriteString
	call	CrLf
	mov		edx, [ebp+0ch] ;sIntro2
	call	WriteString
	call	CrLf
	mov		edx, [ebp+10h] ;sIntro3
	call	WriteString
	call	CrLf
	mov		edx, [ebp+14h] ;sIntro4
	call	WriteString
	call	CrLf
	call	CrLf

	leave
	ret		16 ;4 args pushed
introduction ENDP

;Name: getData
;Description: Gets "request" from the user
;Registers used: eax, edx
;Pre-conditions: request is a DWORD, sInputPrompt and sInputError point to valid strings
;Post-conditions: request will have the int value from the user, [20..100]
getData PROC ;getData(&request, sInputPrompt, sInputError)
	push	ebp
	mov		ebp, esp

	prompt:
	mov		edx, [ebp+0ch] ;sInputPrompt
	call	WriteString
	call	ReadDec
	cmp		eax, max
	jg		bad
	cmp		eax, min
	jl		bad
	jmp		good

	bad:
	mov		edx, [ebp+10h] ;sInputError
	call	WriteString
	call	CrLf
	jmp		prompt

	good:
	mov		ebx, [ebp+08h] ;addr of ret param (arg1)
	mov		[ebx], eax

	leave
	ret		12 ;3 args pushed
getData ENDP

;Name: fillArray
;Description: Gets random ints and stores them in "array"
;Registers used: eax, ecx, esi
;Pre-conditions: array has "request" number DWORDs
;Post-conditions: array will be filled with random ints [100..999]
fillArray PROC ;fillArray(request, &array)
	push	ebp
	mov		ebp, esp

	mov		esi, [ebp+0ch] ;&array
	mov		ecx, [ebp+08h] ;request

	addnum:
	;setup max rand value
	mov		eax, hi
	sub		eax, lo

	;get/store rand value
	call	RandomRange
	add		eax, lo
	mov		[esi], eax

	;inc array
	add		esi, 4 ;array of DWORDs

	;loop
	loop	addnum

	leave
	ret		8 ;2 args
fillArray ENDP

;Name: sortArray
;Description: Sorts a given array from largest->smallest via bubble sort
;Registers used: eax, ebx, ecx, edx, edi
;Pre-conditions: array has "request" DWORDs populated
;Post-conditions: array will be sorted largest->smallest
sortArray PROC ;sortArray(request, &array)
	push	ebp
	mov		ebp, esp

	;C code for bubble sort
	;for (int i = 0; i < request; i++) {
	;	for (int j = 1; j < request; j++) {
	;		if (array[j-1] < array[j]) {
	;			swap(array+j-1, array+j);
	;		}
	;	}
	;}

	mov		ecx, [ebp+08h] ;request

	outerloop:
	push	ecx
	mov		ecx, [ebp+08h] ;request
	dec		ecx
	mov		edi, [ebp+0ch] ;&array | used for inner loop
	add		edi, 4

	innerloop:
	mov		eax, [edi]
	mov		ebx, edi
	sub		ebx, 4
	mov		ebx, [ebx]
	cmp		eax, ebx ;might need to flip
	jl		afterswap

	yesswap:
	push	edi
	mov		eax, edi
	sub		eax, 4
	push	eax
	call	swap ;swap(&src, &dst)

	afterswap:
	add		edi, 4
	loop	innerloop

	;back in outerloop
	pop		ecx
	add		esi, 4
	loop	outerloop

	leave
	ret		8 ;2 args
sortArray ENDP

;Name: swap
;Description: swap two values
;Registers used: eax, ebx (edi and esi are restored at the end)
;Pre-conditions: src and dst point to valid ints
;Post-conditions: src => dst && dst => src
swap PROC ;swap(&src, &dst)
	push	ebp
	mov		ebp, esp
	
	;bkup regs
	push	esi
	push	edi

	;swap vals
	mov		esi, [ebp+08h] ;&src
	mov		edi, [ebp+0ch] ;&dst
	mov		eax, [esi]
	mov		ebx, [edi]
	mov		[esi], ebx
	mov		[edi], eax

	;restore regs
	pop		edi
	pop		esi

	leave
	ret		8 ;2 args
swap ENDP

;Name: displayMedian
;Description: Prints the median for a given array
;Registers used: eax, ecx, edx, esi, edi
;Pre-conditions: array is populated with "request" DWORDs, str is a valid string
;Post-conditions: None
displayMedian PROC ;displayMedian(request, &array, &str)
	push	ebp
	mov		ebp, esp

	;print string
	mov		edx, [ebp+10h] ;&str
	call	WriteString

	;get index
	mov		esi, [ebp+0ch] ;&array
	mov		eax, [ebp+08h] ;request
	cdq
	mov		edi, 2
	div		edi

	;add & flip remainder
	dec		edx
	push	eax
	mov		eax, edx
	mov		edi, -1
	imul	edi
	mov		edx, eax
	pop		eax
	sub		eax, edx

	;multiply eax by 4, add to esi to get first index
	mov		edi, 4 ;sizeof DWORD
	push	edx
	mul		edi
	pop		edx
	add		esi, eax

	;get array value
	mov		ecx, [esi]
	
	;put 4 in eax and multiply by the remainder
	;if 1, we will add the next value
	;if 0, we will add 0 to the index
	mov		eax, 4
	push	edx
	mul		edx
	pop		edx
	add		esi, eax

	;pull the next value or the same value from the array
	add		ecx, [esi]

	;divide to get the avg
	;if request is odd, eax = median * 2
	;if request is even, this will average it
	mov		eax, ecx
	cdq
	mov		edi, 2
	div		edi

	;add the remainder to round up
	add		eax, edx

	;print median
	call	WriteDec
	call	CrLf

	leave
	ret		8 ;2 args
displayMedian ENDP

;Name: displayList
;Description: Prints a given list
;Registers used: eax, ecx, esi, edi
;Pre-conditions: array is populated with "request" DWORDs, str is a valid string
;Post-conditions: None
displayList PROC ;displayList(request, &array, &str)
	push	ebp
	mov		ebp, esp

	;print header
	mov		edx, [ebp+10h] ;&str
	call	WriteString
	call	CrLf

	;setup vars
	mov		eax, [ebp+08h] ;request
	cdq
	mov		edi, 10
	div		edi
	push	edx ;store count for remaining elements on the stack

	mov		esi, [ebp+0ch] ;&array

	;eax now has number of loops of 10 to go through & print
	mov		ecx, eax

	outerprint:
	push	ecx
	
	mov		ecx, 10

	innerprint:
	mov		eax, [esi]
	call	WriteDec
	mov		eax, 9 ;\t
	call	WriteChar
	add		esi, 4
	loop	innerprint

	;back in outerprint
	call	CrLf
	pop		ecx
	loop	outerprint

	;exited main loops, print remaining items
	pop		ecx
	cmp		ecx, 0
	je		fin

	printrem:
	mov		eax, [esi]
	call	WriteDec
	mov		eax, 9 ;\t
	call	WriteChar
	add		esi, 4
	loop	printrem

	fin:
	leave
	ret		12 ;3 args
displayList ENDP

END main
