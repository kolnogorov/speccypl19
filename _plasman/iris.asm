    device zxspectrum128

    org #6000

M_X     EQU     7   ; scale x
M_Y     EQU     7   ; scale y

        ORG     #6000

        ei:HALT
        LD      HL,#5800
        LD      DE,#5801
        LD      BC,#2FF
        LD      (HL),L
        LDIR

; draw a grid
        LD      HL,#4000
LP1     LD      A,%01010101
        BIT     0,H
        JR      NZ,NE_FF
        CPL
NE_FF   LD      (HL),A
        INC     HL
        LD      A,H
        CP      #58
        JR      NZ,LP1

; main loop

MAIN_LP LD      IX,BUFER+#2FF

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
        AND     #7F

        LD      (IX),A
        DEC     IX

        INC     C     ;!
ADR_MX  LD      A,M_X
        ADD     A,B
        LD      B,A

        EXX
        DJNZ    LOOP_H

        EXX

ADR_MY  LD      A,M_Y
        ADD     A,E
        LD      E,A
        INC     D     ;!

        EX      AF,AF'
        DEC     A
        JP      NZ,LOOP_V

        LD      HL,(MEM_BP)
        DEC     HL          ;!!
        LD      (MEM_BP),HL

        LD      A,L
        XOR     H
        LD      HL,BUFER+#2FF
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

        CALL    TO_SCR

        XOR     A
        IN      A,(254)
        CPL
        AND     31
        JR      NZ,OBR_Z

        CALL    INC_M
        JP      MAIN_LP


OBR_Z

; zooming

        CALL    DEC_M
        JP      MAIN_LP

MEM_BP  DW  0
M_1     DB  0
M_2     DB  0
M_3     DB  0
M_4     DB  0
NAPR    DB  2,1,3,4

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

;-----------------------------------

TO_SCR  LD      HL,PALETTE
        LD      DE,#5800
        LD      BC,BUFER+#2FF

        HALT
LP_S    LD      A,(BC)
        LD      L,A
        LDI
        LD      A,(BC)
        LD      L,A
        LDI
        LD      A,(BC)
        LD      L,A
        LDI
        LD      A,(BC)
        LD      L,A
        LDI
        LD      A,(BC)
        LD      L,A
        LDI
        LD      A,(BC)
        LD      L,A
        LDI
        LD      A,(BC)
        LD      L,A
        LDI
        LD      A,(BC)
        LD      L,A
        LDI
        LD      A,D
        CP      #5B
        JP      NZ,LP_S

        RET

;---------------------------------

        ORG     #C000

; adr_tab
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

;palette
PALETTE
    DB #09,#09,#09,#09,#09,#09,#09,#09
    DB #09,#09,#09,#0B,#0B,#0B,#0B,#0B
    DB #0B,#0B,#0B,#0B,#0B,#0B,#1B,#1B
    DB #1B,#1B,#1B,#1B,#1B,#1B,#1B,#1B
    DB #1A,#1A,#1A,#1A,#1A,#1A,#1A,#1A
    DB #1A,#1A,#1A,#12,#12,#12,#12,#12
    DB #12,#12,#12,#12,#12,#12,#16,#16
    DB #16,#16,#16,#16,#16,#16,#16,#16
    DB #36,#36,#36,#36,#36,#36,#36,#36
    DB #36,#36,#36,#34,#34,#34,#34,#34
    DB #34,#34,#34,#34,#34,#34,#24,#24
    DB #24,#24,#24,#24,#24,#24,#24,#24
    DB #25,#25,#25,#25,#25,#25,#25,#25
    DB #25,#25,#25,#2D,#2D,#2D,#2D,#2D
    DB #2D,#2D,#2D,#2D,#2D,#2D,#29,#29
    DB #29,#29,#29,#29,#29,#29,#29,#29


BUFER   DS  #300

/*
     Как  можно экспериментировать с этой программой:
     - изменить масштаб (константы M_X и M_Y). Это можно сделать и непосредственно во время работы программы, нажав клавишу 'Z'.
     - вместо команд INC C и INC D, помеенных "!", можно поставить команды, увеличивающие (или уменьшающие) регистры C и D не на 1, а на любое другое число.
     - команду  DEC  HL, поме енную "!!", можно  заменить на несколько таких команд (или, например, команд INC HL).
     - изменить содержимое таблицы TAB.
     - изменить  набор  цветов  с помощью палитры (массив PALETTE).
*/

end
    savesna "iris.sna", start
    display end-#6000
