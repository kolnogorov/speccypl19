earth_init
	ld a,#10: call set_bnk
	ld hl,earth_first, de,tmp_buffer: call depack
	ret

earth_draw
	ld a,#10: call set_bnk_save
	call earth
	call set_bnk_restore

	ld hl,tmp_buffer, de,earth_scr_adr, lx,5*8
1	push de,hl
	.5 ldi
	pop hl,de: call down_d, down_h
	dec lx: jp nz,1b
	ret
