flame
            ld      de, 7700h
            ld      b, 20h
loop_2:     inc     hl
            ld      a, h
            and     1Fh
            ld      h, a
            ld      a, (hl)
            rra
            ld      a, 0
            jr      c, loop_3
            ld      a, 3Fh
loop_3:     ld      (de), a
            inc     de
            djnz    loop_2
            ld      hl,Ch_scr
            ld      hx,24
1	        ld lx,32: push hl
loop_4:	    push hl
; 	      ld      a, (ix+32)
;             add     a, (ix+33)
;             add     a, (ix+34)
;             add     a, (ix+65)

	inc h: ld a,(hl)
	inc l: add a,(hl)
	inc l: add a,(hl)
	inc h,l: add a,(hl)

            srl a,a
            jr      z, loop_5
            dec     a
loop_5:     pop hl: inc l
            ld (hl), a
            dec lx: jr nz,loop_4
	        pop hl: inc h
	        dec hx: jr nz,1b

	ret