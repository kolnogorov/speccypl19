	device zxspectrum128

screen_address	equ #c000


Ch_scr  	EQU #6000		; [#1800]// чанковый буфер
Out_cd  	EQU #7900		; [#0500]// код построения пикселов
;		#7e00-#8000		; [#0300]
tmp_buffer	equ #8000		; [#0e40] - 19*24*8

pic_draw_code	equ #8c00		; [#1700]
start		equ #a500

edges_tab	equ #b400
C2p_acd 	EQU #b480		; [#00A0]// код построения атрибутов
C2p_pcd 	EQU #b520		; [#00C0]// код генерации построения пикселов
scr_buffer	equ #b600		; [#0300]
dot_tab		equ #b900		; [#0400]
stars_layer_1	equ #bd00		; [#00a0]
stars_layer_2	equ #bda0		; [#0048]
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

	ld sp,#5fff
	call init

	call stars_init
	ei
	; di
loop
	call scr_swap
	call scr_update

	; call scr_fill
	halt
	call c2p_draw
	halt
	call pic_draw
	call glow_draw

	ld hl,stars_layer_1, bc,#0101, a,stars_layer_1_count: call stars_render
	ld hl,stars_layer_2, bc,#0202, a,stars_layer_2_count: call stars_render
	; ld hl,stars_layer_3, bc,#0303: call stars_render

	; halt
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

	call dot_init
	call earth_init
	call pic_draw_init
	call c2p_init

	call im2_init
	ret

; ----- modules
	include "lib/routines.asm"
	include "modules/dot.asm"
	include "modules/picture.asm"
	include "modules/stars.asm"
	include "modules/glow.asm"
	include "modules/earth.asm"
	include "modules/c2p.asm"

; -----	assets
depack		include	"lib/dzx7.asm"
glow_atr	inctrd "empty.trd", "glowatr.C"
earth_first	incbin "gfx/earth_first.zx7"

Txt_xsz EQU #20
; размер текстуры по X
; по Y всегда #20!!!
; Chtxt_t incbin "_machined/TEX5.raw"

	ALIGN #100
Palette inctrd "empty.trd", "palette.C";[#0200]
Atr_tb  EQU Palette
Pix_tb  EQU Palette+#0100

		display "code end: ", $
		display "code length: ", $-start

	org edges_tab
	incbin "tabs/edge_tab.bin"

; ----- pages
		page 0
		org #c000
earth		inctrd "empty.trd", "earth.C"
glow		inctrd "empty.trd", "glowspr.C"

		display "#10 end: ",$

		page 1
		org #c000
mask_spr	inctrd "empty.trd", "mask_spr.C"
mask_atr	inctrd "empty.trd", "mask_atr.C"

		display "#11 end: ", $

		page 6
		org #c000
		inchob "music/music.$c"

; ----- save
	savesna "demo.sna",start
	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
