M_X	db 7
M_Y	db 7

plasma
        ld a,#11: call set_bnk_save
        call MAIN_LP
        call set_bnk_restore
        ret

MAIN_LP
        ld hl,Ch_scr+#171f: exx
        ld IX,scr_buffer+#2ff, iy,palette

        LD      H,TAB/#100
        LD      DE,(M_3)
        LD      A,24

LOOP_V  EX      AF,AF'
        LD      BC,(M_1)
        EXX
        LD      B,32

LOOP_H  EXX
        LD      A,(MEM_BP)
        LD      L,C
        ADD     A,(HL)
        LD      L,B
        ADD     A,(HL)
        LD      L,E
        ADD     A,(HL)
        LD      L,D
        ADD     A,(HL)
        ; cpl
        ; AND     #3f
        ; srl a
        ld ly,a, a,(iy)

;Старший бит аккумулятора обнулен, и буфер заполняется значе-
;ниями #00-#7F. Это пригодится в процедуре TO_SCR.

plasma_put
        LD      (IX),A
        ; exx
        ; ld (hl),a: dec l
        ; exx
        DEC     IX

        .3 INC     C     ;     !
ADR_MX  LD      A,(M_X)
        ADD     A,B
        LD      B,A

        EXX
        dec b: jp nz,LOOP_H
        ld l,#1f
        dec h
        EXX

ADR_MY  LD      A,(M_Y)
        ADD     A,E
        LD      E,A
        .5 INC     D     ;     !

        EX      AF,AF'
        DEC     A
        JP      NZ,LOOP_V

        LD      HL,(MEM_BP)
        .5 DEC     HL          ;     !!
        LD      (MEM_BP),HL

        LD      A,L
        XOR     H
        LD      HL,scr_buffer+#2FF
        XOR     (HL)
        XOR     E
        XOR     C
        ADD     A,D
        ADD     A,B
        LD      B,A

        LD      HL,NAPR
        AND     3
        LD      D,0
        LD      E,A
        ADD     HL,DE
        LD      A,(HL)

        BIT     3,B
        JR      NZ,TO_DEC

        CP      3
        JP      P,TO_END
        INC     (HL)
        JR      TO_END

TO_DEC  CP      #FD
        JP      M,TO_END
        DEC     (HL)

TO_END  LD      A,(NAPR)
        LD      HL,M_1
        ADD     A,(HL)
        LD      (HL),A

        LD      A,(M_2)
        LD      HL,NAPR+1
        SBC     A,(HL)
        LD      (M_2),A

        LD      A,(NAPR+2)
        LD      HL,M_3
        ADD     A,(HL)
        LD      (HL),A

        LD      A,(M_4)
        LD      HL,NAPR+3
        SBC     A,(HL)
        LD      (M_4),A
        ; ret

        ld hl,scr_buffer, de,Ch_scr, b,24
1       push bc,de
        .32 ldi
        pop de: inc d
        pop bc: djnz 1b

        ; call INC_M
        ; ld a,(M_X): inc a: and #1f: add a,7: ld (M_X),a
        ; ld a,(M_Y): inc a: and #1f: add a,7: ld (M_Y),a

        ; ld hl,M_X
        ; inc (hl)
        ; inc hl
        ; dec (hl)
        ret

OBR_Z
zoom
        CALL    DEC_M
        ret

MEM_BP  DW  0
M_1     DB  0
M_2     DB  0
M_3     DB  0
M_4     DB  0
NAPR    DB  2,4,8,16

;-----------------------------------
; increase scale
INC_M   LD      HL,ADR_MX+1
        LD      A,(M_X)
        CP      (HL)
        JR      NC,INC_Y
        INC     (HL)
INC_Y   LD      HL,ADR_MY+1
        LD      A,(M_Y)
        CP      (hl)
        RET     NC
        INC     (HL)
        RET

;decrease scale
DEC_M   LD      HL,ADR_MX+1
        LD      A,(HL)
        AND     A
        JR      Z,DEC_Y
        DEC     (HL)
DEC_Y   LD      HL,ADR_MY+1
        LD      A,(HL)
        AND     A
        RET     Z
        DEC     (HL)
        RET

