Ch_x    EQU 32
Ch_y    EQU 24// размеры окна (в чанках)
Ch_xsiz	equ 32
Ch_ysiz	equ 24

c2p_draw
C2prend ;генерация кода выкидки
	LD (C2prenE+1),SP
	LD SP,Out_cd+(Ch_y*Ch_x/2)*3+8*2-1
	LD H,high Pix_tb
	LD BC,Ch_scr
	LD IY,C2pren2
C2pren1 LD HX,8,LX,C:JP C2p_pcd
C2pren2
	LD IX,-8:ADD IX,SP:LD SP,IX
	LD A,B:CP high Ch_scr+Ch_y:JP NZ,C2pren1


C2prenE LD SP,0;:RET


C2p_out ;сама выкидка
	LD (C2poutE+1),SP
;вывод пикселов
	LD SP,#D200
	LD A,#00,BC,#4455,DE,#7577
	LD IY,C2pout1:JP Out_cd
C2pout1 LD SP,#D400
	LD A,#00,BC,#1011,DE,#55DD
	LD IY,C2pout2:JP Out_cd
C2pout2 LD SP,#D600
	LD A,#00,BC,#4454,DE,#5577
	LD IY,C2pout3:JP Out_cd
C2pout3 LD SP,#D800
	LD A,#00,BC,#0111,DE,#55D5
	LD IY,C2pout0:JP Out_cd
C2pout0 ;вывод атрибутов
	LD SP,#DB00
	LD H,high Atr_tb
	LD BC,Ch_scr+(Ch_y-1)*256+Ch_x-1
	LD LX,C,HX,Ch_y
	LD IY,C2poutE:JP C2p_acd

C2poutE LD SP,0:RET

c2p_init
	call Chn_prp
	; call Txt_prp
	ret

Chn_prp ;подготовка c2p-рутины
;атрибуты
	LD HL,C2p_d1,DE,C2p_acd,(C2p_d3m+1),DE
	LD B,Ch_x/2,C,C2p_d2-C2p_d1:CALL Crunch
	DEC DE:LD A,#05,(C2p_d3),A
	LD HL,C2p_d3,C,C2p_d4-C2p_d3:LDIR
;пикселы
	LD HL,C2p_d2,DE,C2p_pcd,(C2p_d3m+1),DE
	LD B,Ch_x/2,C,C2p_d3-C2p_d2:CALL Crunch
	DEC DE:LD A,#04,(C2p_d3),A
	LD HL,C2p_d3,C,C2p_d4-C2p_d3:LDIR
;часть кода (push hl)
	LD HL,C2p_d4,DE,Out_cd:PUSH DE
	LD B,Ch_x/2*8
	LD C,C2p_d5-C2p_d4:CALL Crunch
	LD HL,C2p_d5,C,C2p_de-C2p_d5:LDIR
	POP HL:LD BC,((8*Ch_x/2)*3+8)*2-8:LDIR
	EX DE,HL:JP Exit_iy


C2p_d1  ;генерилка атрибутов
	LD A,(BC),L,A,D,(HL):DEC C
	LD A,(BC),L,A,E,(HL):PUSH DE:DEC C
; 55_tct on pair
C2p_d2  ;генерилка кода
	LD A,(BC),L,A,E,(HL):INC C
	LD A,(BC),L,A,D,(HL):RES 3,D:PUSH DE
	DEC SP:INC C
; 69_tct on pair
C2p_d3  ;конец цикла
; буфер по секторам
	INC B:LD C,LX:DEC HX; inc/dec
C2p_d3m JP NZ,#0000:JP (IY)
C2p_d4  NOP:NOP:PUSH HL
C2p_d5  LD IX,-7*256:ADD IX,SP:LD SP,IX
C2p_de

;буфер непрерывный
;_DEC BC:DEC HX
;C2p_d3m JP NZ,#0000:JP (IY)

Exit_iy ;служебная рутина
	LD (HL),#FD:INC HL:LD (HL),#E9:INC HL
	RET
;
De_2_hl ;служебная рутина
	LD (HL),E:INC HL:LD (HL),D:INC HL
	RET

Txt_prp ;подготовка текстуры
	LD l,#ff,DE,Ch_scr
	LD LX,#20-8
Txtprp1 PUSH DE:LD B,Txt_xsz
Txtprp2 LD a,l:and #1f
	LD (DE),A:INC DE:DJNZ Txtprp2
;
	LD BC,HL:POP HL:PUSH BC
	LD BC,#0100-Txt_xsz
	LDIR:POP HL
	dec l
	DEC LX:JR NZ,Txtprp1
;
	RET

scr_update
	ld hl,#c100, a,#88:call fill_sp
	ld hl,#c300, a,#20:call fill_sp
	ld hl,#c500, a,#88:call fill_sp
	ld hl,#c700, a,#02:call fill_sp

	ld hl,#c900, a,#88:call fill_sp
	ld hl,#cb00, a,#20:call fill_sp
	ld hl,#cd00, a,#88:call fill_sp
	ld hl,#cf00, a,#02:call fill_sp

	ld hl,#d100, a,#88:call fill_sp
	ld hl,#d300, a,#20:call fill_sp
	ld hl,#d500, a,#88:call fill_sp
	ld hl,#d700, a,#02:call fill_sp

	ret

fill_sp
	ld (fill_sp_exit+1),sp, sp,hl
	ld h,a,l,a
	.128 push hl
fill_sp_exit
	ld sp,0: ret

scrset
	ld hl,#5aff,de,#5afe,bc,#1b00
	ld (hl),c:lddr
	ld hl,#4000,(hl),#88,bc,#ff:call fill_
	ld hl,#4200,(hl),#20,bc,#ff:call fill_
	ld hl,#4400,(hl),#88,bc,#ff:call fill_
	ld hl,#4600,(hl),#02,bc,#ff:call fill_
	ld hl,#4000,de,#4800,bc,#1000:call fast_ldir
scrset1
	ld a,#17:call set_bnk
	ld hl,#4000,de,#c000,bc,#1b00:jp fast_ldir
	ret

fill_l	ld a,l
fill_a	ld (hl),a
fill_	ld de,hl:inc de

fast_ldir
	xor a: sub c:and #3f:jr z,fast_ldir1
	add a: ld ($+3+1),a: jr $
fast_ldir1 .64 ldi
 	jp pe,fast_ldir1: ret
