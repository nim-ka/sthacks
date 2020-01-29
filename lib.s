# Guaranteed non-destructive
glabel setDebug
	addiu $sp, $sp, -8
	sw $s0, 0x00($sp)

	lui $s0, %hi(sDebug)
	sw $ra, %lo(sDebug)($s0)

	lw $s0, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

# a0: void *dest (segmented)
# a1: void *src (virtual)
# a2: u32 size = (u16 width) << 8 | (u16 height)
# a3: u32 bytes per pixel (rgba16 = 2)

glabel swapTextures
	addiu $sp, $sp, -0x28
	sw $ra, 0x00($sp)
	sw $s0, 0x04($sp)
	sw $s1, 0x08($sp)
	sw $s2, 0x0C($sp)
	sw $s3, 0x10($sp)
	sw $s4, 0x14($sp)
	sw $s5, 0x18($sp)
	sw $s6, 0x1C($sp)
	sw $s7, 0x20($sp)
	sw $s8, 0x24($sp)

	move $s2, $a0   	# dest (segmented)
	move $s3, $a1   	# src
	move $s4, $a2   	# size
	move $s5, $a3   	# bytes per pixel

	srl $s6, $a2, 8     	# width
	andi $s7, $a2, 0x00FF	# height

	jal segmented_to_virtual
	move $s8, $v0       	# virtual addr

	move $s0, $zero
swapTextures_widthLoopStart:
	beq $s0, $s6, swapTextures_widthLoopEnd

	move $s1, $zero
swapTextures_heightLoopStart:
	beq $s1, $s7, swapTextures_heightLoopEnd

	# offset = t2 = (s1 * width + s0) * a3
	mult $s1, $s6
	mflo $t2
	addu $t2, $t2, $s0
	mult $t2, $s5
	mflo $t2

	addu $a0, $t2, $s8
	addu $a1, $t2, $s3
	move $a2, $s5
	jal memcpy

	addiu $s1, $s1, 1
	b swapTextures_heightLoopStart
swapTextures_heightLoopEnd:

	addiu $s0, $s0, 1
	b swapTextures_widthLoopStart
swapTextures_widthLoopEnd:

swapTextures_ret:
	lw $ra, 0x00($sp)
	lw $s0, 0x04($sp)
	lw $s1, 0x08($sp)
	lw $s2, 0x0C($sp)
	lw $s3, 0x10($sp)
	lw $s4, 0x14($sp)
	lw $s5, 0x18($sp)
	lw $s6, 0x1C($sp)
	lw $s7, 0x20($sp)
	lw $s8, 0x24($sp)
	addiu $sp, $sp, 0x28
	jr $ra
