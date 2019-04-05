ADR	equ #c000

delc
        LD DE,7;SKIP "LCMP5" & LENGTH
        ADD HL,DE

        LD A,(HL)
        INC HL
        LD E,A
        ADD HL,DE

        LD A,(HL)
        LD E,A;?AC?UA

        AND 3
        RLCA
        RLCA
        RLCA
        OR ADR/256

        EXX
        LD D,A;IA?AEI
        LD E,0
        EXX

        LD A,(HL)
        INC HL
        XOR ADR/256+#18
        AND #FC
        LD HX,A;EIIAO ?. ECI.

DLC1    LD A,(HL)
        INC HL
        LD LX,#FF
DLC2
        EXX
        JR NZ,DLC10
        LD B,1

DLC3    EXA
        SLA D
        JR NZ,$+6
        LD D,(HL)
        INC HL
        SLI D

        DJNZ DLC7

        JR C,DLC1

        INC B
;-----------
DLC4    LD C,%01010110
        LD A,#FE
DLC5    SLA D
        JR NZ,$+6
        LD D,(HL)
        INC HL
        RL D
        RLA
        SLA C
        JR Z,DLC6
        JR C,DLC5
        RRCA
        JR NC,DLC5
        SUB 8
DLC6    ADD A,9
;---------
        DJNZ DLC3

        CP 0-8+1
        JR NZ,$+4
        LD A,(HL)
        INC HL

        ADC A,#FF
        LD LX,A
        JR C,DLC4
        LD HL,#2758
        EXX
        RET
;-------------
DLC7    LD A,(HL)
        INC HL

        EXX
        LD L,A
        EXA
        LD H,A
        ADD HL,DE

        CP #FF-2
        JR NC,DLC8
        DEC LX
DLC8
        LD A,H
        CP HX
        JR NC,DLC13
        XOR L
        AND #F8
        XOR L
        LD B,A
        XOR L
        XOR H
        RLCA
        RLCA
        LD C,A

DLC9    EXA
        LD A,(BC)
DLC10   EXA
        LD A,D
        CP HX
        JR NC,DLC14
        XOR E
        AND #F8
        XOR E
        LD B,A
        XOR E
        XOR D
        RLCA
        RLCA
        LD C,A

DLC11   EXA
        LD (BC),A

        INC DE
        JR NC,$+4
        DEC HL
        DEC HL
        INC HL
        EXA
        INC LX
        JR NZ,DLC8
        JR DLC2

DLC13   SCF
DLC14   PUSH AF
        EXX
        ADD A,E
        EXX
        LD B,A
        POP AF
        LD C,E
        JR NC,DLC11
        LD C,L
        JR DLC9