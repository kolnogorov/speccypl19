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
	ld a,stars_layer_1_count, hl,stars_layer_1: call stars_generate_layer
	ld a,stars_layer_2_count, hl,stars_layer_2: call stars_generate_layer
	; ld hl,stars_layer_3: call stars_generate_layer
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
;	a - stars count
; 	b - start type (1x1 pix, 2x2 pix, 3x3 pix)
; 	c - speed in pixels
stars_render
	ld ix,stars_render_exit
	ld (start_render_count+1),a
	ld a,b, (stars_render_type+1),a
	ld a,c
stars_speed		ds 4		; nop/add a,a
stars_direction		nop:neg		; nop/neg
start_render_count	ld b,0, (stars_render_speed+1),a
stars_render_loop
	ld e,(hl): inc hl: ld a,(hl)
stars_render_speed add a,0: ld d,a, (hl),a: inc hl
	push hl
	ex de,hl
	; call dot_2x2
stars_render_type	ld a,0
	cp 1: jp z,dot_1x1
	cp 2: jp z,dot_2x2
	; cp 3: call z, dot_3x3
stars_render_exit	pop hl
	djnz stars_render_loop
	ret


; stars_render
; 	ld ix,stars_render_exit
; 	ld (start_render_count+1),a, a,c
; stars_speed	ds 4		; nop/add a,a
; stars_direction	nop:neg		; nop/neg
; 	ld c,a, a,b, (stars_type+1),a
; start_render_count	ld b,0
; stars_render_loop
; 	ld e,(hl): inc hl: ld a,(hl)
; stars_render_speed add a,0: ld d,a, (hl),a
; 	inc hl
; 	push hl
; 	ex de,hl
; 	; call dot_2x2
; stars_type	ld a,0
; 	cp 1: jp z,dot_1x1
; 	cp 2: jp z,dot_1x1
; 	; cp 3: call z, dot_3x3
; stars_render_exit	pop hl
; 	djnz stars_render_loop
; 	ret