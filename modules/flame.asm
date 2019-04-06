flame
                ; call rnd16
                ld      de, #7800
                ld      b, 20h
loop_2:         inc     hl
                ; ld      a, h
                ; and     1Fh
                ; ld      h, a
                ; ld      a, (hl)
                ; rra
                ; ld      a, 0
                ; jr      c, loop_3
                ; ld      a, #1f
                call rnd8: and #3f
loop_3:         ld      (de), a
                inc     de
                djnz    loop_2
                ld      hl, Ch_scr+#100
                ld      hy,24
loop_5          ld	ly,32
loop_4          push hl
                inc h: ld a,(hl)
                inc l: add a,(hl)
                inc l: add a,(hl)
                inc h: dec l: add a,(hl)
                ; inc l,l: add a,(hl)
                srl a,a
                and #3f
                jr z,$+2+1: dec a
                pop hl
                ; call rnd1: add a,l
                inc l: ld (hl),a
                dec ly: jp nz,loop_4
                ld l,0: inc h
                dec hy: jp nz, loop_5

                ; ld hl,#7600, de,#76fe, bc,#1e: call fast_ldir
                ret
