NEW
    
AUTO 4,1
            .OP	65C02
            .LIST OFF
*--------------------------------------	
A1L			.EQ $3C
A1H			.EQ $3D
A2L			.EQ $3E
A2H			.EQ $3F
A4L			.EQ $42
A4H			.EQ $43
AUXMOVE		.EQ $C311
XFER		.EQ $C314
ALTZPON		.EQ $C009
ALTZPOFF	.EQ $C008
ALTZP		.EQ $C016
RAMRD		.EQ $C013
SETOVERFLW	.EQ $FF58

STORE80_OFF	.EQ $C000
STORE80_ON	.EQ $C001
RAMRD_OFF	.EQ $C002
RAMRD_ON	.EQ $C003
RAMWRT_OFF	.EQ $C004
RAMWRT_ON	.EQ $C005
COL80_OFF	.EQ $C00C
COL80_ON	.EQ $C00D
VBL			.EQ	$C019
*--------------------------------------
			.MA WRT_P1
			STA STORE80_OFF
			STA RAMRD_OFF
			STA RAMWRT_OFF
			.EM
*--------------------------------------
			.MA WRT_P1X
			STA STORE80_ON
			STA PAGE2_ON
			STA RAMRD_OFF
			STA RAMWRT_OFF
			.EM
*--------------------------------------
			.MA RELOC2AUX		; P1: Adresse debut, P2: Adresse fin
			LDA #]1
			STA A1L
			STA A4L
			LDA /]1
			STA A1H
			STA A4H
			LDA #]2
			STA A2L
			LDA /]2
			STA A2H
			SEC
			JSR AUXMOVE
			.EM
*--------------------------------------
			.MA GOAUX
			STA A1L
			LDA #]1
			STA $03ED
			LDA /]1
			STA $03EE
			LDA A1L
			SEC					; Set Carry / MAIN -> AUX
			CLV
			JSR XFER
			.EM
*--------------------------------------
			.MA RETURN
			STA A1L
			LDA RAMRD
			BMI :1				; Branch if we are in AUX
			LDA A1L
			RTS
:1                              ; Return to MAIN !
			PLA
			STA $03ED
			PLA
			STA $03EE
			LDA A1L
			CLC					; Clear Carry / AUX -> MAIN
			CLV
			JMP XFER
			.EM
*--------------------------------------
MAN
SAVE /DEV/LOAD.DHGR/MEM.S
LOAD /DEV/LOAD.DHGR/TEST.S

ASM
