$BEFB:78

NEW
  
AUTO 4,1
			.LIST OFF
            .OP	65C02
*--------------------------------------
            .INB /DEV/LOAD.DHGR/MEM.S
            .INB /DEV/LOAD.DHGR/MLI.S
			.INB /DEV/LOAD.DHGR/DHGR.INIT.S
			.INB /DEV/LOAD.DHGR/DHGR.CLR.S
*--------------------------------------
REF         .HS 00              ; ProDOS reference number
OBJMEMLOC   .EQ $0800
DATAMEMLOC  .EQ $8000
MLIPARAMS   .HS 00              ;number-of-parameters   0853
            .HS 00,00           ;pointer to pathname
            .HS C3              ;Normal file access permitted
            .HS 04              ;Make it a text file
            .HS 00,00           ;AUX_TYPE, not used
            .HS 01              ;Standard file
            .HS 00,00           ;Creation date (unused)
            .HS 00,00           ;Creation time (unused)
COLCNT      .EQ $09
READBUFF1   .EQ $2000
READBUFF2   .EQ $4000
*--------------------------------------
WAITVBL     BIT VBL
            BPL WAITVBL
.10         BIT VBL
            BMI .10
            RTS

SLEEP       LDA #$20
.11         JSR WAITVBL
            DEC
            BNE .11
            RTS

LOOP        STA PAGE2_ON ;Show PAGE 2
            JSR SLEEP
            STA PAGE2_OFF ;Show PAGE 1
            JSR SLEEP
            JMP LOOP
*--------------------------------------
LOAD_PAGE1
            JSR OPEN
            .HS 16
            .AS "/DEV/IMG/MONSTRE1.A2FC"
            >SET_RW_PARAMS READBUFF1,#$00,#$20
            JSR RD_TO_AUX
            >SET_RW_PARAMS READBUFF1,#$00,#$20
            JSR RD_TO_MAIN
            JSR CLOSE
            RTS

LOAD_PAGE2
            STA PAGE2_ON ;Show PAGE 2
            JSR OPEN
            .HS 16
            .AS "/DEV/IMG/MONSTRE2.A2FC"
*            >SET_RW_PARAMS READBUFF2,#$00,#$20
*            JSR RD_TO_AUX
            >SET_RW_PARAMS READBUFF2,#$00,#$20
            JSR RD_TO_MAIN
            JSR CLOSE

            STA PAGE2_ON ;Show PAGE 2
            RTS
*--------------------------------------
RUN
            >GODHGR2
            LDA #$00
            JSR DHGR2_CLR
            JSR LOAD_PAGE1
*            JMP LOOP
            BRK
*--------------------------------------
MAN
SAVE /DEV/LOAD.DHGR/TEST.S


ASM
