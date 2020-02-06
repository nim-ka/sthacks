glabel hook
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

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

hook_checkZ:
	lui $t0, %hi(gPlayer1Controller)
	lw $t0, %lo(gPlayer1Controller)($t0)
	lw $t0, 0x12($t0) # buttonPressed
	andi $t1, $t0, 0x2000
	beqz $t1, hook_checkZEnd
	jal onZPress
hook_checkZEnd:

hook_checkDU:
	lui $t0, %hi(gPlayer1Controller)
	lw $t0, %lo(gPlayer1Controller)($t0)
	lw $t0, 0x12($t0) # buttonPressed
	andi $t1, $t0, 0x0800
	beqz $t1, hook_checkDUEnd
	jal onDUPress
hook_checkDUEnd:

hook_checkDD:
	lui $t0, %hi(gPlayer1Controller)
	lw $t0, %lo(gPlayer1Controller)($t0)
	lw $t0, 0x12($t0) # buttonPressed
	andi $t1, $t0, 0x0400
	beqz $t1, hook_checkDDEnd
	jal onDDPress
hook_checkDDEnd:

hook_ret:
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

