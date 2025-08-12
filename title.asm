pushpc
    org $80B5E8
        jsl title_screen_expanded_setup
    org $80B516
        jsl draw_intro_text
        nop #2
    org $B3FC00
        title_screen_expanded_setup:
                jsl $80895F
                lda #$0800
                sta $2116
                ldx #$00FC
                lda #$0660
                ldy #$0E40
                jsl $80895F
                rtl 
        draw_intro_text:
                lda #$C64C
                pha 
                ldy $70
                ldx #$0000
            .loop
                lda $01,s
                sta $0000,y
                clc 
                adc #$0800
                sta $0004,y
                lda $01,s
                clc 
                adc #$0008
                sta $01,s
                lda.l .text_data_tile,x
                sta $0002,y
                inc 
                sta $0006,y
                tya 
                clc 
                adc #$0008
                tay 
                inx #2
                cpx.w #.text_data_tile_end-.text_data_tile
                bcc .loop
                tya 
                sta $70
                pla 
                lda $0512
                cmp #$000F
                rtl 

            !_text_num_0 = $0086
            !_text_num_1 = $008E
            !_text_num_2 = $0096
            !_text_num_3 = $009E
            !_text_num_4 = $00A6
            !_text_num_5 = $00AE
            !_text_num_6 = $00B6
            !_text_num_7 = $00BE
            !_text_num_8 = $00C6
            !_text_num_9 = $00CE
            
            .text_data_tile
                ;dw $0098,$0082,$0090,$0096,$00F2
                dw $0080,$00AA,$00F2
                dw $008C,!_text_num_3,$00BC,!_text_num_0,$00BC,!_text_num_0
            ..end




    org $FD27AE
	db $00, $7C, $FF, $03, $66, $04, $34, $11
	db $9D, $0D, $1A, $32, $DF, $46, $BF, $5B
	db $F9, $30, $BF, $51, $CC, $04, $E0, $02
	db $97, $04, $BF, $0C, $EF, $3D, $FF, $7F
pullpc
