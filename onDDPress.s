glabel onDDPress
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)

	# Add wing cap
	lui $t0, %hi(gMarioState)
	lw $t0, %lo(gMarioState)($t0)

	li $t1, 0x00000028 # MARIO_WING_CAP | MARIO_CAP_IN_HAND
	sw $t1, 0x04($t0) # flags

	# Set action to ACT_FLYING
	li $t1, 0x10880899
	sw $t1, 0x0C($t0) # action

	# Change Mario's model
	lui $t0, %hi(gLoadedGraphNodes)
	lw $t0, %lo(gLoadedGraphNodes)($t0)
	lw $t1, 0x208($t0) # MODEL_BREAKABLE_BOX_SMALL * 4

	lui $t0, %hi(gMarioObject)
	lw $t0, %lo(gMarioObject)($t0)
	sw $t1, 0x14($t0) # .header.gfx.sharedChild

	lui $s0, %hi(sSwappedTextures)
	addiu $s0, $s0, %lo(sSwappedTextures)
	lw $t1, 0x00($s0)
	bnez $t1, onDDPress_swapTexturesEnd

	# Change the THI reds cave texture at segmented 0x09001800
	li $a0, 0x09001800
	lui $a1, %hi(sTHITexture)
	addiu $a1, $a1, %lo(sTHITexture)
	li $a2, 0x2020	# 32 x 32
	li $a3, 0x02	# rgba16 has 2 bytes per pixel
	jal swapTextures

	li $v0, 0x00($s0)
onDDPress_swapTexturesEnd:

onDDPress_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

glabel sSwappedTextures
	.word 0x00000000
