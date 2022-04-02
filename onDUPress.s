glabel onDUPress
	addiu $sp, $sp, -8
	sw $ra, 0x00($sp)

	lui $t0, %hi(sTextPtr)
	addiu $t0, $t0, %lo(sTextPtr)
	lw $t2, ($t0)

	lui $t1, %hi(sPage1Ptr)
	addiu $t1, $t1, %lo(sPage1Ptr)
	lw $t3, ($t1)

	lb $t4, ($t2)
	addiu $t4, $t4, 1
	beqz $t4, du_text_end

	lb $t4, ($t3)
	sb $t4, ($t2)

	addiu $t2, $t2, 1
	sw $t2, ($t0)

	addiu $t3, $t3, 1
	sw $t3, ($t1)
du_text_end:

onDUPress_ret:
	lw $ra, 0x00($sp)
	addiu $sp, $sp, 8
	jr $ra

glabel sTextPtr
	.word sText

glabel sPage1Ptr
	.word sPage1
