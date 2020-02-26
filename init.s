glabel init
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)

	# Disable star select
	li $t0, 0x24020000
	lui $t1, %hi(sDisableStarSelectInst)
	sw $t0, %lo(sDisableStarSelectInst)($t1)

	# Hack LOAD_MODEL_FROM_GEO
	lui $t0, %hi(LevelScriptJumpTable)
	addiu $t0, $t0, %lo(LevelScriptJumpTable)
	addiu $t0, $t0, 0x88

	lui $t1, %hi(load_model_from_geo_hack)
	addiu $t1, $t1, %lo(load_model_from_geo_hack)
	sw $t1, 0x00($t0)

	# Hack the dma_sample_data call in synthesis
	lui $t0, %hi(dma_sample_data_hack_replace)
	lw $t0, %lo(dma_sample_data_hack_replace)($t0)
	lui $t1, %hi(sDMASampleDataJalInst)
	sw $t0, %lo(sDMASampleDataJalInst)($t1)

init_ret:
	lw $s0, 0x04($sp)
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

glabel dma_sample_data_hack_replace
	jal dma_sample_data_hack

glabel audio_hijack_data
	.incbin "audio_hijack.bin"

.include "load_model_from_geo_hack.s"
.include "dma_sample_data_hack.s"
