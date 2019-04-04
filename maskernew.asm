	device zxspectrum128

pic 		equ #4000
start		equ #6000
packed		equ #8000


	org start

	sub a: out (#fe),a

	ld hl,mask, de,pic, bc,#1b00: ldir

	ld hl,packed, de,pic, hy,192
1	ld ly,32: push de
2	ld a,(de): inc de
	cp #ff: jr z,3f		; skip


3	dec ly: jr nz,2b
	pop de: call down_d	; change to inc d
	dec hy: jr nz,1b




	jr $


inner_loop
	ld a,#00:and (hl): ld (hl),a



down_d	inc d: ld a,d: and 7: ret nz: ld a,e: add a,#20: ld e,a: ret c: ld a,d: add a,-8: ld d,a: ret
down_h	inc h: ld a,h: and 7: ret nz: ld a,l: add a,#20: ld l,a: ret c: ld a,h: add a,-8: ld h,a: ret

	org #c000
mask	inctrd "empty.trd", "mask1.scr"

; ----- save
	savesna "demo.sna",start
	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
