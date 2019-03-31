	device zxspectrum128

screen_address	equ #c000

pic_buffer	equ #6000

dot_tab		equ #7800		; [#0400]
stars_layer_1	equ dot_tab+#400	; [#0200]
stars_layer_2	equ stars_layer_1+#400	; [#0200]
stars_layer_3	equ stars_layer_2+#400	; [#0200]

start		equ #8600

im_tab		equ #be00		;[#0200]

color		equ #47
stars_count	equ 100

	org start

	ld sp,#bfff
	call init

	call stars_init
	ei
loop
	halt
	call scr_swap
	ld a,2:out (#fe),a
	call cls_pix
	; call pic_draw

	ld a,3:out (#fe),a
	ld hl,stars_layer_1, bc,#0101: call stars_render
	; ld a,4:out (#fe),a
	; ld hl,stars_layer_2, bc,#0202: call stars_render
	; ld a,5:out (#fe),a
	; ld hl,stars_layer_3, bc,#0303: call stars_render


	ld a,#7f: in a,(#fe): bit 0,a: call z,direction_change
	ld a,#f7: in a,(#fe): bit 0,a: call z,speed_set_1
	ld a,#f7: in a,(#fe): bit 1,a: call z,speed_set_2
	ld a,#f7: in a,(#fe): bit 2,a: call z,speed_set_3

	sub a: out(#fe),a
	jp loop

	halt

	jr $

; ----- picture draw
pic_draw
	ld (pic_draw_sp+1),sp, sp,pic_buffer, ix,pic_draw_sp
	jp pic_draw_code
pic_draw_sp	ld sp,0
	ret

pic_draw_init
	ld hl,pic_draw_code, de,screen_address
1b	ld (hl),#e1: inc hl
	ld (hl),#22: inc hl
	ld (hl),e: inc hl: ld (hl),d: inc hl
	inc de,de
	ld a,d: cp high screen_address+#18: jp c,1b
	ld (hl),#dd: inc hl: ld (hl),#e9
	ret

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
	ld hl,mask
	ld de,pic_buffer
	call depack

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
depack	include	"lib/dzx7.asm"

pic_draw_code	equ $


	display "end: ", $

	page 0
	org #c000
mask	incbin	"gfx/mask.zx7"

	savesna "demo.sna",start
	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
