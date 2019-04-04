; ----- picture draw
pic_draw
	ld (pic_draw_sp+1),sp, sp,scr_buffer, ix,pic_draw_sp, c,0
	jp pic_draw_code
pic_draw_sp	ld sp,0
	ret

pic_draw_init
	ld iy,scr_buffer
	ld ix,pic_draw_code, de,screen_address+6, hl,tmp_buffer, c,192
1	ld b,19: push de
2	ld a,(hl): inc hl	; get sprite piece

	cp #ff: jp nz,begin	; check if no spr
	inc de: jp skip

begin:	exa
	ld a,0: and a: jp nz,3f
	inc a: ld (begin+2),a
	ld (ix),#e1: inc ix	; pop hl (get screen address for line)
	ld (iy),e: inc iy	; save address
	ld (iy),d: inc iy
3	exa: and a: jr nz,4f	; check if empty spr
	ld (ix),#71: inc ix	; ld (hl),c - c = 0
	jp next

4	ld (ix),#3e: inc ix	; ld a,XX
	ld (ix),a: inc ix
	ld (ix),#a6: inc ix	; and (hl)
	ld (ix),#77: inc ix	; ld (hl),a

next: 	ld (ix),#2c: inc ix	; inc l
skip:	djnz 2b
	sub a: ld (begin+2),a
	pop de: call down_d
	dec c: jp nz,1b
	ld (ix),#dd: inc ix: ld (ix),#e9
	ret

pic_draw_innerloop
	ld a,(de): and (hl): ld (de),a: inc de,hl
