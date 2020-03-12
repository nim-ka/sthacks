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
	beqz $t0, loop_mario_end
	lw $t1, 0x04($t0) # MODEL_MARIO * 4

	lui $t0, %hi(gMarioObject)
	lw $t0, %lo(gMarioObject)($t0)
	beqz $t0, loop_mario_end
	sw $t1, 0x14($t0) # .header.gfx.sharedChild
loop_mario_end:

	# Hack the instrument metadata for the credits sound
	lui $t0, %hi(audio_hijack_book)
	addiu $t0, $t0, %lo(audio_hijack_book)

	lui $t1, %hi(sCodebook)
	addiu $t1, $t1, %lo(sCodebook)

	li $t2, 20
loop_hack_loop:
	beqz $t2, loop_hack_loop_end

	lw $t3, 0x00($t0)
	sw $t3, 0x00($t1)

	addiu $t0, $t0, 4
	addiu $t1, $t1, 4

	addiu $t2, $t2, -1
	b loop_hack_loop
loop_hack_loop_end:

loop_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

glabel audio_hijack_book
	.word 0x00000002         # s32 order
	.word 0x00000002         # s32 npredictors
	.incbin "audio_hijack.table.bin"
	.word 0x00000000
	.word 0x00000000
