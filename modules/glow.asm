glow_size	equ 11*10*8

glow_draw
	call rnd8: and 7
glow_last_1	cp 0: jr z,glow_draw: push af: ld a,(glow_last_2+1),(glow_last_1+1),a: pop af
glow_last_2	cp 1: jr z,glow_draw: ld (glow_last_2+1),a
	add a,a: ld e,a,d,0
	ld hl,glow_tab: add hl,de
	ld a,(hl): inc hl: ld h,(hl), l,a

	ld a,#10: call set_bnk_save
	ld de,tmp_buffer+#800
	push de
	ld bc,glow_size: ldir
	pop hl

	call set_bnk_restore

	ld de,glow_scr_adr, lx,10*8
1	push de
	.11 ldi
	pop de: call down_d
	dec lx: jp nz,1b

	ld hl,glow_atr, de,glow_atr_adr, lx,10
2	.11 ldi
	ld bc,32-11: ex de,hl: add hl,bc: ex de,hl
	dec lx: jp nz,2b

	ret

glow_tab
	dw glow + glow_size * 0
	dw glow + glow_size * 1
	dw glow + glow_size * 2
	dw glow + glow_size * 3
	dw glow + glow_size * 4
	dw glow + glow_size * 5
	dw glow + glow_size * 6
	dw glow + glow_size * 7
