.macro glabel label
	.global \label
	.balign 4
	\label:
.endm

.macro bkpt
	jal setDebug
.endm

.macro stub func
	lui $t7, %hi(\func\())
	addiu $t7, %lo(\func\())
	lui $t8, 0x03e0
	ori $t8, $t8, 0x0008
	sw $t8, ($t7)
	sw $zero, 4($t7)
.endm

.macro data name
	glabel \name\()_data
		.incbin "audio/\name\().bin"
.endm

.macro book name
	glabel \name\()_book
		.word 0x00000002         # s32 order
		.word 0x00000002         # s32 npredictors
		.incbin "audio/\name\().table.bin"
		.word 0x00000000
		.word 0x00000000
.endm

.macro tileref n
	.word 0x07000000 + 0xc80 * \n
	.word tile
.endm

.macro page2_tile n
	glabel page2_tile_\n
		.incbin "page2/cake.\n\().rgba16"
.endm

.macro page2_tileref n
	.word 0x07000000 + 0xc80 * \n
	.word page2_tile_\n
.endm

.macro page3_tile n
	glabel page3_tile_\n
		.incbin "page3/cake.\n\().rgba16"
.endm

.macro page3_tileref n
	.word 0x07000000 + 0xc80 * \n
	.word page3_tile_\n
.endm

.macro seg2 n
	glabel seg2_\n
		.incbin "segment2.\n\().rgba16"
.endm

.macro hack_seg2 n offset
	lui $t1, %hi(seg2_\n\())
	addiu $t1, $t1, %lo(seg2_\n\())
	xor $t1, $t1, $t2
	sw $t1, %lo(0x8006C680 + \offset\())($t0)
.endm

.macro tas level area node rng x1 y1 desc1 x2 y2 desc2 name loadframe
	glabel \name\()_tas
		.word \level
		.word \area
		.word \node
		.word \rng
		.word \name\()_desc1
		.word \name\()_desc2
		.word 0x00000000 # frame
		.incbin "\name\().m64", (0x400 + \loadframe * 4)
		.word 0xFFFFFFFF

	glabel \name\()_desc1
		.word \x1
		.word \y1
		.asciz "\desc1"

	glabel \name\()_desc2
		.word \x2
		.word \y2
		.asciz "\desc2"
.endm
