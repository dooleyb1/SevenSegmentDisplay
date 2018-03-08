	AREA	AsmTemplate, CODE, READONLY
	IMPORT	main

; sample program makes the 4 LEDs P1.16, P1.17, P1.18, P1.19 go on and off in sequence
; (c) Mike Brady, 2011.

	EXPORT	start
start

IODIR0	EQU	0xE0028008
IOSET0	EQU	0xE0028004
IOCLR0	EQU	0xE002800C
IOPIN0  EQU 0xE0028000
PINSEL0 EQU 0xE002C000

	LDR R0,=PINSEL0
	LDR R1,=0x00000000
	STR R1,[R0]				;Select port 0 as GPIO mode
	LDR R0,=IODIR0
	LDR R1,=0X0000FF00		;Mask to select P.08 as start pin of output
	STR R1, [R0]			
	
	LDR R4, =array			;array.address
	LDR R5, =arrayN
	LDR R5, [R5]			;arraySize
reset	
	LDR R6, =0				;counter

while
	CMP R6, R5				;while(counter<=arraySize)
	BGE reset
	
	LDR R2,=IOSET0			;Set address
	LDR R3, [R4, R6, LSL #2];value = valAt(array.startAddress+offset)
	STR R3,[R2]				;Make pin = value

delay
	;delay for about a half second
	ldr	R8,=0x2000000
dloop	subs	R8,R8,#1
	bne	dloop
	
	LDR R2,=IOCLR0			;Clear address
	STR R3, [R2]			;Clear pins
	ADD R6, R6, #1			;counter++
	B while
	
stop	B	stop

	AREA	TestArray, DATA, READWRITE

; Array Size
arrayN	DCD	16

; Array Elements
array	DCD	0x00003F00,0x00000600,0x00005B00,0x00004F00,0x00006600,0x00006D00,0x00007D00,0x00000700,0x00007F00,0x00006F00,0x00007700,0x00007C00,0x00003900,0x00005E00,0x00007900, 0x00007100

	END