; ----- dot routines
dot_init
	ld hl,dot_tab+#100, de,screen_address
1	ld (hl),d: dec h: ld (hl),e: inc h: call down_d
	ld a,d: sub 88: jr nz,$+3: ld d,a: inc l: jr nz,1b: inc h: ld a,#80
2	ld (hl),e: inc h: ld (hl),a: dec h: rrca: jr nc,$+3: inc e,l: jr nz,2b
	ret


; dot_3x3
; 	.4 push hl
; 	call dot_put
; 	pop hl: dec l
; 	call dot_put
; 	pop hl: inc l
; 	call dot_put
; 	pop hl: dec h
; 	call dot_put
; 	pop hl: inc h
; 	jp dot_put

; in: hl - x,y
;     a - method (or/xor/and)
; HL = x,y
dot_put	; ld (dot_put_method),a
	ld e,h, h,high dot_tab, d,(high dot_tab)+2
	ld a,(de): inc d: or (hl): inc h: ld h,(hl), l,a, a,(de)
dot_put_method
	or (hl)
	ld (hl),a
	ret

dot_2x2
	ld (dot_2x2_2+1),hl
	ld (dot_2x2_3+1),hl
	ld (dot_2x2_4+1),hl
	call dot_put
dot_2x2_2	ld hl,0: inc h: call dot_put
dot_2x2_3	ld hl,0: inc l: call dot_put
dot_2x2_4	ld hl,0: inc h,l
	; call dot_put
	; push hl: call dot_put: pop hl
	; inc h
	; push hl: call dot_put: pop hl
	; inc l
	; push hl: call dot_put: pop hl
	; dec h

dot_1x1
dot_put_ix	call dot_put: jp (ix)