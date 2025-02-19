pushpc
    org $80AAC5
        ; skip switching languages
        nop #3
    org $BEEFAA
        ; nuke the kremkoin cheat
        nop #3
pullpc 

pushpc
    org $B4CB9F
        dw $0000
    ; $B39368: npc_hud_coin_main
    ; BEB850: coins_main
pullpc

pushpc
    org $B39368
        jsl replace_hud_coin

    org $BEB850
        ;#$01c3
pullpc

replace_hud_coin:
        lda #$0001
        sta !at_kong_menu
        ldx $64
        lda $0689
        and #$00FF
        beq .museum
        cmp #$0006
        beq .kollege
        jml $B9D100

    .kollege
        lda $36,x
        cmp #$01C2
        beq +
        lda #$0000
        sta $38,x
    +   
        lda #$01C2
        sta $36,x
        jml $B9D100
        
    .museum
        lda $36,x
        cmp #$01C3
        beq +
        lda #$0000
        sta $38,x
    +   
        lda #$01C3
        sta $36,x
        jml $B9D100
        
pushpc
    org $B4A1D7
        jml change_currency_read
    org $B49D5E
        jml change_currency_save
pullpc

change_currency_read:
        lda !kremkoins
        cpy #$0006
        beq +
        lda !dk_coins
        cpy #$0000
        beq +
        lda !banana_coins
    +   
        jml $B4A1E2

change_currency_save:
        cmp #$0006
        beq .kremkoins
        cmp #$0000
        beq .dk_coins
        sty !banana_coins
    .return
        jml $B49D6B
    .dk_coins
        sty !dk_coins
        bra .return
    .kremkoins
        sty !kremkoins
        bra .return

pushpc
    org $B49DAF
        jml free_saves
pullpc

free_saves:
        cpx #$08E0
        bcc .has_cost
        cpx #$08E7
        bcs .has_cost
    .check_cost
        lda $0654
        cmp #$01
        beq .no_cost
    .has_cost
        lda $00,x
        ora $0666
        sta $00,x
    .no_cost
        jml $B49DB6


pushpc
    ;# Remaps trivia pointers to another area
    org $B4C56D
        dw $F800
        dw $F850
        dw $F8A0
        
        dw $F900
        dw $F950
        dw $F9A0
        
        dw $FA00
        dw $FA50
        dw $FAA0
        
        dw $FB00
        dw $FB50
        dw $FBA0
        
        dw $FC00
        dw $FC50
        dw $FCA0
        
        dw $FD00
        dw $FD50
        dw $FDA0
pullpc