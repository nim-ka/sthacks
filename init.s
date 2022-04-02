glabel init
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)

	# Hack LOAD_MODEL_FROM_GEO
	lui $t0, %hi(LevelScriptJumpTable)
	addiu $t0, $t0, %lo(LevelScriptJumpTable)
	addiu $t0, $t0, 0x88

	lui $t1, %hi(load_model_from_geo_hack)
	addiu $t1, $t1, %lo(load_model_from_geo_hack)
	sw $t1, 0x00($t0)

	# Star interaction subtype
	lui $t0, 0x8035
	sw $zero, 0x0618($t0)

	# Hack the dma_sample_data call in synthesis
	lui $t0, %hi(dma_sample_data_hack_replace)
	lw $t0, %lo(dma_sample_data_hack_replace)($t0)
	lui $t1, %hi(sDMASampleDataJalInst)
	sw $t0, %lo(sDMASampleDataJalInst)($t1)

	lui $t0, %hi(play_sound_hack_replace)
	lw $t0, %lo(play_sound_hack_replace)($t0)
	lui $t1, %hi(sEndScreenSoundInst)
	sw $t0, %lo(sEndScreenSoundInst)($t1)

	li $a0, 0xF0 # Star node
	jal area_get_warp_node
	beqz $v0, warp_done

	li $t0, 0x19 # destLevel
	li $t1, 0x00 # destArea
	li $t2, 0xFA # destNode
	sb $t0, 0x01($v0)
	sb $t1, 0x02($v0)
	sb $t2, 0x03($v0)
warp_done:

	lui $t0, %hi(0x8006C680)
	lui $t2, 0x8000

	hack_seg2 02600 0x4C
	hack_seg2 03400 0x68
	hack_seg2 03E00 0x7C
	hack_seg2 04200 0x84
	hack_seg2 04600 0x8C
	hack_seg2 04C00 0x90
	hack_seg2 04E00 0x94
	hack_seg2 05000 0x98
	hack_seg2 05200 0x9C
	hack_seg2 05400 0xA0
	hack_seg2 05E00 0xD8
	hack_seg2 06000 0xDC

	# Add apostrophe to print_text
	lui $t0, %hi(sPrintTextHackInst)
	lui $t1, %hi(char_to_glyph_index_hack_replace)
	lw $t1, %lo(char_to_glyph_index_hack_replace)($t1)
	sw $t1, %lo(sPrintTextHackInst)($t0)

init_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

glabel dma_sample_data_hack_replace
	jal dma_sample_data_hack

glabel dma_sample_data_unhack_replace
	jal dma_sample_data

glabel play_sound_hack_replace
	jal play_sound_hack

glabel play_sound_hack
	lui $a2, 0x8033
	addiu $a2, $a2, 0x2F44
	j (play_sound + 8)

glabel char_to_glyph_index_hack_replace
	j char_to_glyph_index_hack

glabel char_to_glyph_index_hack
	li $t0, 0x27
	bne $a0, $t0, char_to_glyph_index_hack_ret
	li $v0, 56
char_to_glyph_index_hack_ret:
	jr $ra

data gusty_start_000
data gusty_start_001
data gusty_start_002
data gusty_start_003
data gusty_start_004

data gusty_loop_000
data gusty_loop_001
data gusty_loop_002
data gusty_loop_003
data gusty_loop_004
data gusty_loop_005
data gusty_loop_006
data gusty_loop_007
data gusty_loop_008
data gusty_loop_009
data gusty_loop_010
data gusty_loop_011
data gusty_loop_012
data gusty_loop_013
data gusty_loop_014
data gusty_loop_015
data gusty_loop_016
data gusty_loop_017
data gusty_loop_018
data gusty_loop_019
data gusty_loop_020
data gusty_loop_021
data gusty_loop_022
data gusty_loop_023
data gusty_loop_024
data gusty_loop_025
data gusty_loop_026
data gusty_loop_027
data gusty_loop_028
data gusty_loop_029
data gusty_loop_030
data gusty_loop_031
data gusty_loop_032
data gusty_loop_033
data gusty_loop_034
data gusty_loop_035
data gusty_loop_036
data gusty_loop_037
data gusty_loop_038
data gusty_loop_039
data gusty_loop_040
data gusty_loop_041
data gusty_loop_042
data gusty_loop_043
data gusty_loop_044
data gusty_loop_045

glabel gusty_start_data
	.word gusty_start_000_data
	.word gusty_start_001_data
	.word gusty_start_002_data
	.word gusty_start_003_data
	.word gusty_start_004_data

glabel gusty_loop_data
	.word gusty_loop_000_data
	.word gusty_loop_001_data
	.word gusty_loop_002_data
	.word gusty_loop_003_data
	.word gusty_loop_004_data
	.word gusty_loop_005_data
	.word gusty_loop_006_data
	.word gusty_loop_007_data
	.word gusty_loop_008_data
	.word gusty_loop_009_data
	.word gusty_loop_010_data
	.word gusty_loop_011_data
	.word gusty_loop_012_data
	.word gusty_loop_013_data
	.word gusty_loop_014_data
	.word gusty_loop_015_data
	.word gusty_loop_016_data
	.word gusty_loop_017_data
	.word gusty_loop_018_data
	.word gusty_loop_019_data
	.word gusty_loop_020_data
	.word gusty_loop_021_data
	.word gusty_loop_022_data
	.word gusty_loop_023_data
	.word gusty_loop_024_data
	.word gusty_loop_025_data
	.word gusty_loop_026_data
	.word gusty_loop_027_data
	.word gusty_loop_028_data
	.word gusty_loop_029_data
	.word gusty_loop_030_data
	.word gusty_loop_031_data
	.word gusty_loop_032_data
	.word gusty_loop_033_data
	.word gusty_loop_034_data
	.word gusty_loop_035_data
	.word gusty_loop_036_data
	.word gusty_loop_037_data
	.word gusty_loop_038_data
	.word gusty_loop_039_data
	.word gusty_loop_040_data
	.word gusty_loop_041_data
	.word gusty_loop_042_data
	.word gusty_loop_043_data
	.word gusty_loop_044_data
	.word gusty_loop_045_data

	.word 0xFFFFFFFF

glabel sGustyStartDataPtr
	.word gusty_start_data

.include "dma_sample_data_hack.s"

seg2 02600
seg2 03400
seg2 03E00
seg2 04200
seg2 04600
seg2 04C00
seg2 04E00
seg2 05000
seg2 05200
seg2 05400
seg2 05E00
seg2 06000
