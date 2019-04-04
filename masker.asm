; 	scr+mask cruncher - screen address table
;
	device zxspectrum128

start	equ #6000


pic_code		equ #c000
scr_tab			equ #7000;[#400]
atr_tab			equ scr_tab+#200
freq_tab		equ #7400

skip_color	equ #3

	org start

	sub a : out (#fe),a

	ld a,#10: call set_bnk

	ld hl,mask, de,#4000, bc,#1b00: ldir
	; ld hl,pix, de,#8000, bc,#1b00: ldir


	ld hl,#8000: call freqcalc
	call maskgen
	; call atrgen

;	#4038, #4079


	ld hl,#5800, de,hl, bc,#2ff, (hl),7: inc de: ldir

	di

	; ld hl,0,de,#4000,bc,#1800:ldir
	ld hl,#4000,de,#4001,bc,#17ff,(hl),#ff:ldir

	ld (mask_ex+1),sp, sp,scr_tab, ix,mask_ex
	jp pic_code
mask_ex	ld sp,0

	jr $

freq_pix1	db #00
freq_pix2	db #7f
freq_pix3	db #fe
freq_pix4	db #ff

freq_atr1	db #06
freq_atr2	db #46
freq_atr3	db #47
freq_atr4	db #77
freq_atr5	db #57

freqcalc
	ex de,hl
	ld a,d: add #18: ld c,a
	ld h,high freq_tab
1	ld a,(de),l,a: inc (hl),de
	ld a,d: cp c: jp nz,1b

	ld a,d: add #3: ld c,a
	inc h
2	ld a,(de),l,a: inc (hl),de
	ld a,d: cp c: jp nz,2b

	ret

maskgen
	ld ix,pic_code, iy,scr_tab

	ld hl,#4000

	ld (ix),#01:inc ix	; ld bc,XXXX
	ld a,(freq_pix2),(ix),a:inc ix	; b = #00
	ld a,(freq_pix1),(ix),a:inc ix	; c = #ff
	ld (ix),#11:inc ix	; ld de,XXXX
	ld a,(freq_pix4),(ix),a:inc ix	; d = #88
	ld a,(freq_pix3),(ix),a:inc ix	; e = #55
	inc ix,ix,ix

	ld a,192, c,0		; c - new line flag
loop_y	push af,de,hl
	ld a,32
loop_x	exa
	ld a,(hl)
	cp #ff: jp z,skip	; no mask, no pix

	ld b,a: sub a: cp c: ld a,b: jr nz,3f

	ld (ix),#e1: inc ix	; ld hl,xxxx
	ld (iy),l: inc hy,hy: ld (iy),l: dec hy,hy: inc iy
	ld (iy),h: inc hy,hy: set 7,h: ld (iy),h: dec hy,hy: inc iy: res 7,h
	ld c,1

3	and a: jp nz,2f					; check if nomask+pic
	inc l: cp (hl):dec hl:jp nz,4f
	ex de,hl
	ld a,(hl)
	inc l: cp (hl): dec hl				; check for repeating bytes
	ex de,hl:jp nz,4f
	and a:jp nz,7f					; check if nomask and pix=0

1	ld (ix),#70: inc ix
	ld (ix),#2c: inc ix
	ld a,(hl)
	inc l: cp (hl):dec hl:jp nz,skip
	ex de,hl
	ld a,(hl)
	inc l: cp (hl): dec hl
	ex de,hl:jp nz,skip
	inc l,e: exa: dec a: exa: jp 1b
	dec l,e:jp skip


7	ld (ix),#3e: inc ix	; ld a,XX
	ld a,(de),(ix),a: inc ix
6	ld (ix),#77: inc ix
	ld (ix),#2c: inc ix
	ld a,(hl)
	inc l: cp (hl):dec hl:jp nz,skip
	ex de,hl
	ld a,(hl)
	inc l: cp (hl): dec hl
	ex de,hl:jp nz,skip
	inc l,e: exa: dec a: exa:jp 6b
5	dec l,e:jp skip



4	ld a,(de)
	push iy
	ld iy,freq_pix1
	cp (iy+0): jr nz,5f	; b
	ld (ix),#70:inc ix:jr 9f
5	cp (iy+1): jr nz,6f	; c
	ld (ix),#71:inc ix:jr 9f
6	cp (iy+2): jr nz,7f	; b
	ld (ix),#72:inc ix:jr 9f
7	cp (iy+3): jr nz,8f	; c
	ld (ix),#73:inc ix:jr 9f
8	ld (ix),#36: inc ix	; ld (hl),XX
	ld (ix),a: inc ix
9	ld (ix),#2c: inc ix	; inc l
	pop iy

	jp skip

2	ld (ix),#7e: inc ix	; ld a,(hl)
	push iy
	ld iy,freq_pix1
	cp (iy+0): jr nz,5f	; b
	ld (ix),#a0:inc ix:jr 9f
5	cp (iy+1): jr nz,6f	; c
	ld (ix),#a1:inc ix:jr 9f
6	cp (iy+2): jr nz,7f	; b
	ld (ix),#a2:inc ix:jr 9f
7	cp (iy+3): jr nz,8f	; c
	ld (ix),#a3:inc ix:jr 9f
8	ld (ix),#e6: inc ix	; ld (hl),XX
	ld (ix),a: inc ix
9	pop iy

	ld a,(de): and a: jr z,1f

	push iy
	ld iy,freq_pix1
	cp (iy+0): jr nz,5f	; b
	ld (ix),#b0:inc ix:jr 9f
5	cp (iy+1): jr nz,6f	; c
	ld (ix),#b1:inc ix:jr 9f
6	cp (iy+2): jr nz,7f	; b
	ld (ix),#b2:inc ix:jr 9f
7	cp (iy+3): jr nz,8f	; c
	ld (ix),#b3:inc ix:jr 9f
8	ld (ix),#f6: inc ix	; ld (hl),XX
	ld (ix),a: inc ix
9	pop iy

1	ld (ix),#77: inc ix	; ld (hl),a
	ld (ix),#2c: inc ix	; inc l

skip	inc e,l
	exa: dec a: jp nz,loop_x
	dec ix
	ld c,0
	pop hl,de: call down_h, down_d
	pop af: dec a: jp nz,loop_y

	ret

; attribute

atrgen
	ld hl,#8000, de,#4000, bc,#1b00: ldir
	ld (ix),#01:inc ix	; ld bc,XXXX
	ld a,(freq_atr2),(ix),a:inc ix	; b = #00
	ld a,(freq_atr1),(ix),a:inc ix	; c = #ff
	ld (ix),#11:inc ix	; ld de,XXXX
	ld a,(freq_atr4),(ix),a:inc ix	; d = #88
	ld a,(freq_atr3),(ix),a:inc ix	; e = #55
	ld (ix),#3e:inc ix	; ld de,XXXX
	ld a,(freq_atr5),(ix),a:inc ix	; a = #55

	ld hl,#9800, de,#5800, b,4	; b - counter, if b > 3 set adr, else inc adr
atr_loop
	ld a,(de): cp skip_color: ld a,(hl)
	jp z, atr_skip
	ld c,a,a,b: cp 3: ld a,c: jr c,2f
	ld b,0
	ld (ix),#e1: inc ix	; pop hl
	ld (iy),e: inc hy,hy: ld (iy),e: dec hy,hy: inc iy
	ld (iy),d: inc hy,hy: set 7,d: ld (iy),d: dec hy,hy: inc iy: res 7,d
	jr 1f
2	push af,hl
5	ld a,l:cp #ff:jr nz,3f
	ld (ix),#23: jr 4f	; inc l
3	ld (ix),#2c		; inc hl
4	inc ix,hl: djnz 5b
	pop hl,af

1	ld a,(hl)
	push iy
	ld iy,freq_atr1
	cp (iy+0): jr nz,5f	; b
	ld (ix),#70:inc ix:jr 9f
5	cp (iy+1): jr nz,6f	; c
	ld (ix),#71:inc ix:jr 9f
6	cp (iy+2): jr nz,7f	; b
	ld (ix),#72:inc ix:jr 9f
7	cp (iy+3): jr nz,4f	; c
	ld (ix),#73:inc ix:jr 9f
4	cp (iy+4): jr nz,8f	; a
	ld (ix),#77:inc ix:jr 9f
8
	inc l:cp (hl):dec hl:jp nz,10f
	; ld (ix),#3e: inc ix


10	ld (ix),#36: inc ix	; ld (hl),XX
	ld (ix),a: inc ix
9	pop iy
atr_skip
	inc hl,de,b

	ld a,d:cp #5b
	jp nz,atr_loop

	; ld (ix),#c9		; ret
	ld (ix+0),#dd
	ld (ix+1),#e9

	ret




	jr $


set_bnk
	ld bc,#7ffd : out (c),a : in a,(c)
	ret

down_d inc d:ld a,d:and 7:ret nz:ld a,e:add a,#20:ld e,a:ret c:ld a,d:sub 8:ld d,a:ret
down_h inc h:ld a,h:and 7:ret nz:ld a,l:add a,#20:ld l,a:ret c:ld a,h:sub 8:ld h,a:ret
down_h8	ld a,h:add a,8:ld h,a
	ld a,l:add a,#20:ld l,a:ret c:ld a,h:sub 8:ld h,a:ret
down_d8	ld a,d:add a,8:ld d,a
	ld a,e:add a,#20:ld e,a:ret c:ld a,d:sub 8:ld d,a:ret


	org #8000
pix	ds #1800: ds #300, #47

	page 0
	org #c000
mask	inctrd "empty.trd", "mask1.C"


	savesna "../_tools/unreal/qsave1.sna", start
	labelslist "../_tools/unreal/user.l"
