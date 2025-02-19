pushpc
    org $BBC731
        jml save_game
    org $80AC1C
        jml init_game
    org $80AC18
        jml load_game
    org $80AB96
        jsl erase_game
        nop #2
pullpc

load_game:
        ldx #$0000
    .loop
        lda !extended_save_data,x
        sta !ram,x
        inx #2
        cpx #$0080
        bcc .loop
        lda.w #$DEAD
        sta !init_flag
        jml $808F04


save_game:
        lda $60
        sta [$26],y
        phy 
        phx 
        ldx #$0000
    .loop
        lda !ram,x
        sta !extended_save_data,x
        inx #2
        cpx #$0080
        bcc .loop
        plx 
        ply 
        rtl 

erase_game:
        tsb $0613
        phx 
        ldx #$01FE
        lda #$FFFF
    .loop
        sta.l !ram,x
        dex #2
        bpl .loop
        plx 
        lda $0611
        rtl 

init_game:
        ldx #$01FE
        lda #$0000
    .loop
        sta.l !ram,x
        dex #2
        bpl .loop
        lda.w #$DEAD
        sta !init_flag
        
        php
        sep #$20
        lda.l setting_starting_carry
        sta !enable_carry
        lda.l setting_starting_climb
        sta !enable_climb
        lda.l setting_starting_cartwheel
        sta !enable_cartwheel
        lda.l setting_starting_swim
        sta !enable_swim
        lda.l setting_starting_team_attack
        sta !enable_team_attack
        lda.l setting_starting_helicopter_spin
        sta !enable_helicopter_spin
        lda.l setting_starting_rambi
        sta !enable_rambi
        lda.l setting_starting_squawks
        sta !enable_squawks
        lda.l setting_starting_enguarde
        sta !enable_enguarde
        lda.l setting_starting_squitter
        sta !enable_squitter
        lda.l setting_starting_rattly
        sta !enable_rattly
        lda.l setting_starting_clapper
        sta !enable_clapper
        lda.l setting_starting_glimmer
        sta !enable_glimmer
        lda.l setting_starting_skull_kart
        sta !enable_skull_kart
        lda.l setting_starting_barrel_kannons
        sta !enable_barrels
        lda.l setting_starting_barrel_exclamation
        sta !enable_invincible_barrel
        lda.l setting_starting_barrel_kong
        sta !enable_kong_barrels
        lda.l setting_starting_barrel_warp
        sta !enable_warp_barrel
        lda.l setting_starting_barrel_control
        sta !enable_controllable_barrels

        lda #$01
        sta !enable_gangplank_galleon
        
        plp 
        jml $8097CD