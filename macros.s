.macro glabel label
	.global \label
	.balign 4
	\label:
.endm

.macro bkpt
	jal setDebug
.endm
