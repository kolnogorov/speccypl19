fade
	ld a,#11: call set_bnk_save
	ld de,Ch_scr
	call fade_fx
	call set_bnk_restore
	ret
