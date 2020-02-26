.set noat

glabel dma_sample_data_hack
	lui $t2, 0x67
	addiu $t2, $t2, 0x7260
	addiu $t3, $t2, 0x546A
	slt $t0, $a0, $t2
	not $t0, $t0
	slt $t1, $a0, $t3
	and $t0, $t0, $t1
	beqz $t0, dma_sample_data_start
	lui $v0, %hi(audio_hijack_data)
	addiu $v0, $v0, %lo(audio_hijack_data)
	subu $t0, $a0, $t2
	addu $v0, $v0, $t0
	jr $ra

dma_sample_data_start:
	addiu	$sp,$sp,-112
	sw	$s8,64($sp)
	sw	$s1,60($sp)
	sw	$s0,56($sp)
	move	$s0,$a1
	move	$s1,$a0
	move	$s8,$sp
	sw	$ra,68($sp)
	sw	$a2,120($sp)
	sw	$a3,124($sp)
	move	$t2,$zero
	bnez	$a2,dma_sample_data_314

	lw	$t7,124($s8)
	lui	$t8,%hi(sSampleDmaListSize1)
	lw	$t8,%lo(sSampleDmaListSize1)($t8)
	lbu	$a0,0($t7)
	lui	$a2,%hi(sSampleDmas)
	addiu	$a2,$a2,%lo(sSampleDmas)
	sltu	$at,$a0,$t8
	sll	$t4,$a0,0x4
	bnez	$at,dma_sample_data_458

dma_sample_data_314:
	lui	$a0,%hi(sSampleDmaListSize1)
	lui	$a1,%hi(gSampleDmaNumListItems)
	lw	$a1,%lo(gSampleDmaNumListItems)($a1)
	lw	$a0,%lo(sSampleDmaListSize1)($a0)
	lui	$a2,%hi(sSampleDmas)
	addiu	$a2,$a2,%lo(sSampleDmas)
	sltu	$at,$a0,$a1
	sll	$t9,$a0,0x4
	beqz	$at,dma_sample_data_3fc

dma_sample_data_338:
	addu	$v1,$a2,$t9
	lw	$t4,4($v1)
	move	$t0,$v1
	subu	$v0,$s1,$t4
	addiu	$a0,$a0,1
	bltzl	$v0,dma_sample_data_3ec

	lhu	$t5,10($v1)
	subu	$t6,$t5,$s0
	sltu	$at,$t6,$v0
	addiu	$a0,$a0,1
	bnezl	$at,dma_sample_data_3ec

	lbu	$t7,14($v1)
	lui	$t1,%hi(sSampleDmaReuseQueueTail2)
	addiu	$t1,$t1,%lo(sSampleDmaReuseQueueTail2)
	lui	$t8,%hi(sSampleDmaReuseQueueHead2)
	bnez	$t7,dma_sample_data_3c4

	lbu	$a1,0($t1)
	lbu	$t8,%lo(sSampleDmaReuseQueueHead2)
	li	$t4,60
	beql	$t8,$a1,dma_sample_data_3c8

	lbu	$a3,13($v1)
	lui	$t3,%hi(sSampleDmaReuseQueue2)
	addiu	$t3,$t3,%lo(sSampleDmaReuseQueue2)
	addu	$v0,$t3,$a1
	beq	$a1,$a3,dma_sample_data_3bc

	lbu	$t9,0($v0)
	addu	$t4,$t3,$a3
	sb	$t9,0($t4)
	lbu	$t6,0($v0)
	lbu	$t5,13($v1)
	sll	$t7,$t6,0x4
	addu	$t8,$a2,$t7
	sb	$t5,13($t8)
dma_sample_data_3bc:
	addiu	$t9,$a1,1
	sb	$t9,0($t1)
dma_sample_data_3c4:
	li	$t4,60
dma_sample_data_3c8:
	sb	$t4,14($v1)
	lw	$t6,124($s8)
	sb	$a0,0($t6)
	lw	$t7,4($v1)
	lw	$t8,0($v1)
	subu	$t5,$s1,$t7
	addu	$v0,$t5,$t8
	b	dma_sample_data_5d8

	addiu	$a0,$a0,1
dma_sample_data_3ec:
	sltu	$at,$a0,$a1
	bnezl	$at,dma_sample_data_338
	sll	$t9,$a0,0x4

	sw	$t0,104($s8)
dma_sample_data_3fc:
	lui	$t1,%hi(sSampleDmaReuseQueueTail2)
	addiu	$t1,$t1,%lo(sSampleDmaReuseQueueTail2)
	lui	$t9,%hi(sSampleDmaReuseQueueHead2)
	lbu	$t9,%lo(sSampleDmaReuseQueueHead2)($t9)
	lbu	$a1,0($t1)
	lui	$a2,%hi(sSampleDmas)
	addiu	$a2,$a2,%lo(sSampleDmas)
	lw	$t0,104($s8)
	beq	$t9,$a1,dma_sample_data_4f0

	lw	$t4,120($s8)
	lui	$t3,%hi(sSampleDmaReuseQueue2)
	addiu	$t3,$t3,%lo(sSampleDmaReuseQueue2)
	addu	$t6,$t3,$a1
	beqz	$t4,dma_sample_data_4f0

	lbu	$t7,0($t6)
	addiu	$t5,$a1,1
	li	$t2,1
	sw	$t7,88($s8)
	sb	$t5,0($t1)
	lw	$t8,88($s8)
	sll	$t9,$t8,0x4
	addu	$t0,$a2,$t9
	b	dma_sample_data_4f0

