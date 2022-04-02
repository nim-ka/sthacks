glabel hook
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)

	lui $s0, %hi(gPlayer1Controller)
	lw $s0, %lo(gPlayer1Controller)($s0)
	lw $s0, 0x12($s0) # buttonPressed

	lui $s0, %hi(gControllerPads)
	lh $s0, %lo(gControllerPads)($s0)

hook_checkInit:
	lui $t0, %hi(sRanInit)
	lw $t0, %lo(sRanInit)($t0)
	bnez $t0, hook_checkInitEnd
	jal init

	li $t0, 1
	lui $t1, %hi(sRanInit)
	sw $t0, %lo(sRanInit)($t1)
hook_checkInitEnd:

hook_update:
	jal loop

hook_checkL:
	andi $t1, $s0, 0x0020
	beqz $t1, hook_checkLEnd
	jal onLPress
hook_checkLEnd:

hook_checkDU:
	andi $t1, $s0, 0x0800
	beqz $t1, hook_checkDUEnd
	jal onDUPress
hook_checkDUEnd:

hook_checkDD:
	andi $t1, $s0, 0x0400
	beqz $t1, hook_checkDDEnd
	jal onDDPress
hook_checkDDEnd:

hook_checkDL:
	andi $t1, $s0, 0x0200
	beqz $t1, hook_checkDLEnd
	jal onDLPress
hook_checkDLEnd:

hook_checkDR:
	andi $t1, $s0, 0x0100
	beqz $t1, hook_checkDREnd
	jal onDRPress
hook_checkDREnd:

	jal play_tas

hook_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

