.include "macros.s"
.include "symbols.s"

.section .text

nop

.include "hook.s"

.include "lib.s"

.include "init.s"
.include "loop.s"
.include "onLPress.s"
.include "onDUPress.s"
.include "onDDPress.s"
.include "onDLPress.s"
.include "onDRPress.s"
.include "tas.s"

.include "page1.s"

.include "load_model_from_geo_hack.s"

.include "xander/geo.s"
.include "xander/model.s"

glabel sRanInit
	.word 0x00000000

glabel sDebug
	.word 0x00000000
	.word 0x00000000

glabel sEnd
	.word 0xEEEEEEEE
