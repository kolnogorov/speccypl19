    device zxspectrum128

;--------------------------;
; (c) ���� �����, 1997     ;
; ������ "PLASMA-2"        ;
;--------------------------;

BUF     EQU     #8000  ;����� ������
        org #6000

;��������� ���������:

        LD      HL,#5800
        LD      (HL),%00101111
        LD      DE,#5801
        LD      BC,#2FF
        LDIR

;������� �������� �������
;(#640 ���� � ������ BUF):

        LD      HL,BUF
        LD      (HL),0
        LD      DE,BUF+1
        LD      BC,#63F
        LDIR

;��������� ���������� ������� ������
;�������� ������� ���� � ��������,
;�.�. ����� ��� �� ������� �� ���������:

M2      LD      HL,BUF+32
        LD      DE,BUF+#300+32
        LD      BC,32
        LDIR
        LD      HL,BUF+#300
        LD      DE,BUF
        LD      BC,32
        LDIR

;� ����� ��������� �������� � ������:

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

;�������� ���� �����:

        XOR     A
        IN      A,(254)
        CPL
        AND     31
        JR      Z,M2
        RET

;--------------------------------------
;��������� TO_SCR �������� �������
;����������.
;
;����: A  - �������� �� ������,
;           ������������ ��� ���������
;      IX - ������� ����� � ������

TO_SCR  AND     %00111000
        RRCA
        LD      L,A
        LD      H,0
        LD      DE,TAB-4
        ADD     HL,DE
        LD      B,H
        LD      C,L

;BC - ����� ���������

        PUSH    IX
        POP     HL
        LD      DE,#320
        ADD     HL,DE

;HL - ����� �� ��������������� ������,
;     ��� �������� ������� ��������
;     ��������� ��� ����� ����������

        CP      (HL)  ;�������� �������?
        RET     Z     ;���� �� - �������

        PUSH    AF
        LD      (HL),A
        LD      DE,BUF-#340
        ADD     HL,DE

;HL - �������� � �������� ������, ������
;     �� ���� ���������� ����������:

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

;HL - ����� �� ������

        POP     AF       ;���� A=0,
        AND     A        ;������ �������
        JP      Z,TO_CL  ;����������

        LD      D,H
        LD      E,L
        INC     D
        INC     D
        INC     D
        INC     D

;HL ��������� �� ������� ����� ����������,
;� DE - �� ������ ����� ����

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

;���� ����� ������ �������� ����������:

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

;�������, ������������ ��������� ����
;���������:

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