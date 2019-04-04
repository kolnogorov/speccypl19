spr_to_pics
	ld ix,filename

	ld hl,spr, a,1
2	push af
	ld de,#5031,bc,#2805
1	push bc,de
	ld b,0:ldir
	pop de: call down_d
	pop bc: djnz 1b

	push hl

	push ix: pop hl
	ld de,#5cdd, bc,9: ldir
	push hl
	ld hl,#4000, de,#1b00, c,#0b
	call #3d13
	pop ix

	pop hl,af: inc a: cp 91: jp c,2b
	ret

filename
	db "1       C"
	db "2       C"
	db "3       C"
	db "4       C"
	db "5       C"
	db "6       C"
	db "7       C"
	db "8       C"
	db "9       C"
	db "10      C"
	db "11      C"
	db "12      C"
	db "13      C"
	db "14      C"
	db "15      C"
	db "16      C"
	db "17      C"
	db "18      C"
	db "19      C"
	db "20      C"
	db "21      C"
	db "22      C"
	db "23      C"
	db "24      C"
	db "25      C"
	db "26      C"
	db "27      C"
	db "28      C"
	db "29      C"
	db "30      C"
	db "31      C"
	db "32      C"
	db "33      C"
	db "34      C"
	db "35      C"
	db "36      C"
	db "37      C"
	db "38      C"
	db "39      C"
	db "40      C"
	db "41      C"
	db "42      C"
	db "43      C"
	db "44      C"
	db "45      C"
	db "46      C"
	db "47      C"
	db "48      C"
	db "49      C"
	db "50      C"
	db "51      C"
	db "52      C"
	db "53      C"
	db "54      C"
	db "55      C"
	db "56      C"
	db "57      C"
	db "58      C"
	db "59      C"
	db "60      C"
	db "61      C"
	db "62      C"
	db "63      C"
	db "64      C"
	db "65      C"
	db "66      C"
	db "67      C"
	db "68      C"
	db "69      C"
	db "70      C"
	db "71      C"
	db "72      C"
	db "73      C"
	db "74      C"
	db "75      C"
	db "76      C"
	db "77      C"
	db "78      C"
	db "79      C"
	db "80      C"
	db "81      C"
	db "82      C"
	db "83      C"
	db "84      C"
	db "85      C"
	db "86      C"
	db "87      C"
	db "88      C"
	db "89      C"
	db "90      C"

	org #b000
spr	inctrd "empty.trd", "earth_s.C"
