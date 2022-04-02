glabel onLPress
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

	stub set_background_music
	stub play_sound
	stub play_music
	stub disable_background_sound
	stub seq_player_play_sequence

	lui $t0, %hi(sTasPtr)
	lw $t1, %lo(sTasPtr)($t0)
	addiu $t1, $t1, 4
	sw $t1, %lo(sTasPtr)($t0)
	lw $t1, ($t1)
	beqz $t1, lp_warp_done

	lw $t0, 0x0c($t1) # rng
	lui $t2, %hi(gRandomSeed16)
	sh $t0, %lo(gRandomSeed16)($t2)

	lw $a0, 0x00($t1) # destLevel
	lw $a1, 0x04($t1) # destArea
	lw $a2, 0x08($t1) # destNode
	li $a3, 0
	jal initiate_warp

	li $a0, 4
	jal set_play_mode

	li $a0, 0
	li $a1, 0
	li $a2, 1
	jal save_file_set_star_flags

	li $a0, 2
	jal save_file_set_flags

	# unhack, THANKS FRAME
	lui $a0, 0x1300
	ori $a0, $a0, 0x0828
	jal segmented_to_virtual

	lui $t0, %hi(bhv_spawned_star_loop)
	addiu $t0, $t0, %lo(bhv_spawned_star_loop)
	sw $t0, ($v0)

	lui $t0, %hi(gMarioState)
	lw $t0, %lo(gMarioState)($t0)
	li $t1, 0x7FFF
	sh $t1, 0xB8($t0) # prevNumStarsForDialog

	lui $t0, %hi(gCurrLevelNum)
	lh $t0, %lo(gCurrLevelNum)($t0)
	li $t1, 0x19
	bne $t0, $t1, patch_ending_end

	lui $a0, 0x0e00
	jal segmented_to_virtual

	li $t0, 0x00
	sh $t0, 0x4e($v0)

	lui $t1, %hi(lvl_init_or_update)
	addiu $t1, $t1, %lo(lvl_init_or_update)

#	lui $t0, 0x1108
#	sw $t0, 0x00($v0)
#	sw $t1, 0x04($v0)
	lui $t0, 0x3204
	sw $t0, 0x00($v0)
	sw $t0, 0x04($v0)
	lui $t0, 0x1208
	ori $t0, $t0, 0x0001
	sw $t0, 0x08($v0)
	sw $t1, 0x0c($v0)
	lui $t0, 0x1c04
	sw $t0, 0x10($v0)
	lui $t0, 0x0404
	ori $t0, $t0, 0x0001
	sw $t0, 0x14($v0)
	lui $t0, 0x0204
	sw $t0, 0x18($v0)
patch_ending_end:

lp_warp_done:

onLPress_ret:
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

tas 0x0E 0x01 0x0A 37070 10 40 "GET A HAND 5.07" 10 20 "BY PALIX" getahand 120
tas 0x07 0x01 0x0A 13891 10 40 "ROLL & ROCKER 12.80" 10 20 "FRAME/ GALOOMBA/ RSW" wfrr 81
tas 0x24 0x01 0x0A     0 10 40 "BREEZELESS 5.67" 10 20 "ALSO PALIX WTF" mountain 0
tas 0x15 0x01 0x0A 13381 10 40 "BITS 22.87" 10 20 "DABS/ IDEA BY TYLER" bits 5613
tas 0x09 0x01 0x0A  7661 10 40 "BOB 100 COINS & KTQ" 10 20 "BY PLUSH      78.63" bob 25647
tas 0x19 0x00 0xFA     0 10 40 "" 10 20 "" getahand2 120

glabel sTases
	.word 0x00000000
	.word getahand_tas
	.word wfrr_tas
	.word mountain_tas
	.word bits_tas
	.word bob_tas
	.word getahand2_tas
	.word 0x00000000

glabel sTasPtr
	.word sTases
