glabel onZPress
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

	lui $t0, %hi(gMarioState)
	lw $t0, %lo(gMarioState)($t0)
	sh $zero, 0xA8($t0) # Coins
	li $t1, 69
	sh $t1, 0xAA($t0) # Stars
	li $t1, 42
	sb $t1, 0xAD($t0) # Lives

	li $a0, 0xF3 # JRB ship node
	jal area_get_warp_node
	beqz $v0, onZPress_ret

	li $t0, 0x0D # destLevel
	li $t1, 0x03 # destArea
	li $t2, 0x0A # destNode
	sb $t0, 0x01($v0)
	sb $t1, 0x02($v0)
	sb $t2, 0x03($v0)

onZPress_ret:
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra
