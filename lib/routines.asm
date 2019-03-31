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

; clear pixel screen
cls_pix
	ld (cls_pix_sp+1),sp, sp,screen_address+#1800
	ld hl,0, a, 6144/2/192
1	.192 push hl
	dec a: jp nz,1b
cls_pix_sp
	ld sp,0: ret

; im2 table create
im2_init
	ld hl,im_tab,de,hl,bc,#101,(hl),(high im_tab+1):inc de:ldir
	ld a,#c3,hl,immer,(im_tab+#100+(high im_tab+1)),a,(im_tab+#100+(high im_tab+2)),hl
	ld a,#be,i,a:im 2
	ret

; im 2 routine
immer
	ex (sp),hl:ld (im2_ret+1),hl
	pop hl:ld (im2_stack+1),sp,sp,#bfbf
	push af,bc,de,hl,ix,iy
	exa:exx:push af,bc,de,hl

	ld a,(bank+1): push af
; 	ld hl,scr,a,#16:add a,(hl):call set_bnk
; play	call #c005
	pop af: ld (bank+1),a
	; ld hl,scr:add a,(hl)
	ld bc,#7ffd:out (c),a

	ld hl,(count):inc hl:ld (count),hl
	pop hl,de,bc,af:exx:exa
	pop iy,ix,hl,de,bc,af
im2_stack ld sp,0:ei
im2_ret	jp 0

count	dw 0

; bank and screen change
scr_swap
	ld a,#1d:xor 10:ld (scr_swap+1),a
set_bnk	ld (bank+1),a
bank	ld a,0
	push bc:ld bc,#7ffd:out(c),a:pop bc:ret

