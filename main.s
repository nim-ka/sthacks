.include "macros.s"
.include "symbols.s"

.section .text

nop

.include "hook.s"

.include "lib.s"

.include "init.s"
.include "loop.s"
.include "onZPress.s"
.include "onDUPress.s"
.include "onDDPress.s"

glabel sRanInit
	.word 0x00000000

glabel sDebug
	.word 0x00000000
	.word 0x00000000

glabel sEnd
	.word 0xEEEEEEEE
