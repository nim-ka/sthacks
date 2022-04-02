glabel loop
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)

	lui $t0, %hi(sCreditsed)
	lw $t0, %lo(sCreditsed)($t0)
	beqz $t0, loop_warp_done

	lui $t0, %hi(gCurrLevelNum)
	lh $t0, %lo(gCurrLevelNum)($t0)
	li $t1, 0x09
	bne $t0, $t1, loop_warp_done

	lui $t0, %hi(gCurrentArea)
	lw $t0, %lo(gCurrentArea)($t0)
	beqz $t0, loop_warp_done

	li $a0, 0xF0 # Star node
	jal area_get_warp_node
	beqz $v0, loop_warp_done

	li $t0, 0x19 # destLevel
	li $t1, 0x00 # destArea
	li $t2, 0xFA # destNode
	sb $t0, 0x01($v0)
	sb $t1, 0x02($v0)
	sb $t2, 0x03($v0)

	lui $t0, %hi(sCreditsed)
	sw $zero, %lo(sCreditsed)($t0)
loop_warp_done:

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

	lui $t0, %hi(gTTCSpeedSetting)
	li $t1, 2
	sh $t1, %lo(gTTCSpeedSetting)($t0)

	# Hack the instrument metadata for the credits sound
	lui $t0, %hi(sGustyStartBookPtr)
	lw $t0, %lo(sGustyStartBookPtr)($t0)
	lw $t0, ($t0)

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

	lui $t0, %hi(sEffect)
	lw $t0, %lo(sEffect)($t0)
#	bnez $t0, effect_end

	jal effect
effect_end:

	lui $t0, %hi(sRPressed)
	lw $t0, %lo(sRPressed)($t0)
	beqz $t0, rp_end

	lui $s0, %hi(sBobTextures)
	addiu $s0, $s0, %lo(sBobTextures)

rp_loop_start:
	lw $a0, ($s0)
	addiu $a0, $a0, 1
	beqz $a0, rp_loop_end
	addiu $a0, $a0, -1

	jal segmented_to_virtual

	lui $t0, %hi(sCUPressed)
	lw $t0, %lo(sCUPressed)($t0)
	bnez $t0, rp_loop_cu

	lw $a0, ($s0)
	addiu $a1, $v0, 2
	li $a2, 0x2040
	li $a3, 0x7FFF
	jal swapTextures3
	b rp_loop_cond

rp_loop_cu:
	lw $a0, ($s0)
	lui $a1, %hi(ted_png)
	addiu $a1, $a1, %lo(ted_png)
	li $a2, 0x2020
	lui $a3, %hi(sCUTimer)
	lw $a3, %lo(sCUTimer)($a3)
#	jal swapTextures

rp_loop_cond:
	addiu $s0, $s0, 4
	b rp_loop_start
rp_loop_end:

rp_end:

	lui $t0, %hi(sCUPressed)
	lw $t0, %lo(sCUPressed)($t0)
	beqz $t0, cup_end

	lui $t0, %hi(sBobTextureTop)
	move $t1, $zero
	addiu $t1, $t1, -1
	sw $t1, %lo(sBobTextureTop)($t0)

	lui $a0, 0x0900
	ori $a0, $a0, 0x5800
	lui $a1, %hi(xander_png)
	addiu $a1, $a1, %lo(xander_png)
	li $a2, 0x2020
	lui $t0, %hi(sCUTimer)
	lw $a3, %lo(sCUTimer)($t0)
	addiu $t1, $a3, 1
	sw $t1, %lo(sCUTimer)($t0)
	jal swapTextures

	lui $s0, %hi(sBobSkyboxTextures)
	addiu $s0, $s0, %lo(sBobSkyboxTextures)

cup_loop_start:
	lw $a0, ($s0)
	addiu $a0, $a0, 1
	beqz $a0, cup_loop_end
	addiu $a0, $a0, -1

	lui $t0, %hi(sCUTimer)
	lw $t0, %lo(sCUTimer)($t0)
	andi $t0, $t0, 0x0001
	srl $t1, $s0, 3
	andi $t1, $t1, 0x0001
	xor $t0, $t0, $t1
	beqz $t0, cup_loop_cond

	lui $a1, %hi(ted_png)
	addiu $a1, $a1, %lo(ted_png)
	li $a2, 0x2020
	lui $a3, %hi(sCUTimer)
	lw $a3, %lo(sCUTimer)($a3)
	jal swapTextures

cup_loop_cond:
	addiu $s0, $s0, 8
	b cup_loop_start
cup_loop_end:

cup_end:

	lui $t0, %hi(sCDPressed)
	lw $t0, %lo(sCDPressed)($t0)
	beqz $t0, cdp_end

	lui $s0, %hi(sPage2Textures)
	addiu $s0, $s0, %lo(sPage2Textures)

