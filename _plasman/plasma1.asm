    device zxspectrum128

;--------------------------;
; (c) Иван Рощин, 1997     ;
; ЭФФЕКТ "PLASMA-2"        ;
;--------------------------;

BUF     EQU     #8000  ;Адрес буфера
        org #6000

;Установка атрибутов:

        LD      HL,#5800
        LD      (HL),%00101111
        LD      DE,#5801
        LD      BC,#2FF
        LDIR

;Очищаем буферную область
;(#640 байт с адреса BUF):

        LD      HL,BUF
        LD      (HL),0
        LD      DE,BUF+1
        LD      BC,#63F
        LDIR

;Переносим содержимое верхней строки
;буферной области вниз и наоборот,
;т.е. экран как бы замкнут по вертикали:

M2      LD      HL,BUF+32
        LD      DE,BUF+#300+32
        LD      BC,32
        LDIR
        LD      HL,BUF+#300
        LD      DE,BUF
        LD      BC,32
        LDIR

;В цикле обновляем атрибуты в буфере:

        LD      IX,BUF+32
M1      LD      A,(IX+1)
        ADD     A,(IX-1)
        ADD     A,(IX+32)
        ADD     A,(IX-32)

        SRL     A
        DEC     A
        SRL     A

        LD      (IX),A
        CALL    TO_SCR
        INC     IX
        LD      A,XL
        CP   BUF+#320-((BUF+#320)/256*256)
        JP      NZ,M1
        LD      A,XH
        CP      (BUF+#320)/256
        JP      NZ,M1

;Обновили весь буфер:

        XOR     A
        IN      A,(254)
        CPL
        AND     31
        JR      Z,M2
        RET

;--------------------------------------
;Процедура TO_SCR штрихует текущее
;знакоместо.
;
;Вход: A  - значение из буфера,
;           определяющее тип штриховки
;      IX - текущий адрес в буфере

TO_SCR  AND     %00111000
        RRCA
        LD      L,A
        LD      H,0
        LD      DE,TAB-4
        ADD     HL,DE
        LD      B,H
        LD      C,L

;BC - адрес штриховки

        PUSH    IX
        POP     HL
        LD      DE,#320
        ADD     HL,DE

;HL - адрес во вспомогательном буфере,
;     где хранится прошлое значение
;     штриховки для этого знакоместа

        CP      (HL)  ;значения совпали?
        RET     Z     ;если да - выходим

        PUSH    AF
        LD      (HL),A
        LD      DE,BUF-#340
        ADD     HL,DE

;HL - смещение в основном буфере, узнаем
;     по нему координаты знакоместа:

        LD      A,L
        AND     31
        LD      D,A    ;X
        RL      L
        RL      H
        RL      L
        RL      H
        RL      L
        RL      H
        LD      A,H
        AND     31
        LD      E,A    ;Y

        AND     #18
        OR      #40
        LD      H,A
        LD      A,E
        AND     #7
        RRA
        RRA
        RRA
        RRA
        ADD     A,D
        LD      L,A

;HL - адрес на экране

        POP     AF       ;если A=0,
        AND     A        ;просто очищаем
        JP      Z,TO_CL  ;знакоместо

        LD      D,H
        LD      E,L
        INC     D
        INC     D
        INC     D
        INC     D

;HL указывает на верхнюю линию знакоместа,
;а DE - на четыре линии ниже

        LD      A,(BC)
        LD      (HL),A
        LD      (DE),A
        INC     H
        INC     D
        INC     BC
        LD      A,(BC)
        LD      (HL),A
        LD      (DE),A
        INC     H
        INC     D
        INC     BC
        LD      A,(BC)
        LD      (HL),A
        LD      (DE),A
        INC     H
        INC     D
        INC     BC
        LD      A,(BC)
        LD      (HL),A
        LD      (DE),A
        RET

;Если нужно просто очистить знакоместо:

TO_CL   LD      (HL),A
        INC     H
        LD      (HL),A
        INC     H
        LD      (HL),A
        INC     H
        LD      (HL),A
        INC     H
        LD      (HL),A
        INC     H
        LD      (HL),A
        INC     H
        LD      (HL),A
        INC     H
        LD      (HL),A
        RET

;Таблица, определяющая различные типы
;штриховок:

TAB     DB  %01000100
        DB  %00000000
        DB  %00010001
        DB  %00000000

        DB  %01000100
        DB  %00010001
        DB  %01000100
        DB  %00010001

        DB  %01010101
        DB  %10101010
        DB  %01010101
        DB  %10101010

        DB  %11011101
        DB  %10101010
        DB  %01110111
        DB  %10101010

        DB  %01010101
        DB  %10101010
        DB  %01010101
        DB  %10101010

        DB  %01000100
        DB  %00010001
        DB  %01000100
        DB  %00010001

        DB  %01000100
        DB  %00000000
        DB  %00010001
        DB  %00000000

end
    savesna "..\..\unreal\qsave1.sna",#6000
    labelslist "..\..\unreal\user.l"
    display end-#6000