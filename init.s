glabel init
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

	# Disable star select
	li $t0, 0x24020000
	lui $t1, %hi(sDisableStarSelectInst)
	sw $t0, %lo(sDisableStarSelectInst)($t1)

	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra
