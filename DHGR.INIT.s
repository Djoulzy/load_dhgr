NEW
    
AUTO 4,1
            .OP	65C02
            .LIST OFF
*--------------------------------------
STROBE		.EQ $C010

GRAPHON		.EQ $C050
FULLON		.EQ $C052
MIXED		.EQ $C053
PAGE2_OFF	.EQ $C054
PAGE2_ON	.EQ $C055
MAIN_MEM	.EQ $C054
AUX_MEM		.EQ $C055
HIRESOFF	.EQ $C056
HIRESON		.EQ $C057
DHGR_ON		.EQ $C05E

IS_PAGE2	.EQ	$C01C

SCRN_LO		.EQ $1D				;Zero page location for low byte of our screen row
SCRN_HI		.EQ $1E				;Zero page location for high byte of our screen row
SCRN_HI2	.EQ $1F				;Zero page location for high byte of our screen row (page2)
ORMAIN		.EQ $FA
ORAUX		.EQ $FC

CPTX        .EQ $06
CPTY        .EQ $08
XPOS		.EQ $09
PTR         .EQ $46

*--------------------------------------
			.MA	GODHGR2
			STA GRAPHON			;Turn on GRAPHICS
			STA HIRESON			;Turn on Hi-res
			STA FULLON			;Turn on Full screen
			STA DHGR_ON			;Turn on DHR
			STA COL80_ON		;Turn on 80 Columns
			.EM
*--------------------------------------
			.MA SWITCH_PAGE
			LDA IS_PAGE2
			BMI :1
			STA PAGE2_ON	; On passe sur affichage Page 2
			LDA #$00		; Ecriture Page 1
			STA $E6
			JMP :2
:1			STA PAGE2_OFF	; Affichage Page 1
			LDA #$20		; Ecriture Page 2
			STA $E6
:2
			.EM
*--------------------------------------
			.MA WAITVBL
:1			BIT VBL
            BPL :1
:2			BIT VBL
            BMI :2
            .EM
*--------------------------------------
			.MA SLEEP
			LDA #$60
:1			>WAITVBL
            DEC
            BNE :1
            .EM
*--------------------------------------
MAN
SAVE /DEV/LOAD.DHGR/DHGR.INIT.S
LOAD /DEV/LOAD.DHGR/TEST.S

ASM
