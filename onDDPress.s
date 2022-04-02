glabel onDDPress
	addiu $sp, $sp, -0x30
	sw $ra, 0x18($sp)
	sw $s0, 0x14($sp)

	lui $t0, %hi(sTexturePtr)
	lw $t0, %lo(sTexturePtr)($t0)
	lw $t1, ($t0)
	addiu $t1, $t1, 1
	beqz $t1, textures_end

	lw $a0, ($t0)
	lw $a1, 4($t0)
	li $a2, 0x5014
	lui $t0, %hi(sTransition)
	addiu $t0, $t0, %lo(sTransition)
	lw $a3, ($t0)
	addiu $a3, $a3, 6
	sw $a3, ($t0)
	jal swapTextures2
	beqz $v0, textures_end

	lui $t0, %hi(sTexturePtr)
	addiu $t0, $t0, %lo(sTexturePtr)
	lw $t1, ($t0)
	addiu $t1, $t1, 8
	sw $t1, ($t0)

	lui $t0, %hi(sTransition)
	sw $zero, %lo(sTransition)($t0)
textures_end:

	li $a0, 10
	li $a1, 0xCA
	lui $a2, %hi(sText)
	addiu $a2, $a2, %lo(sText)
	jal print_text_custom

onDDPress_ret:
	lw $s0, 0x14($sp)
	lw $ra, 0x18($sp)
	addiu $sp, $sp, 0x30
	jr $ra

glabel print_text_custom
	addiu $sp, $sp, -0x30
	sw $ra, 0x18($sp)
	sw $s0, 0x14($sp)
	sw $s1, 0x10($sp)
	sw $s2, 0x1C($sp)
	sw $s3, 0x20($sp)
	sw $s4, 0x24($sp)

	move $s0, $a0
	move $s1, $a1
	move $s2, $a2

	move $s3, $s2

print_text_loop_start:
	lb $s4, ($s3)
	beqz $s4, print_text_loop_end

	li $t2, 0x0a
	bne $s4, $t2, newline_end

	sb $zero, ($s3)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal print_text
	addiu $s1, $s1, -20

	li $t2, 0x0a
	sb $t2, ($s3)
	addiu $s2, $s3, 1
newline_end:

	addiu $s3, $s3, 1
	b print_text_loop_start
print_text_loop_end:

	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal print_text

print_text_custom_ret:
	lw $s4, 0x24($sp)
	lw $s3, 0x20($sp)
	lw $s2, 0x1C($sp)
	lw $s1, 0x10($sp)
	lw $s0, 0x14($sp)
	lw $ra, 0x18($sp)
	addiu $sp, $sp, 0x30
	jr $ra

glabel sTransition
	.word 0x00000000

glabel sPage2Transition
	.word 0x00000000

glabel sPage3Transition
	.word 0x00000000

glabel tile
	.incbin "cake.rgba16"

glabel sTextures
	tileref 0
	tileref 1
	tileref 2
	tileref 3
glabel sTextures2
	tileref 4
	tileref 5
	tileref 6
	tileref 7
	tileref 8
	tileref 9
	tileref 10
	tileref 11
	tileref 12
	tileref 13
	tileref 14
	tileref 15
	tileref 16
	tileref 17
	tileref 18
	tileref 19
	tileref 20
	tileref 21
	tileref 22
	tileref 23
	tileref 24
	tileref 25
	tileref 26
	tileref 27
	tileref 28
	tileref 29
	tileref 30
	tileref 31
	tileref 32
	tileref 33
	tileref 34
	tileref 35
	tileref 36
	tileref 37
	tileref 38
	tileref 39
	tileref 40
	tileref 41
	tileref 42
	tileref 43
#	tileref 44
#	tileref 45
#	tileref 46
#	tileref 47
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF

glabel sTexturePtr
	.word sTextures2

