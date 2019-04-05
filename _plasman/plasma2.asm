    device zxspectrum128

;--------------------------;
; (c) ���� �����, 1997     ;
; ������ "PLASMA-3"        ;
;--------------------------;

BUF     EQU #8000    ;����� ������������
                     ;������ ������ #410
                     ;������ (��.����
                     ;������ = 0!)
B_SCR   EQU BUF+#20  ;����� ������
                     ;����������� ������
                     ;� ������
B_UP    EQU BUF      ;������� ������
B_DOWN  EQU BUF+#320 ;������ ������

        org #6000

SSAVER  LD      HL,(RND+1)
NEW_RND LD      A,(HL)
        INC     HL
        AND     7
        CP      6
        JR      NC,NEW_RND

        AND     A
        RLCA
        RLCA
        LD      HL,TABL1
        LD      D,0
        LD      E,A
        ADD     HL,DE
        LD      DE,BUF+#400
        LD      BC,4
        LDIR

        LD      HL,TABL2
        LD      BC,12
        LDIR

;� H' ������� ������� ���� ������
;�������:

        LD      H,D
        EXX

;��������� ���������� ������� ������
;�������� ������� ���� � ��������,
;�.�. ����� ��� �� ������� �� ���������:

M2      LD      HL,B_SCR
        LD      DE,B_DOWN
        LD      BC,32
        LDIR

        LD      HL,B_SCR+#2E0
        LD      DE,B_UP
        LD      BC,32
        LDIR

;� ����� ��������� �������� � ������:

        LD      IX,B_SCR
M1      LD      A,(IX-32)
        ADD     A,(IX-1)
        ADD     A,(IX+1)
        ADD     A,(IX+32)
        SRL     A
        SRL     A
        LD      (IX),A

;--------------------------------------
;�� �������� ����� �� ������ ����������
;��� ���� � ������� �� �����:

        EXX
        RRCA
        RRCA
        AND     15
        LD      L,A
        LD      A,(HL)
        EXX

        PUSH    IX
        POP     HL
        LD      DE,#5800-B_SCR
        ADD     HL,DE
        EX      AF,AF'      ;!
        LD      A,(IX-1)    ;!
        CP      (IX)        ;!
        JR      C,TO_SCR1   ;!
        CP      16          ;!
        JR      C,TO_SCR1   ;!
        DEC     HL          ;!
        LD      A,(HL)      ;!
        INC     HL          ;!
        LD      (HL),A      ;!
        JR      NO_CP       ;!

TO_SCR1 EX      AF,AF'      ;!
        LD      (HL),A
;--------------------------------------

NO_CP   INC     IX
        LD      DE,1-#5800+B_SCR-B_DOWN
        ADD     HL,DE
        LD      A,H
        OR      L
        JR      NZ,M1

;�������� ���� �����, ������ ���������
;����� ������ ��������� ���������
;��������:

        LD      B,5
L23     PUSH    BC
        CALL    RND
        POP     BC
        DJNZ    L23

;�� ���������� ���-�� ������?

    jr M2
        LD      A,(23560)
        AND     A
        JR      Z,M2
        RET

;=================================
;��������� RND �������� ���������
;������� ����. ��������� ����� �
;������ ������ (BUF..BUF+#400)

RND     LD      HL,0
        LD      A,H
        AND     #3F
        LD      H,A
        LD      D,(HL)
        INC     HL
        LD      E,(HL)
        INC     HL
        LD      A,(HL)
        XOR     D
        XOR     E
        SUB     16
        LD      B,A
        LD      A,D
        AND     3
        LD      D,A
        LD      E,B
        LD      (RND+1),HL
        LD      HL,BUF
        ADD     HL,DE
        LD      A,B
        AND     %01111111
        LD      (HL),A
        DEC     HL
        LD      (HL),A
        DEC     HL
        LD      (HL),A
        RET

;�������:

TABL1   DB      %00001001
        DB      %01001001
        DB      %00011011
        DB      %01011011

        DB      %00001001
        DB      %01001001
        DB      %00101101
        DB      %01101101

        DB      %00010010
        DB      %01010010
        DB      %00011011
        DB      %01011011

        DB      %00010010
        DB      %01010010
        DB      %00110110
        DB      %01110110

        DB      %00100100
        DB      %01100100
        DB      %00101101
        DB      %01101101

        DB      %00100100
        DB      %01100100
        DB      %00110110
        DB      %01110110

TABL2   DB      %00111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111
        DB      %01111111

end
    savesna "/Users/lovebeam/speccy/_tools/unreal/qsave1.sna", start
    display end-#6000
