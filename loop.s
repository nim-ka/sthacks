glabel loop
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)

	# Set gravity to 4.0f (default)
	li $t0, 0x4080
	lui $t1, %hi(sGravity)
	sh $t0, %lo(sGravity)($t1)

loop_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra
