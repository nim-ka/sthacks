.set noat

glabel load_model_from_geo_hack
	addiu $sp,$sp,-32
	sw $ra,20($sp)
	lui $t6,%hi(sCurrentCmd)
	lw $t6,%lo(sCurrentCmd)($t6)
	lh $t7,2($t6)
	sh $t7,30($sp)
	lui $t8,%hi(sCurrentCmd)
	lw $t8,%lo(sCurrentCmd)($t8)
	lw $t9,4($t8)
	sw $t9,24($sp)
	lh $t0,30($sp)
	slti $at,$t0,256
	nop
	beqz $at,level_cmd_load_model_from_geo_L60

	li $a1, 0x0d0000d0 # koopa_without_shell_geo
	bne $t9, $a1, level_cmd_load_model_from_geo_load
	li $a0, 0x0d
	lui $a1, %hi(xander_geo)
	addiu $a1, $a1, %lo(xander_geo)
	jal virtual_to_segmented
	sw $v0,24($sp)

level_cmd_load_model_from_geo_load:
	lui $a0,%hi(sLevelPool)
	lw $a0,%lo(sLevelPool)($a0)
	lw $a1,24($sp)
	jal process_geo_layout
	lh $t2,30($sp)
	lui $t1,%hi(gLoadedGraphNodes)
	lw $t1,%lo(gLoadedGraphNodes)($t1)
	sll $t3,$t2,0x2
	addu $t4,$t1,$t3
	sw $v0,0($t4)
level_cmd_load_model_from_geo_L60:
	lui $t5,%hi(sCurrentCmd)
	lw $t5,%lo(sCurrentCmd)($t5)
	lui $at,%hi(sCurrentCmd)
	lbu $t6,1($t5)
	addu $t7,$t5,$t6
	sw $t7,%lo(sCurrentCmd)($at)
	nop
	b level_cmd_load_model_from_geo_ret
level_cmd_load_model_from_geo_ret:
	lw $ra,20($sp)
	addiu $sp,$sp,32
	nop
	jr $ra

.set at
