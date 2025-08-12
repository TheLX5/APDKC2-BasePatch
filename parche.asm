hirom

incsrc "defs.asm"

pushpc
    ;# Allow exiting levels at any time
    org $BB8265
        db $80
   
    ;# Remove antipiracy bs
    ;org $B5B9F1
    ;    nop #4

    ;# Expands SRAM to 16KiB
    org $00FFD8
        db $04
pullpc

macro jslrts(routine, rtl)
        phk
        pea.w ?jslrtsreturn-1
        pea.w <rtl>-1
        jml <routine>
    ?jslrtsreturn:
endmacro

org $FDDC00
    ;incsrc "init.asm"
    incsrc "save.asm"
    incsrc "abilities.asm"
    incsrc "menus.asm"
    incsrc "map.asm"
    incsrc "level.asm"
    incsrc "hints.asm"
    incsrc "locations.asm"
    incsrc "credits.asm"
    incsrc "title.asm"
    print "$", hex(pc()), "/$FDFF7F"
    assert pc() <= $FDFF00

if !debug == 1
    org $FDFF80
        setting_starting_kong:
            db $01
        setting_goal:
            db $00
        setting_lost_world_rocks:
            db $05
        setting_starting_carry:
            db $00
        setting_starting_climb:
            db $00
        setting_starting_cling:
            db $00
        setting_starting_cartwheel:
            db $00
        setting_starting_swim:
            db $00
        setting_starting_team_attack:
            db $00
        setting_starting_helicopter_spin:
            db $00
        setting_starting_rambi:
            db $00
        setting_starting_squawks:
            db $00
        setting_starting_enguarde:
            db $00
        setting_starting_squitter:
            db $00
        setting_starting_rattly:
            db $00
        setting_starting_clapper:
            db $00
        setting_starting_glimmer:
            db $00
        setting_starting_skull_kart:
            db $00
        setting_starting_barrel_kannons:
            db $00
        setting_starting_barrel_exclamation:
            db $00
        setting_starting_barrel_kong:
            db $00
        setting_starting_barrel_warp:
            db $00
        setting_starting_barrel_control:
            db $00
        setting_krock_boss_tokens:
            db $05
    org $FDFF00
        required_galleon_levels:
            dw $0001
        required_cauldron_levels:
            dw $0001
        required_quay_levels:
            dw $0001
        required_kremland_levels:
            dw $0001
        required_gulch_levels:
            dw $0001
        required_keep_levels:
            dw $0001
        required_krock_levels:
            dw $0001
        galleon_levels:
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
        cauldron_levels:
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
        quay_levels:
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
        kremland_levels:
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
        gulch_levels:
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
        keep_levels:
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
            dw $0000
        krock_levels:
            dw $0000
            dw $0000
        print pc
endif