dma_sample_data_458:
	addu	$t0,$t4,$a2
	lw	$t6,4($t0)
	subu	$v1,$s1,$t6
	nop
	bltz	$v1,dma_sample_data_4f0

	lhu	$t7,10($t0)
	subu	$t5,$t7,$s0
	sltu	$at,$t5,$v1
	nop
	bnez	$at,dma_sample_data_4f0

	lbu	$t8,14($t0)
	lui	$a1,%hi(sSampleDmaReuseQueueTail1)
	addiu	$a1,$a1,%lo(sSampleDmaReuseQueueTail1)
	lw	$t5,0($t0)
	bnezl	$t8,dma_sample_data_4e0

	lbu	$v0,0($a1)
	lbu	$a0,13($t0)
	lui	$a3,%hi(sSampleDmaReuseQueue1)
	addiu	$a3,$a3,%lo(sSampleDmaReuseQueue1)
	addu	$v1,$a3,$v0
	beq	$v0,$a0,dma_sample_data_4cc

	lbu	$t9,0($v1)
	addu	$t4,$a3,$a0
	sb	$t9,0($t4)
	lbu	$t7,0($v1)
	lbu	$t6,13($t0)
	sll	$t5,$t7,0x4
	addu	$t8,$a2,$t5
	sb	$t6,13($t8)
dma_sample_data_4cc:
	addiu	$t9,$v0,1
	sb	$t9,0($a1)
	lw	$t4,4($t0)
	subu	$v1,$s1,$t4
	lw	$t5,0($t0)
dma_sample_data_4e0:
	li	$t7,2
	sb	$t7,14($t0)
	addu	$v0,$v1,$t5
	b	dma_sample_data_5d8

dma_sample_data_4f0:
	li	$t5,2
	bnez	$t2,dma_sample_data_52c

	lui	$a1,%hi(sSampleDmaReuseQueueTail1)
	addiu	$a1,$a1,%lo(sSampleDmaReuseQueueTail1)
	lbu	$v0,0($a1)
	lui	$a3,%hi(sSampleDmaReuseQueue1)
	addiu	$a3,$a3,%lo(sSampleDmaReuseQueue1)
	addu	$t6,$a3,$v0
	lbu	$t8,0($t6)
	addiu	$t9,$v0,1
	sw	$t8,88($s8)
	sb	$t9,0($a1)
	lw	$t4,88($s8)
	sll	$t7,$t4,0x4
	addu	$t0,$a2,$t7
dma_sample_data_52c:
	lhu	$s0,10($t0)
	li	$at,-16
	and	$v0,$s1,$at
	sb	$t5,14($t0)
	sw	$v0,4($t0)
	lw	$a0,0($t0)
	sh	$s0,8($t0)
	sw	$t0,104($s8)
	sw	$v0,72($s8)
	move	$a1,$s0
	jal	osInvalDCache

	lui	$v1,%hi(gCurrAudioFrameDmaCount)
	addiu	$v1,$v1,%lo(gCurrAudioFrameDmaCount)
	lw	$v0,0($v1)
	lw	$t0,104($s8)
	lui	$t7,%hi(gCurrAudioFrameDmaIoMesgBufs)
	addiu	$t6,$v0,1
	sw	$t6,0($v1)
	lw	$t8,0($v1)
	lw	$t5,0($t0)
	lw	$a3,72($s8)
	sll	$t9,$t8,0x2
	addu	$t9,$t9,$t8
	sll	$t9,$t9,0x2
	lui	$t6,%hi(gCurrAudioFrameDmaQueue)
	addiu	$t6,$t6,%lo(gCurrAudioFrameDmaQueue)
	addiu	$t4,$t9,-20
	addiu	$t7,$t7,%lo(gCurrAudioFrameDmaIoMesgBufs)
	addu	$a0,$t4,$t7
	sw	$t6,24($sp)
	sw	$s0,20($sp)
	move	$a1,$zero
	move	$a2,$zero
	sw	$t5,16($sp)
	jal	osPiStartDma

	lw	$t8,88($s8)
	lw	$t9,124($s8)
	lw	$t0,104($s8)
	sb	$t8,0($t9)
	lw	$t4,0($t0)
	lw	$t5,72($s8)
	addu	$t7,$t4,$s1
	subu	$v0,$t7,$t5
dma_sample_data_5d8:
	lw	$ra,68($s8)
	move	$sp,$s8
	lw	$s0,56($s8)
	lw	$s1,60($s8)
	lw	$s8,64($s8)
	addiu	$sp,$sp,112
	jr	$ra

.set at

