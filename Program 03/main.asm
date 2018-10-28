TITLE Program Template     (main.asm)

; Author: Alexander Nead-Work
; Last Modified: 10/28/2018
; OSU email address: neadwora@oregonstate.edu
; Course number/section: CS 271, section 400
; Project Number: 3                Due Date: 10/28/2018
; Description: Gets a series of negative ints from the user, and returns the count, sum, and average

INCLUDE Irvine32.inc

.const

cLowerLimit		EQU		-100
cUpperLimit		EQU		-1

.data

sPreamble		BYTE	"Welcome to the Integer Accumulator by Alexander Nead-Work", 0								;welcome
sEC1			BYTE	"**EC: Prints line numbers for each user input", 0											;extra-credit statement
sNamePrompt		BYTE	"What is your name? ", 0																	;prompt for user name
sGreeting		BYTE	"Hello, ", 0																				;greet user by name
sValidInput		BYTE	"Please enter numbers in [-100, -1].", 0													;state limitts
sExitStmt		BYTE	"Enter a non-negative number when you are finished to see the results.", 0					;state exit condition
sNumPrompt1		BYTE	"Enter number #", 0																			;prompt for input part 1
sNumPrompt2		BYTE	": ", 0																						;prompt for input part 2
sBadInput		BYTE	"You've entered an invalid number.", 0														;error message if input < -100
sNoInput		BYTE	"There were no valid integers provided", 0													;error for no inputs
sCount1			BYTE	"You entered ", 0																			;statement for # input part 1
sCount2			BYTE	" valid numbers.", 0																		;statement for # input part 2
sSum			BYTE	"The sum of your valid numbers is ", 0														;print sum
sAvg			BYTE	"The rounded average is ", 0																;print average
sExit			BYTE	"Thank you for playing the Integer Accumulator! It's been a pleasure to meet you, ", 0		;good-bye

vName			BYTE	50 DUP(0)																					;variable to store user name
vInput			SDWORD	cLowerLimit																					;variable to store input in
vNumInputs		DWORD	0																							;counter for num inputs
vSum			SDWORD	0																							;sum of inputs

.code
main PROC

;intro
mov		edx, OFFSET sPreamble
call	WriteString
call	CrLf

;print EC
mov		edx, OFFSET sEC1
call	WriteString
call	CrLf
call	CrLf

;get user name
mov		edx, OFFSET sNamePrompt
call	WriteString
mov		ecx, 49
mov		edx, OFFSET vName
call	ReadString

;greet user
mov		edx, OFFSET sGreeting
call	WriteString
mov		edx, OFFSEt vName
call	WriteString
call	CrLf
call	CrLf

;print preamble
mov		edx, OFFSET sValidInput
call	WriteString
call	CrLf
mov		edx, OFFSET sExitStmt
call	WriteString
call	CrLf

getInput:
;get int
mov		edx, OFFSET sNumPrompt1
call	WriteString
mov		eax, vNumInputs
inc		eax
call	WriteDec
mov		edx, OFFSET sNumPrompt2
call	WriteString
call	ReadInt
mov		vInput, eax

;make sure input is good
cmp		eax, cLowerLimit
jl		badInput

;check if we have a positive num
cmp		vInput, cUpperLimit
jg		printInfo

;increase count
inc		vNumInputs

;add sum
add		vSum, eax

;get more input
jmp		getInput

badInput:
;make sure int is good
mov		edx, OFFSET sBadInput
call	WriteString
call	CrLf
jmp		getInput

printInfo:
;check if count is 0
cmp		vNumInputs, 0
jne		printCount
mov		edx, OFFSET sNoInput
call	WriteString
call	CrLf
jmp		goodBye

;print num inputs
printCount:
mov		edx, OFFSET sCount1
call	WriteString
mov		eax, vNumInputs
call	WriteDec
mov		edx, OFFSET sCount2
call	WriteString
call	CrLf

;print sum
mov		edx, OFFSET sSum
call	WriteString
mov		eax, vSum
call	WriteInt
call	CrLf

;compute avg
mov		eax, vSum
cdq
idiv	vNumInputs

;print avg
mov		edx, OFFSET sAvg
call	WriteString
call	WriteInt
call	CrLf

goodBye:
mov		edx, OFFSET sExit
call	WriteString
mov		edx, OFFSET vName
call	WriteString
call	CrLf

exit	; exit to operating system
main ENDP

END main
