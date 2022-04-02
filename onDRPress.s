glabel onDRPress
	addiu $sp, $sp, -0x30
	sw $ra, 0x18($sp)

	lui $t0, %hi(sGustyStartDataPtr)
	addiu $t0, $t0, %lo(sGustyStartDataPtr)
	lw $t1, ($t0)
	addiu $t1, $t1, 4
	lw $t2, ($t1)
	addiu $t2, $t2, 1
	bnez $t2, store_1
	lui $t1, %hi(gusty_loop_data)
	addiu $t1, $t1, %lo(gusty_loop_data)
store_1:
	sw $t1, ($t0)

	lui $t0, %hi(sGustyStartBookPtr)
	addiu $t0, $t0, %lo(sGustyStartBookPtr)
	lw $t1, ($t0)
	addiu $t1, $t1, 4
	lw $t2, ($t1)
	addiu $t2, $t2, 1
	bnez $t2, store_2
	lui $t1, %hi(gusty_loop_book)
	addiu $t1, $t1, %lo(gusty_loop_book)
store_2:
	sw $t1, ($t0)

	jal lvl_play_the_end_screen_sound

onDRPress_ret:
	lw $ra, 0x18($sp)
	addiu $sp, $sp, 0x30
	jr $ra
