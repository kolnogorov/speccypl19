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

glow_scr_adr	equ #c8ce
glow_atr_adr	equ #d9ce
earth_scr_adr	equ #d031

color		equ #47
stars_layer_1_count	equ 80
stars_layer_2_count	equ 20

; glow - #c8ce (#d9ce)
; earth - #d031

	org start

	ei
	ld sp,#5fff
	call init

	call stars_init
	ei
loop
	call scr_swap
	call scr_fill

	halt
	call pic_draw
	call glow_draw

	ld hl,stars_layer_1, bc,#0101, a,stars_layer_1_count: call stars_render
	ld hl,stars_layer_2, bc,#0202, a,stars_layer_2_count: call stars_render
	; ld hl,stars_layer_3, bc,#0303: call stars_render

	call earth_draw

	ld a,#7f: in a,(#fe): bit 0,a: call z,direction_change
	ld a,#f7: in a,(#fe): bit 0,a: call z,speed_set_1
	ld a,#f7: in a,(#fe): bit 1,a: call z,speed_set_2
	ld a,#f7: in a,(#fe): bit 2,a: call z,speed_set_3

	jp loop



; ----- init
init
	di
	sub a: out (#fe),a

	ld hl,#4000, bc,#1800, de,hl: inc de: ld (hl),l: ldir
	ld bc,#2ff, (hl),color: ldir
	ld a,#17: call set_bnk
	ld hl,#4000, de,#c000, bc,#1b00: ldir

	ld a,#16: call set_bnk, #c000

	ld a,#10: call set_bnk
	ld hl,mask, de,tmp_buffer, bc,mask_end-mask: ldir
; 	call depack

	call dot_init
	call pic_draw_init
	call earth_init

	call im2_init
	ret

; ----- modules
	include "lib/routines.asm"
	include "modules/dot.asm"
	include "modules/picture.asm"
	include "modules/stars.asm"
	include "modules/glow.asm"
	include "modules/earth.asm"

; -----	assets
depack		include	"lib/dzx7.asm"
glow_atr	inctrd "empty.trd", "glowatr.C"
earth_first	incbin "gfx/earth_first.zx7"
		display "code end: ", $

		org tmp_buffer
mask		inctrd "empty.trd", "maskspr.C"
mask_end
		display "tmp buffer end: ", $


; ----- pages
		page 0
		org #c000
earth		inctrd "empty.trd", "earth.C"
glow		inctrd "empty.trd", "glowspr.C"

		display "#10 end: ",$

		page 6
		org #c000
		inchob "music/music.$c"

; ----- save
	savesna "demo.sna",start
	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
