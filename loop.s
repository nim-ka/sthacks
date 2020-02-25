glabel loop
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)

	# Set gravity to 4.0f (default)
	li $t0, 0x4080
	lui $t1, %hi(sGravity)
	sh $t0, %lo(sGravity)($t1)

	# Reset Mario's model
	lui $t0, %hi(gLoadedGraphNodes)
	lw $t0, %lo(gLoadedGraphNodes)($t0)
	beqz $t0, loop_ret
	lw $t1, 0x04($t0) # MODEL_MARIO * 4

	lui $t0, %hi(gMarioObject)
	lw $t0, %lo(gMarioObject)($t0)
	beqz $t0, loop_ret
	sw $t1, 0x14($t0) # .header.gfx.sharedChild

loop_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra
