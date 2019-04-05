M_X	equ 7
M_Y	equ 7

plasma
MAIN_LP LD      IX,scr_buffer+#2ff, iy,palette

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

plasma_put       LD      (IX),A
        DEC     IX

        INC     C     ;     !
ADR_MX  LD      A,M_X
        ADD     A,B
        LD      B,A

        EXX
        dec b: jp nz,LOOP_H

        EXX

ADR_MY  LD      A,M_Y
        ADD     A,E
        LD      E,A
        INC     D     ;     !

        EX      AF,AF'
        DEC     A
        JP      NZ,LOOP_V

        LD      HL,(MEM_BP)
        DEC     HL          ;     !!
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
NAPR    DB  1,2,3,4

;-----------------------------------
; increase scale
INC_M   LD      HL,ADR_MX+1
        LD      A,(HL)
        CP      M_X
        JR      NC,INC_Y
        INC     (HL)
INC_Y   LD      HL,ADR_MY+1
        LD      A,(HL)
        CP      M_Y
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
