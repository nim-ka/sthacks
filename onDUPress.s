glabel onDUPress
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

	# Set gravity to 0
	li $t0, 0x0000
	lui $t1, %hi(sGravity)
	sh $t0, %lo(sGravity)($t1)

onDUPress_ret:
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra
