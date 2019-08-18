NEW
  
AUTO 4,1
            .LIST OFF
            .OP	65C02
*--------------------------------------
MLIADDR     .EQ $BF00
IOBUFF      .EQ $1000
*--------------------------------------
MLI         JSR MLIADDR         ; call ProDOS
            .BS 1               ; command number
            .DA #MLIPARAMS,/MLIPARAMS
            RTS
*--------------------------------------
            .MA MLI_CALL
            LDA ]1              ; open command
            STA MLI+3
            CLC
            JSR MLI
            BCC :1
            LDX #$EE
			LDY ]1
            BRK
:1          
            .EM
*--------------------------------------
            .MA GET_FILENAME
            PLA
            INC                 ; low byte of name address
            STA ]1+1
            STA PTR
            PLA                 ; high byte of name address
            STA ]1+2
            STA PTR+1

            LDA (PTR)
            CLC
            ADC PTR
            STA PTR
            BCC :1
            LDA #$00
            ADC PTR+1
            STA PTR+1

:1          LDA PTR+1
            PHA
            LDA PTR
            PHA
            .EM
*--------------------------------------
            .MA SET_RW_PARAMS
            LDA #]1        
            STA MLIPARAMS+2     ; pointer to data LOW
            LDA /]1
            STA MLIPARAMS+3     ; pointer to data HIGH
            LDA ]2              
            STA MLIPARAMS+4     ; number of bytes to write LOW
            LDA ]3
            STA MLIPARAMS+5     ; number of bytes to write HIGH
            .EM
*--------------------------------------
CREATE      LDA #$07            ; setup for 'create'
            STA MLIPARAMS
            >GET_FILENAME MLIPARAMS
            >MLI_CALL #$C0      ; create command
            RTS
*--------------------------------------
OPEN        LDA #$03
            STA MLIPARAMS       ; adjust number of parameters

            >GET_FILENAME MLIPARAMS

            LDA #IOBUFF
            STA MLIPARAMS+3
            LDA /IOBUFF
            STA MLIPARAMS+4     ; use file 0
            >MLI_CALL #$C8      ; open command
            LDA MLIPARAMS+5     ; get reference number returned by open
            STA REF             ; and save
            RTS
*--------------------------------------
CLOSE       LDA #$01           
            STA MLIPARAMS
            LDA REF             ; put in reference number
            STA MLIPARAMS+1
            >MLI_CALL #$CC      ; close command
            RTS                 ; and end
*--------------------------------------
WRITE       LDA #$04
            STA MLIPARAMS       ; Params count
            LDA REF             ; get reference number returned by open
            STA MLIPARAMS+1     ; and put in for write
            >MLI_CALL #$CB      ; write command
            RTS
*--------------------------------------
RD_TO_MAIN  LDA #$04
            STA MLIPARAMS       ; Params count
            LDA REF             ; get reference number returned by open
            STA MLIPARAMS+1     ; and put in for read
            >WRT_MAIN
            >MLI_CALL #$CA      ; read command
            RTS
*--------------------------------------
RD_TO_AUX   LDA #$04
            STA MLIPARAMS
            LDA REF             ; get reference number returned by open
            STA MLIPARAMS+1     ; and put in for read
            >WRT_AUX
            >MLI_CALL #$CA      ; read command
            RTS
*--------------------------------------
MAN
SAVE /DEV/LOAD.DHGR/MLI.S
LOAD /DEV/LOAD.DHGR/TEST.S

ASM
