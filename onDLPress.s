glabel onDLPress
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

	# Hack sound length thingy
	lui $t0, 0x2407
	ori $t0, $t0, 0x00FF
	lui $t1, %hi(sSoundLengthInst)
	sw $t0, %lo(sSoundLengthInst)($t1)

onDLPress_ret:
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra
