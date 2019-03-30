	device zxspectrum128

start		equ #6000
screen_address	equ #4000

dot_tab		equ #8000	; [#0200]
stars_tab	equ #8200	; [#0100]

color		equ #47
stars_count	equ 10

	org start

	call init

	ld a,128
	call stars_init





	jr $


	display rnd3
stars_init
	push af
	ld a,#ff: call rnd_x: ld h,a
	ld a,#bf: call rnd_x: ld l,a
	push hl: call rnd3: pop hl
	and a: call z,dot_1x1
	cp 1: call z,dot_2x2
	cp 2: call z,dot_3x3
	pop af: dec a: jr nz,stars_init
	ret

; ----- init
init
	ld hl,mask
	ld de,#4000
	; call depack

	sub a: out (#fe),a

	ld hl,#4000, bc,#1800, de,hl: inc de: ld (hl),l: ldir
	ld bc,#2ff, (hl),color: ldir


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