cdp_loop_start:
	lw $a0, ($s0)
	addiu $a0, $a0, 1
	beqz $a0, cdp_loop_end
	addiu $a0, $a0, -1

	lw $a1, 4($s0)
	li $a2, 0x5014
	lui $a3, %hi(sPage2Transition)
	lw $a3, %lo(sPage2Transition)($a3)
	jal swapTextures

cdp_loop_cond:
	addiu $s0, $s0, 8
	b cdp_loop_start
cdp_loop_end:

	lui $t0, %hi(sPage2Transition)
	lw $a3, %lo(sPage2Transition)($t0)
	addiu $t1, $a3, 1
	sw $t1, %lo(sPage2Transition)($t0)
cdp_end:

	lui $t0, %hi(sCLPressed)
	lw $t0, %lo(sCLPressed)($t0)
	beqz $t0, clp_end

	# Hack the dma_sample_data call in synthesis
	lui $t0, %hi(dma_sample_data_unhack_replace)
	lw $t0, %lo(dma_sample_data_unhack_replace)($t0)
	lui $t1, %hi(sDMASampleDataJalInst)
	sw $t0, %lo(sDMASampleDataJalInst)($t1)
clp_end:

	lui $t0, %hi(sCRPressed)
	lw $t0, %lo(sCRPressed)($t0)
	beqz $t0, crp_end

	lui $s0, %hi(sPage3Textures)
	addiu $s0, $s0, %lo(sPage3Textures)

crp_loop_start:
	lw $a0, ($s0)
	addiu $a0, $a0, 1
	beqz $a0, crp_loop_end
	addiu $a0, $a0, -1

	lw $a1, 4($s0)
	li $a2, 0x5014
	lui $a3, %hi(sPage3Transition)
	lw $a3, %lo(sPage3Transition)($a3)
	jal swapTextures

crp_loop_cond:
	addiu $s0, $s0, 8
	b crp_loop_start
crp_loop_end:

	lui $t0, %hi(sPage3Transition)
	lw $a3, %lo(sPage3Transition)($t0)
	addiu $t1, $a3, 1
	sw $t1, %lo(sPage3Transition)($t0)
crp_end:

loop_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

glabel sCreditsed
	.word 0x00000001

glabel xander_png
	.incbin "xander.rgba16"

glabel ted_png
	.incbin "ted.rgba16"

glabel sBobTextures
	.word 0x09000000
	.word 0x09001000
	.word 0x09002000
	.word 0x09003000
	.word 0x09004000
	.word 0x09006000
	.word 0x09007000
	.word 0x09008000
	.word 0x09009000
	.word 0x0900A000
	.word 0x0900B000
glabel sBobTextureTop
	.word 0x09005000
	.word 0xFFFFFFFF

	.word 0x0A000000
glabel sBobSkyboxTextures
	.word 0x0A000800
	.word 0x0A001000
	.word 0x0A001800
	.word 0x0A002000
	.word 0x0A002800
	.word 0x0A003000
	.word 0x0A003800
	.word 0x0A004000
	.word 0x0A004800
	.word 0x0A005000
	.word 0x0A005800
	.word 0x0A006000
	.word 0x0A006800
	.word 0x0A007000
	.word 0x0A007800
	.word 0x0A008000
	.word 0x0A008800
	.word 0x0A009000
	.word 0x0A009800
	.word 0x0A00A000
	.word 0x0A00A800
	.word 0x0A00B000
	.word 0x0A00B800
	.word 0x0A00C000
	.word 0x0A00C800
	.word 0x0A00D000
	.word 0x0A00D800
	.word 0x0A00E000
	.word 0x0A00E800
	.word 0x0A00F000
	.word 0x0A00F800
	.word 0x0A010000
	.word 0x0A010800
	.word 0x0A011000
	.word 0x0A011800
	.word 0x0A012000
	.word 0x0A012800
	.word 0x0A013000
	.word 0x0A013800
	.word 0x0A014000
	.word 0x0A014800
	.word 0x0A015000
	.word 0x0A015800
	.word 0x0A016000
	.word 0x0A016800
	.word 0x0A017000
	.word 0x0A017800
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF

glabel sRPressed
	.word 0x00000000

glabel sCUPressed
	.word 0x00000000

glabel sCDPressed
	.word 0x00000000

glabel sCLPressed
	.word 0x00000000

glabel sCRPressed
	.word 0x00000000

glabel sCUTimer
	.word 0x00000000

