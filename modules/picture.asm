; ----- picture draw
pic_draw
	ld (pic_draw_sp+1),sp, sp,spr_left_edge, d,high edges_tab
	ld ix,pic_draw_sp, bc,#ff00
	jp pic_draw_code
pic_draw_sp	ld sp,0
	ret

pic_draw_init
	ld a,#11: call set_bnk

; 	scr
	ld ix,pic_draw_code

	ld hl,mask_left, c,22		; cells in left edge
	call edge_draw_gen

	ld hl,mask_right, c,24
	call edge_draw_gen

	ld hl,spr_middle_len
1	ld a,(hl): inc hl		; a - length
	and a: jp z,next
	ld (ix),#e1: inc ix		; pop hl
	ld (ix),#7d: inc ix		; ld a,l
	ld c,8
2	ld b,a
3	ld (ix),#71: inc ix		; ld (hl),c, c = 0
	ld (ix),#2c: inc ix		; inc l
	djnz 3b
	dec ix
	ld (ix),#6f: inc ix		; ld l,a
	ld (ix),#24: inc ix		; inc h
	dec c: jp nz,2b
	dec ix
	jp 1b

next
	ld hl,atr_left_len: call atr_draw_gen_left
	ld hl,atr_right_len: call atr_draw_gen_right
	ld hl,atr_middle_len, a,#47: call atr_draw_gen_middle

	ld (ix+0),#dd, (ix+1),#e9		; jp (ix)
	ret


edge_draw_gen
2	ld b,8
	ld (ix),#e1: inc ix		; pop hl
1	ld a,(hl)
	and a: jr nz,5f
	ld (ix),#71: inc ix		; ld (hl),c
	jr 4f
5	cp #ff: jr nz,3f
	ld (ix),#70: inc ix		; ld (hl),b
	jr 4f
3	ld (ix),#36: inc ix		; ld (hl),XX
	ld (ix),a: inc ix
4	inc hl
	ld (ix),#24: inc ix		; inc h
	djnz 1b
	dec ix
	dec c: jp nz,2b
	ret

atr_draw_gen_left
	ld a,(hl): inc hl
	and a: ret z
	ld (ix),#e1: inc ix		; pop hl
	ld (ix),#2c: inc ix		; inc l
	ld (ix),#5e: inc ix		; ld e,(hl)
	ld (ix),#1a: inc ix		; ld a,(de)
	ld b,a
2	ld (ix),#77: inc ix		; ld (hl),a
	ld (ix),#2c: inc ix		; inc l
	djnz 2b
	dec ix
	jp atr_draw_gen_left

atr_draw_gen_right
	ld a,(hl): inc hl
	and a: ret z
	ld (ix),#e1: inc ix		; pop hl
	ld (ix),#2d: inc ix		; inc l
	ld (ix),#5e: inc ix		; ld e,(hl)
	ld (ix),#1a: inc ix		; ld a,(de)
	ld b,a
2	ld (ix),#77: inc ix		; ld (hl),a
	ld (ix),#2d: inc ix		; inc l
	djnz 2b
	dec ix
	jp atr_draw_gen_right

atr_draw_gen_middle
	ld (ix),#3e: inc ix		; ld a,XX
	ld (ix),a: inc ix
1	ld a,(hl): inc hl
	and a: ret z
	ld (ix),#e1: inc ix		; pop hl
	ld b,a
2	ld (ix),#77: inc ix		; ld (hl),a
	ld (ix),#2c: inc ix		; inc l
	djnz 2b
	dec ix
	jp 1b

; ----- sprites addresses
spr_left_edge
	dw #c00e, #c00f, #c010
	dw #c02d, #c02e
	dw #c04c
	dw #c06c
	dw #c08c
	dw #c0ac
	dw #c0cc, #c0cd
	dw #c0ed
	dw #c84d
	dw #c86b, #c86c
	dw #c888, #c889, #c88a
	dw #c8a7, #c8a8
	dw #c8c7
	dw #c8e7
	; dw 0

spr_right_edge
	dw #c012, #c011
	dw #c033, #c032
	dw #c053
	dw #c073
	dw #c093
	dw #c0b3
	dw #c0d3
	dw #c0f2, #c0f1
	dw #c811
	dw #c831
	dw #c854, #c853, #c852
	dw #c877, #c876, #c875
	dw #c898, #c897
	dw #c8b9
	dw #c8d9
	dw #c8f9
	; dw 0

spr_middle
	dw #c02f
	dw #c04d
	dw #c06d
	dw #c08d
	dw #c0ad
	dw #c0ce
	dw #c0ee
	dw #c80e
	dw #c82e
	dw #c84e
	dw #c86d
	dw #c88b
	dw #c8a9
	dw #c8c8
	dw #c8e8
	dw #d007
	dw #d027
	dw #d047
	dw #d067
	dw #d087
	dw #d0a7
	dw #d0c7
	dw #d0e7

; ----- attributes addresses
atr_left_edge
	dw #d80e-1
	dw #d82d-1
	dw #d84c-1
	dw #d86c-1
	dw #d88c-1
	dw #d8ac-1
	dw #d8cc-1
	dw #d8ed-1
	dw #d94d-1
	dw #d96b-1
	dw #d988-1
	dw #d9a7-1
	dw #d9c7-1
	dw #d9e7-1
	; dw 0

atr_right_edge
	dw #d812+1
	dw #d833+1
	dw #d853+1
	dw #d873+1
	dw #d893+1
	dw #d8b3+1
	dw #d8d3+1
	dw #d8f2+1
	dw #d911+1
	dw #d931+1
	dw #d954+1
	dw #d977+1
	dw #d998+1
	dw #d9b9+1
	dw #d9d9+1
	dw #d9f9+1
	; dw 0

atr_middle
	dw #d82f
	dw #d84d
	dw #d86d
	dw #d88d
	dw #d8ad
	dw #d8ce
	dw #d8ee
	dw #d90e
	dw #d92e
	dw #d94e
	dw #d96d
	dw #d98b
	dw #d9a9
	dw #d9c8
	dw #d9e8
	dw #da07
	dw #da27
	dw #da47
	dw #da67
	dw #da87
	dw #daa7
	dw #dac7
	dw #dae7
	dw 0

spr_middle_len
	db 3
	db 6
	db 6
	db 6
	db 6
	db 5
	db 3
	db 3
	db 3
	db 4
	db 8
	db 12
	db 16
	db 17
	db 17
	db 19
	db 19
	db 19
	db 19
	db 19
	db 19
	db 19
	db 19
	db 0

atr_left_len
	db 3
	db 2
	db 1
	db 1
	db 1
	db 1
	db 2
	db 1
	db 1
	db 2
	db 3
	db 2
	db 1
	db 1
	db 0

atr_right_len
	db 2
	db 2
	db 1
	db 1
	db 1
	db 1
	db 1
	db 2
	db 1
	db 1
	db 3
	db 3
	db 2
	db 1
	db 1
	db 1
	db 0

atr_middle_len
	db 3
	db 6
	db 6
	db 6
	db 6
	db 5
	db 3
	db 3
	db 3
	db 4
	db 8
	db 12
	db 16
	db 17
	db 17
	db 19
	db 19
	db 19
	db 19
	db 19
	db 19
	db 19
	db 19
	db 0
