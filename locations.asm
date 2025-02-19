
pushpc
    org $B3C44F
        jsl balloon_locations
    org $B39D82
        jsl chest_copy_index
        nop
    org $B88C00
        jsl transformed_animals_items
        nop 
    org $B3D0F1
        jsl kloak_item_fix
pullpc

balloon_locations:
        jsl $BEC64C
        lda !at_kong_menu
        bne .skip
        lda $0AF0
        cmp #$A000  ; finishing a level
        beq .skip
        phx 
        lda $56,x
        bne +
        lda $5C,x
    +   
        tax
        sep #$20
        lda.l !collectible_flags,x
        ora #$01
        sta.l !collectible_flags,x
        rep #$20
        ;lda $D3
        ;wdm 
        rep #$20
        plx 
    .skip
        rtl 

chest_copy_index:
        lda #$0022
        sta $58,x
        lda $0056,y
        sta $5C,x
        rtl 

transformed_animals_items:
        ldx $68
        stz $5C,x
        lda $0A86
        rtl 

kloak_item_fix:
        ldy $64
        ldx $68
        lda $0056,y
        sta $5C,x
        rtl 

;#######################################################
;# Disables coins giving coins

pushpc
    org $BEB8B2
        jsl handle_coins
        nop
pullpc

handle_coins:
        cpy #$08CE      ; skips dk coins
        beq .skip
        cpy #$08CC      ; skips kremkoins
        beq .skip_kremkoins
        sta $0000,y
        lda $0AF0
        cmp #$A000  ; finishing a level
        beq .skip
        phx 
        lda $56,x
        bne +
        lda $5C,x
    +   
        tax
        sep #$20
        lda.l !collectible_flags,x
        ora #$02
        sta.l !collectible_flags,x
        rep #$20
        ;lda $D3
        ;wdm 
        plx
    .skip
        sep #$20
        rtl 

    .skip_kremkoins
        lda #$0001
        sta !teleporting
        bra .skip

pushpc
    org $B3C3AC
        jsl multiple_bananas_energy_link
        nop 
    org $B5F8AF
        jsl single_banana_energy_link
pullpc

multiple_bananas_energy_link:
        phx 
        lda !energy_link_extractinator
        and #$0003
        asl 
        tax 
        lda.l .values,x
        plx 
        clc 
        adc !energy_link_transfer
        sta !energy_link_transfer
        lda $0AF0
        cmp #$A000  ; finishing a level
        beq .skip
        phx 
        lda $56,x
        bne +
        lda $5C,x
    +   
        tax
        sep #$20
        lda.l !collectible_flags,x
        ora #$04
        sta.l !collectible_flags,x
        rep #$20
        ;lda $D3
        ;wdm 
        plx 
    .skip
        lda #$0001
        sta $2E,x
        rtl 

    .values
        dw $00A0
        dw $00B8
        dw $00D0
        dw $00F0


single_banana_energy_link:
        php 
        phx 
        lda !energy_link_extractinator
        and #$0003
        asl 
        tax 
        lda.l .values,x
        plx 
        clc 
        adc !energy_link_transfer
        sta !energy_link_transfer
        plp 
        lda.l $7FD734
        rtl 

    .values
        dw $0010
        dw $0012
        dw $0015
        dw $0018