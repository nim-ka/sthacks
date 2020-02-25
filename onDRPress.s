glabel onDRPress
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

onDRPress_ret:
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra
