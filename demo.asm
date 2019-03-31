	device zxspectrum128

start		equ #6000
screen_address	equ #c000

dot_tab		equ #8000		; [#0400]
stars_layer_1	equ dot_tab+#400	; [#0200]
stars_layer_2	equ stars_layer_1+#400	; [#0200]
stars_layer_3	equ stars_layer_2+#400	; [#0200]

im_tab		equ #be00		;[#0200]

color		equ #47
stars_count	equ 100

	org start

	call init

	ld a,100
	call stars_init
	ei
	di
loop
	; halt
	call scr_swap
	call cls_pix
	ld hl,stars_layer_1, c,1: call stars_render
	ld hl,stars_layer_2, c,2: call stars_render
	ld hl,stars_layer_3, c,3: call stars_render

	jp loop


	jr $

; starfield - initial setup, generation coords
; in:	a - stars count
; out:	stars coordinates in stars_tab
stars_init
	call im2_init
	ld hl,stars_layer_1: call stars_generate_layer
	ld hl,stars_layer_2: call stars_generate_layer
	ld hl,stars_layer_3: call stars_generate_layer
	ret

stars_generate_layer
1	push af,hl
	ld a,#ff: call rnd_x: ld d,a	; random X coord
	ld a,#bf: call rnd_x: ld e,a	; random Y coord
	pop hl
	ld (hl),e: inc hl: ld (hl),d: inc hl
	pop af: dec a: jr nz,1b
	ld (hl),#ff: inc hl: ld (hl),#ff
	ret

; in:	hl - stars coords tab
; 	c - speed in pixels
stars_render
	ld b,stars_count
stars_render_loop
	ld e,(hl): inc hl: ld d,(hl)
	ld a,c: add a,(hl): ld (hl),a
	inc hl
	push hl: call dot_put: pop hl
	djnz stars_render_loop
	ret

; ----- init
init
	ld hl,mask
	ld de,#4000
	; call depack

	sub a: out (#fe),a

	ld hl,#4000, bc,#1800, de,hl: inc de: ld (hl),l: ldir
	ld bc,#2ff, (hl),color: ldir
	ld a,#17: call set_bnk
	ld hl,#4000, de,#c000, bc,#1b00: ldir


	call dot_init
	ret

; ----- modules
	include "lib/routines.asm"

	; dot_init
	; dot_put
	include "modules/dot.asm"

; -----	assets
depack	include	"lib/dzx7.asm"
mask	incbin	"gfx/mask.scr.zx7"
scr	incbin	"gfx/mask.scr.zx7"

	savesna "demo.sna",start
	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
