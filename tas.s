glabel play_tas
	addiu $sp, $sp, -0x40
	sw $ra, 0x30($sp)
	sw $s0, 0x34($sp)

	lui $t0, %hi(sTasPtr)
	lw $t0, %lo(sTasPtr)($t0)
	lw $t0, ($t0)
	beqz $t0, play_tas_ret

	lw $t1, 0x18($t0) # frame

	addiu $t3, $t0, 0x1c # inputs start
	sll $t2, $t1, 2
	addu $t3, $t3, $t2
	lw $t3, ($t3)
	addiu $t2, $t3, 1
	beqz $t2, play_tas_ret

	addiu $t2, $t1, 1
	sw $t2, 0x18($t0) # frame

	lui $t1, %hi(gControllerPads)
	lh $t2, %lo(gControllerPads)($t1)
	sw $t3, %lo(gControllerPads)($t1)

	andi $t3, $t2, 0x8000
	beqz $t3, play_tas_a_end

	lui $t1, %hi(sGravity)
	sh $zero, %lo(sGravity)($t1)
play_tas_a_end:

	andi $t3, $t2, 0x4000
	beqz $t3, play_tas_b_end

	lui $t1, %hi(sParam1Ptr)
	lw $t3, %lo(sParam1Ptr)($t1)
	addiu $t3, $t3, 4
	sw $t3, %lo(sParam1Ptr)($t1)

	lui $t1, %hi(sParam2Ptr)
	lw $t3, %lo(sParam2Ptr)($t1)
	addiu $t3, $t3, 4
	sw $t3, %lo(sParam2Ptr)($t1)
play_tas_b_end:

	andi $t3, $t2, 0x2000
	beqz $t3, play_tas_z_end

	lui $t1, %hi(sParam1Ptr)
	lw $t3, %lo(sParam1Ptr)($t1)
	addiu $t3, $t3, -4
	sw $t3, %lo(sParam1Ptr)($t1)

	lui $t1, %hi(sParam2Ptr)
	lw $t3, %lo(sParam2Ptr)($t1)
	addiu $t3, $t3, -4
	sw $t3, %lo(sParam2Ptr)($t1)
play_tas_z_end:

	lui $t1, %hi(sRPressed)
	sw $zero, %lo(sRPressed)($t1)

	andi $t3, $t2, 0x0010
	beqz $t3, play_tas_r_end

	li $t3, 1
	lui $t1, %hi(sRPressed)
	sw $t3, %lo(sRPressed)($t1)
play_tas_r_end:

	lui $t1, %hi(sCUPressed)
	sw $zero, %lo(sCUPressed)($t1)

	andi $t3, $t2, 0x0008
	beqz $t3, play_tas_cu_end

	li $t3, 1
	lui $t1, %hi(sCUPressed)
	sw $t3, %lo(sCUPressed)($t1)
play_tas_cu_end:

	lui $t1, %hi(sCDPressed)
	sw $zero, %lo(sCDPressed)($t1)

	andi $t3, $t2, 0x0004
	beqz $t3, play_tas_cd_end

	li $t3, 1
	lui $t1, %hi(sCDPressed)
	sw $t3, %lo(sCDPressed)($t1)
play_tas_cd_end:

	lui $t1, %hi(sCLPressed)
	sw $zero, %lo(sCLPressed)($t1)

	andi $t3, $t2, 0x0002
	beqz $t3, play_tas_cl_end

	li $t3, 1
	lui $t1, %hi(sCLPressed)
	sw $t3, %lo(sCLPressed)($t1)
play_tas_cl_end:

	lui $t1, %hi(sCRPressed)
	sw $zero, %lo(sCRPressed)($t1)

	andi $t3, $t2, 0x0001
	beqz $t3, play_tas_cr_end

	li $t3, 1
	lui $t1, %hi(sCRPressed)
	sw $t3, %lo(sCRPressed)($t1)
play_tas_cr_end:

	lui $t3, %hi(gMarioState)
	lw $t3, %lo(gMarioState)($t3)
	lw $t3, 0x0c($t3)
	lui $t4, 0x1088
	ori $t4, $t4, 0x0899
	bne $t3, $t4, play_tas_wc_end

	# Change Mario's model
	lui $t9, %hi(gLoadedGraphNodes)
	lw $t9, %lo(gLoadedGraphNodes)($t9)
	lw $t1, 0x2fc($t9) # MODEL_KOOPA_WITHOUT_SHELL * 4

	lui $t9, %hi(gMarioObject)
	lw $t9, %lo(gMarioObject)($t9)
	sw $t1, 0x14($t9) # .header.gfx.sharedChild
play_tas_wc_end:

	andi $t3, $t2, 0x1000
	beqz $t3, play_tas_start_end

	move $s0, $t0
	lw $a2, 0x10($s0) # desc1

	lw $a0, 0x00($a2)
	lw $a1, 0x04($a2)
	addiu $a2, $a2, 8
	jal print_text

	lw $a2, 0x14($s0) # desc2

	lw $a0, 0x00($a2)
	lw $a1, 0x04($a2)
	addiu $a2, $a2, 8
	jal print_text
play_tas_start_end:

play_tas_ret:
	lw $s0, 0x34($sp)
	lw $ra, 0x30($sp)
	addiu $sp, $sp, 0x40
	jr $ra