page2_tile 0
page2_tile 1
page2_tile 2
page2_tile 3
page2_tile 4
page2_tile 5
page2_tile 6
page2_tile 7
page2_tile 8
page2_tile 9
page2_tile 10
page2_tile 11
page2_tile 12
page2_tile 13
page2_tile 14
page2_tile 15
page2_tile 16
page2_tile 17
page2_tile 18
page2_tile 19
page2_tile 20
page2_tile 21
page2_tile 22
page2_tile 23
page2_tile 24
page2_tile 25
page2_tile 26
page2_tile 27
page2_tile 28
page2_tile 29
page2_tile 30
page2_tile 31
page2_tile 32
page2_tile 33
page2_tile 34
page2_tile 35
page2_tile 36
page2_tile 37
page2_tile 38
page2_tile 39
page2_tile 40
page2_tile 41
page2_tile 42
page2_tile 43
page2_tile 44
page2_tile 45
page2_tile 46
page2_tile 47

glabel sPage2Textures
	page2_tileref 0
	page2_tileref 1
	page2_tileref 2
	page2_tileref 3
	page2_tileref 4
	page2_tileref 5
	page2_tileref 6
	page2_tileref 7
	page2_tileref 8
	page2_tileref 9
	page2_tileref 10
	page2_tileref 11
	page2_tileref 12
	page2_tileref 13
	page2_tileref 14
	page2_tileref 15
	page2_tileref 16
	page2_tileref 17
	page2_tileref 18
	page2_tileref 19
	page2_tileref 20
	page2_tileref 21
	page2_tileref 22
	page2_tileref 23
	page2_tileref 24
	page2_tileref 25
	page2_tileref 26
	page2_tileref 27
	page2_tileref 28
	page2_tileref 29
	page2_tileref 30
	page2_tileref 31
	page2_tileref 32
	page2_tileref 33
	page2_tileref 34
	page2_tileref 35
	page2_tileref 36
	page2_tileref 37
	page2_tileref 38
	page2_tileref 39
	page2_tileref 40
	page2_tileref 41
	page2_tileref 42
	page2_tileref 43
	page2_tileref 44
	page2_tileref 45
	page2_tileref 46
	page2_tileref 47
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF

page3_tile 0
page3_tile 1
page3_tile 2
page3_tile 3
page3_tile 4
page3_tile 5
page3_tile 6
page3_tile 7
page3_tile 8
page3_tile 9
page3_tile 10
page3_tile 11
page3_tile 12
page3_tile 13
page3_tile 14
page3_tile 15
page3_tile 16
page3_tile 17
page3_tile 18
page3_tile 19
page3_tile 20
page3_tile 21
page3_tile 22
page3_tile 23
page3_tile 24
page3_tile 25
page3_tile 26
page3_tile 27
page3_tile 28
page3_tile 29
page3_tile 30
page3_tile 31
page3_tile 32
page3_tile 33
page3_tile 34
page3_tile 35
page3_tile 36
page3_tile 37
page3_tile 38
page3_tile 39
page3_tile 40
page3_tile 41
page3_tile 42
page3_tile 43
page3_tile 44
page3_tile 45
page3_tile 46
page3_tile 47

glabel sPage3Textures
	page3_tileref 0
	page3_tileref 1
	page3_tileref 2
	page3_tileref 3
	page3_tileref 4
	page3_tileref 5
	page3_tileref 6
	page3_tileref 7
	page3_tileref 8
	page3_tileref 9
	page3_tileref 10
	page3_tileref 11
	page3_tileref 12
	page3_tileref 13
	page3_tileref 14
	page3_tileref 15
	page3_tileref 16
	page3_tileref 17
	page3_tileref 18
	page3_tileref 19
	page3_tileref 20
	page3_tileref 21
	page3_tileref 22
	page3_tileref 23
	page3_tileref 24
	page3_tileref 25
	page3_tileref 26
	page3_tileref 27
	page3_tileref 28
	page3_tileref 29
	page3_tileref 30
	page3_tileref 31
	page3_tileref 32
	page3_tileref 33
	page3_tileref 34
	page3_tileref 35
	page3_tileref 36
	page3_tileref 37
	page3_tileref 38
	page3_tileref 39
	page3_tileref 40
	page3_tileref 41
	page3_tileref 42
	page3_tileref 43
	page3_tileref 44
	page3_tileref 45
	page3_tileref 46
	page3_tileref 47
	.word 0xFFFFFFFF
	.word 0xFFFFFFFF