glabel effect
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

	lui $t1, 0x8027
	lui $t0, %hi(vec3s_set_hook_1)
	lw $t0, %lo(vec3s_set_hook_1)($t0)
	sw $t0, 0xE1CC($t1)
	lui $t0, %hi(vec3s_set_hook_2)
	lw $t0, %lo(vec3s_set_hook_2)($t0)
	sw $t0, 0xE1F4($t1)

	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

glabel sParam1
	.word 640
	.word 710
	.word 850
	.word 1000
	.word 1150
	.word 1300
	.word 1450
	.word 1300
	.word 1150
	.word 1000
	.word 850
	.word 710
	.word 640

glabel sParam2
	.word 480
	.word 500
	.word 550
	.word 600
	.word 650
	.word 700
	.word 750
	.word 700
	.word 650
	.word 600
	.word 550
	.word 500
	.word 480

glabel sParam1Ptr
	.word sParam1

glabel sParam2Ptr
	.word sParam2

# a1: node->x * 4
# a2: node->y * 4
glabel vec3s_set_hack_1
	j vec3s_set

# a1: node->width * 4
# a2: node->height * 4
glabel vec3s_set_hack_2
	lui $a1, %hi(sParam1Ptr)
	lw $a1, %lo(sParam1Ptr)($a1)
	lw $a1, ($a1)
	lui $a2, %hi(sParam2Ptr)
	lw $a2, %lo(sParam2Ptr)($a2)
	lw $a2, ($a2)
	j vec3s_set

glabel vec3s_set_hook_1
	jal vec3s_set_hack_1

glabel vec3s_set_hook_2
	jal vec3s_set_hack_2

glabel sEffect
	.word 0x00000001

book gusty_start_000
book gusty_start_001
book gusty_start_002
book gusty_start_003
book gusty_start_004

book gusty_loop_000
book gusty_loop_001
book gusty_loop_002
book gusty_loop_003
book gusty_loop_004
book gusty_loop_005
book gusty_loop_006
book gusty_loop_007
book gusty_loop_008
book gusty_loop_009
book gusty_loop_010
book gusty_loop_011
book gusty_loop_012
book gusty_loop_013
book gusty_loop_014
book gusty_loop_015
book gusty_loop_016
book gusty_loop_017
book gusty_loop_018
book gusty_loop_019
book gusty_loop_020
book gusty_loop_021
book gusty_loop_022
book gusty_loop_023
book gusty_loop_024
book gusty_loop_025
book gusty_loop_026
book gusty_loop_027
book gusty_loop_028
book gusty_loop_029
book gusty_loop_030
book gusty_loop_031
book gusty_loop_032
book gusty_loop_033
book gusty_loop_034
book gusty_loop_035
book gusty_loop_036
book gusty_loop_037
book gusty_loop_038
book gusty_loop_039
book gusty_loop_040
book gusty_loop_041
book gusty_loop_042
book gusty_loop_043
book gusty_loop_044
book gusty_loop_045

glabel gusty_start_book
	.word gusty_start_000_book
	.word gusty_start_001_book
	.word gusty_start_002_book
	.word gusty_start_003_book
	.word gusty_start_004_book

glabel gusty_loop_book
	.word gusty_loop_000_book
	.word gusty_loop_001_book
	.word gusty_loop_002_book
	.word gusty_loop_003_book
	.word gusty_loop_004_book
	.word gusty_loop_005_book
	.word gusty_loop_006_book
	.word gusty_loop_007_book
	.word gusty_loop_008_book
	.word gusty_loop_009_book
	.word gusty_loop_010_book
	.word gusty_loop_011_book
	.word gusty_loop_012_book
	.word gusty_loop_013_book
	.word gusty_loop_014_book
	.word gusty_loop_015_book
	.word gusty_loop_016_book
	.word gusty_loop_017_book
	.word gusty_loop_018_book
	.word gusty_loop_019_book
	.word gusty_loop_020_book
	.word gusty_loop_021_book
	.word gusty_loop_022_book
	.word gusty_loop_023_book
	.word gusty_loop_024_book
	.word gusty_loop_025_book
	.word gusty_loop_026_book
	.word gusty_loop_027_book
	.word gusty_loop_028_book
	.word gusty_loop_029_book
	.word gusty_loop_030_book
	.word gusty_loop_031_book
	.word gusty_loop_032_book
	.word gusty_loop_033_book
	.word gusty_loop_034_book
	.word gusty_loop_035_book
	.word gusty_loop_036_book
	.word gusty_loop_037_book
	.word gusty_loop_038_book
	.word gusty_loop_039_book
	.word gusty_loop_040_book
	.word gusty_loop_041_book
	.word gusty_loop_042_book
	.word gusty_loop_043_book
	.word gusty_loop_044_book
	.word gusty_loop_045_book

	.word 0xFFFFFFFF

glabel sGustyStartBookPtr
	.word gusty_start_book
