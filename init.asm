pushpc
    org $8090E8
        jsl init_ram
        nop 
pullpc

init_ram:
        php 
        rep #$30
        lda !init_flag
        cmp #$DEAD
        bne .init
        jmp .initialized
    .init
        ldx #$01FE
        lda #$0000
    .loop
        sta.l !ram,x
        dex #2
        bpl .loop
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
        rep #$20

    .initialized
        lda.w #$DEAD
        sta !init_flag

        plp 
        stz $2A
        lda #$AA55
        rtl
