intro
	ld hl,oxygen_scr, de,#4000: call depack
	ld hl,oxygen_atr, de,#6000: call depack
	ei: halt

	ld hl,jmj:call on

	ld bc,96: call wait
	ld hl,oxygene:call on

	ld bc,144: call wait
	ld hl,spectrumized:call on

	ld bc,192: call wait
	ld hl,stardust:call on

	ld bc,384: call wait
	ld hl,stardust:call off

	ld bc,480: call wait
	ld hl,spectrumized:call off

	ld bc,528: call wait
	ld hl,jmj:call off

	ld bc,576: call wait
	ld hl,oxygene:call off
	ei
	call fx

	ld hl,#c000, de,#4000, bc,#1800: call fast_ldir
	ld bc,704: call wait

	call fade_in

	ret

fade_in
	ld hl,#5800
	ld a,#18: push hl: call rnd_x: pop hl: and a: jr z,1f
	ld de,#20, b,a: add hl,de:djnz $-1
1	call rnd8: and #1f: add a,l: ld l,a
	ld de,hl: ld a,h: or #80: ld h,a
	ldi
	ld hl,(count), bc,768
	and a: sbc hl,bc: jp c,fade_in
	ld hl,#d800, de,#5800, bc,#300: call fast_ldir
	ret

on
	ld e,(hl): inc hl: ld d,(hl): inc hl
	ld c,(hl): inc hl: ld b,(hl): inc hl
	ld l,e,a,d: add a,#8: ld h,a
1	push bc,hl,de
	ld b,0: call fast_ldir
	ld bc,#20
	pop hl: add hl,bc: ex de,hl
	pop hl: add hl,bc
	pop bc: djnz 1b
	ret

off
	ld e,(hl): inc hl: ld d,(hl): inc hl
	ld c,(hl): inc hl: ld b,(hl): inc hl
	ex de,hl
1	push bc,hl
	sub a: ld b,a: call fill_a
	ld bc,#20
	pop hl: add hl,bc
	pop bc: djnz 1b
	ret

jmj		dw #5863: db 26, 3
oxygene		dw #58e0: db 31, 4
spectrumized	dw #5a06: db 19, 3
stardust	dw #5a68: db 16, 3
