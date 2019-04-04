	device zxspectrum128

screen_address	equ #c000


pic_draw_code	equ #6000		; [#1661]
tmp_buffer	equ #8000		; [#0e40] - 19*24*8
start		equ #9b00
scr_buffer	equ #b100		; [#0180]
dot_tab		equ #b400		; [#0400]
stars_layer_1	equ dot_tab+#400	; [#0200]
stars_layer_2	equ stars_layer_1+#200	; [#0200]
stars_layer_3	equ stars_layer_2+#200	; [#0200]
im_tab		equ #be00		; [#0200]

color		equ #47
stars_count	equ 100

; glow - #c8ce (#d9ce)
; earth - #d031

	org start

	ei
	ld sp,#bfff
	call init

	call stars_init
	ei
loop

	call scr_swap
	call scr_fill
	halt
	call pic_draw

	ld hl,stars_layer_1, bc,#0101: call stars_render
	ld hl,stars_layer_2, bc,#0202: call stars_render
	ld hl,stars_layer_3, bc,#0303: call stars_render


	ld a,#7f: in a,(#fe): bit 0,a: call z,direction_change
	ld a,#f7: in a,(#fe): bit 0,a: call z,speed_set_1
	ld a,#f7: in a,(#fe): bit 1,a: call z,speed_set_2
	ld a,#f7: in a,(#fe): bit 2,a: call z,speed_set_3

	sub a: out(#fe),a
	jp loop

	halt

	halt
	jr $

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

; -----	stars fx
direction_change
	ld a,(stars_direction+1): xor #44: ld (stars_direction+1),a
	ret

speed_set_1	ld hl,0, (stars_speed),hl, (stars_speed+2), hl: ret
speed_set_2	ld hl,#8700, (stars_speed),hl, hl,0, (stars_speed+2), hl: ret
speed_set_3	ld hl,#8787, (stars_speed),hl, hl,0, (stars_speed+2), hl: ret

; starfield - initial setup, generation coords
; in:	a - stars count
; out:	stars coordinates in stars_tab
stars_init
	ld a,stars_count
	ld hl,stars_layer_1: call stars_generate_layer
	ld hl,stars_layer_2: call stars_generate_layer
	ld hl,stars_layer_3: call stars_generate_layer
	ret

stars_generate_layer
1	push af,hl
	ld a,#ff: call rnd_x: ld d,a		; random X coord
	ld a,#bd: call rnd_x: inc a: ld e,a	; random Y coord
	pop hl
	ld (hl),e: inc hl: ld (hl),d: inc hl
	pop af: dec a: jr nz,1b
	ret

; in:	hl - stars coords tab
; 	b - start type (1x1 pix, 2x2 pix, 3x3 pix)
; 	c - speed in pixels
stars_render
	ld a,c
stars_speed	ds 4		; nop/add a,a
stars_direction	dw #00ed	; nop/neg
	ld c,a, a,b, b,stars_count
stars_render_loop
	ld e,(hl): inc hl: ld d,(hl)
	exa: ld a,c: add a,(hl): ld (hl),a: exa
	inc hl
	push hl
	ex de,hl
	; call dot_3x3
	cp 1: call z, dot_1x1
	cp 2: call z, dot_2x2
	cp 3: call z, dot_3x3
	pop hl
	djnz stars_render_loop
	ret

; ----- init
init
	di
	sub a: out (#fe),a

	ld hl,#4000, bc,#1800, de,hl: inc de: ld (hl),l: ldir
	ld bc,#2ff, (hl),color: ldir
	ld a,#17: call set_bnk
	ld hl,#4000, de,#c000, bc,#1b00: ldir

	ld a,#10: call set_bnk
	ld hl,mask, de,tmp_buffer, bc,mask_end-mask: ldir
; 	call depack

	call pic_draw_init
	call dot_init


	call im2_init
	ret

; ----- modules
	include "lib/routines.asm"

	; dot_init
	; dot_put
	include "modules/dot.asm"

; -----	assets
; depack	include	"lib/dzx7.asm"
glow_atr	inctrd "empty.trd", "glowatr.C"
mask_end
	display "code end: ", $

	org tmp_buffer
mask		inctrd "empty.trd", "maskspr.C"
	display "tmp buffer end: ", $

	page 0
	org #c000
glow		inctrd "empty.trd", "glowspr.C"
earth		inctrd "empty.trd", "maskspr.C"

	display "#10 end: ",$

; ----- save
	savesna "demo.sna",start
	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
