    device zxspectrum128

    org #6000
    ei

    call on
    jr $

on
       LD   HL,BUFF
        PUSH HL
        LD   B,#FA
        LD   C,1
        LD   HL,#4000
        LD   DE,#1D
        PUSH DE
        EXX
        POP  DE
        POP  HL
        EXX
L2      EXX
        LD   A,(HL)
        ADD  HL,DE
        EXX
        AND  C
        RLC  C
        OR   (HL)
        LD   (HL),A
        ADD  HL,DE
        LD   A,H
        CP   #58
        JR   C,L2
        SUB  #18
        LD   H,A
        EXX
        LD   A,H
        SUB  #18
        LD   H,A
        EXX
        RLC  C
        DJNZ L2
        RET



	org #8000
BUFF      incbin "pic.C"

end
    savesna "..\..\unreal\qsave1.sna",#6000
    labelslist "..\..\unreal\user.l"
    display end-#6000