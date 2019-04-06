	device zxspectrum128

screen_address	equ #c000


Ch_scr  	EQU #6000		; [#1800]// чанковый буфер
Out_cd  	EQU #7900		; [#0500]// код построения пикселов
C2p_acd 	EQU #7da0		; [#00A0]// код построения атрибутов
C2p_pcd 	EQU #7e40		; [#00C0]// код генерации построения пикселов
edges_tab	equ #7f00
tmp_buffer	equ #8000		; [#0e40] - 19*24*8

pic_draw_code	equ #8c00		; [#1700]
start		equ #a400

scr_buffer	equ #b600		; [#0300]
dot_tab		equ #b900		; [#0400]
stars_layer_1	equ #bd00		; [#00a0]
stars_layer_2	equ #bda0		; [#0048]
im_tab		equ #be00		; [#0200]

glow_scr_adr	equ #c8ce
glow_atr_adr	equ #d9ce
earth_scr_adr	equ #d031

color			equ #47
stars_layer_1_count	equ 80
stars_layer_2_count	equ 20

; glow - #c8ce (#d9ce)
; earth - #d031

	org start

	ld sp,#5f00
	call init

	call stars_init
	ei
	; di
loop

	call scr_swap
	call scr_update

	; call scr_fill
	; halt

	; call flame
	call plasma
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
	include "modules/plasma.asm"
	; include "modules/flame.asm"

; -----	assets
depack		include	"lib/dzx7.asm"
glow_atr	inctrd "empty.trd", "glow_atr.C"
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
mask_left	inctrd "empty.trd", "left.C"
mask_right	inctrd "empty.trd", "right.C"
; mask_spr	inctrd "empty.trd", "mask_spr.C"
; mask_atr	inctrd "empty.trd", "mask_atr.C"
        align #100
TAB
        DB #40,#40,#40,#40,#40,#40,#40,#40
        DB #3F,#3F,#3F,#3F,#3F,#3E,#3E,#3E
        DB #3E,#3D,#3D,#3D,#3C,#3C,#3B,#3B
        DB #3B,#3A,#3A,#39,#39,#38,#38,#37
        DB #37,#36,#35,#35,#34,#34,#33,#32
        DB #32,#31,#30,#30,#2F,#2E,#2E,#2D
        DB #2C,#2C,#2B,#2A,#29,#29,#28,#27
        DB #26,#25,#25,#24,#23,#22,#22,#21
        DB #20,#1F,#1E,#1E,#1D,#1C,#1B,#1B
        DB #1A,#19,#18,#17,#17,#16,#15,#14
        DB #14,#13,#12,#12,#11,#10,#10,#0F
        DB #0E,#0E,#0D,#0C,#0C,#0B,#0B,#0A
        DB #09,#09,#08,#08,#07,#07,#06,#06
        DB #05,#05,#05,#04,#04,#03,#03,#03
        DB #02,#02,#02,#02,#01,#01,#01,#01
        DB #01,#00,#00,#00,#00,#00,#00,#00
        DB #00,#00,#00,#00,#00,#00,#00,#00
        DB #01,#01,#01,#01,#01,#02,#02,#02
        DB #02,#03,#03,#03,#04,#04,#05,#05
        DB #05,#06,#06,#07,#07,#08,#08,#09
        DB #09,#0A,#0B,#0B,#0C,#0C,#0D,#0E
        DB #0E,#0F,#10,#10,#11,#12,#12,#13
        DB #14,#14,#15,#16,#17,#17,#18,#19
        DB #1A,#1B,#1B,#1C,#1D,#1E,#1E,#1F
        DB #20,#21,#22,#22,#23,#24,#25,#25
        DB #26,#27,#28,#29,#29,#2A,#2B,#2C
        DB #2C,#2D,#2E,#2E,#2F,#30,#30,#31
        DB #32,#32,#33,#34,#34,#35,#35,#36
        DB #37,#37,#38,#38,#39,#39,#3A,#3A
        DB #3B,#3B,#3B,#3C,#3C,#3D,#3D,#3D
        DB #3E,#3E,#3E,#3E,#3F,#3F,#3F,#3F
        DB #3F,#40,#40,#40,#40,#40,#40,#40

palette
        db #1f,#1f,#1f,#1f,#1f,#1e,#1e,#1e
        db #1e,#1e,#1d,#1d,#1d,#1d,#1d,#1c
        db #1c,#1c,#1c,#1c,#1b,#1b,#1b,#1b
        db #1b,#1a,#1a,#1a,#1a,#1a,#19,#19
        db #19,#19,#19,#18,#18,#18,#18,#18
        db #17,#17,#17,#17,#17,#16,#16,#16
        db #16,#16,#15,#15,#15,#15,#15,#14
        db #14,#14,#14,#14,#13,#13,#13,#13
        db #13,#12,#12,#12,#12,#12,#11,#11
        db #11,#11,#11,#10,#10,#10,#10,#10
        db #0f,#0f,#0f,#0f,#0f,#0e,#0e,#0e
        db #0e,#0e,#0c,#0c,#0c,#0c,#0c,#0d
        db #0d,#0d,#0d,#0d,#0b,#0b,#0b,#0b
        db #0b,#0a,#0a,#0a,#0a,#0a,#09,#09
        db #09,#09,#09,#08,#08,#08,#08,#08
        db #07,#07,#07,#07,#07,#06,#06,#06
        db #06,#06,#06,#07,#07,#07,#07,#07
        db #08,#08,#08,#08,#08,#09,#09,#09
        db #09,#09,#0a,#0a,#0a,#0a,#0a,#0b
        db #0b,#0b,#0b,#0b,#0c,#0c,#0c,#0c
        db #0c,#0d,#0d,#0d,#0d,#0d,#0e,#0e
        db #0e,#0e,#0e,#0f,#0f,#0f,#0f,#0f
        db #10,#10,#10,#10,#10,#11,#11,#11
        db #11,#11,#12,#12,#12,#12,#12,#13
        db #13,#13,#13,#13,#14,#14,#14
        db #14,#14,#15,#15,#15,#15,#15,#16
        db #16,#16,#16,#16,#17,#17,#17,#17
        db #17,#18,#18,#18,#18,#18,#19,#19
        db #19,#19,#19,#1a,#1a,#1a,#1a,#1a
        db #1b,#1b,#1b,#1b,#1b,#1c,#1c,#1c
        db #1c,#1c,#1d,#1d,#1d,#1d,#1d,#1e
        db #1e,#1e,#1e,#1e,#1f,#1f,#1f,#1f
        db #1f

		display "#11 end: ", $

		page 6
		org #c000
		inchob "music/music.$c"

; ----- save
	savesna "demo.sna",start
	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
