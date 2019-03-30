down_d	inc d: ld a,d: and 7: ret nz: ld a,e: add a,#20: ld e,a: ret c: ld a,d: add a,-8: ld d,a: ret
down_h	inc h: ld a,h: and 7: ret nz: ld a,l: add a,#20: ld l,a: ret c: ld a,h: add a,-8: ld h,a: ret

seed	dw 0
rnd2	call rnd8:and 1:ret
rnd3	call rnd8:and 3,a:jr z,rnd3:dec a:ret
; out: a - rnd 8bit
rnd8	push de,hl:call rnd16:ld a,h:pop hl,de
	ret
; out: hl - rnd 16bit
rnd16	ld de,seed
	ld a,d,h,e,l,253
	or a:sbc hl,de,a,0,hl,de
	ld d,0:sbc a,d:ld e,a:sbc hl,de
	jr nc,rnd:inc hl
rnd	ld (rnd16+1),hl
	ret
; in: a - max value
rnd_x	push af: call rnd8
	ld l,a: pop af
	cp l: jr c,rnd_x
	ld a,l: ret
