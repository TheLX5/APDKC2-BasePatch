pushpc
    org $B38007
        jsl main_sprite_handler
        nop 
    org $B5E50D
        jsl level_main
        nop #2
    org $B89385
        jsl set_teleport_status
    org $BB9214
        jsl clear_teleport_status
pullpc

clear_teleport_status:
        lda #$0000
        sta !teleporting
        jml $808E6A

set_teleport_status:
        ;lda #$0001
        ;sta !teleporting
        jml $B8938A

main_sprite_handler:
        jsr handle_messages
        lda $091C
        and #$0003
        ora $0919
        beq .skip
        jsl $B3E3E3
    .skip
        sep #$20
        lda $19B2
        rtl

!diddy_control = $16B2
!dixie_control = $16D8

level_main:
    .pre
        lda $0512
        and #$000F  ; screen not lit
        cmp #$000F
        bne ..return
        lda $08C2
        and #$2040  ; game paused or dead
        bne ..return
        lda $0AF0
        cmp #$A000  ; finishing a level
        beq ..return
        lda !level_id
        cmp #$00B9
        beq ..return
        lda !teleporting
        and #$00FF
        ora $0A38
        bne ..return
        lda !diddy_control+$14
        ora !dixie_control+$14
        beq ..continue
        cmp #$0041
        bcc ..barrel
    ..return
        lda $0AC3
        sta $0A9E
        rtl 
    ..barrel
        jmp .barrel
    ..continue 

    .traps
        lda $6E     ; checks for animals
        cmp #$0190
        beq ..skip
        cmp #$0194
        beq ..skip
        cmp #$0198
        beq ..skip
        cmp #$019C
        beq ..skip
        cmp #$01A0
        beq ..skip

        ldx $92
        lda.l .valid_actions,x
        and #$0001
        beq ..skip

        lda $091C
        and #$0003
        bne ..skip
        jsr handle_freeze
        jsr handle_reverse
    ..skip

    .spawn_honey
        jsr handle_honey_trap
        jsr handle_slippery_trap

    .spawn_enemies
        ldx $92
        lda.l .valid_actions,x
        and #$0010
        beq ..skip
        jsr handle_barrel_trap
    ..skip 

    .hit_and_heals
        ldx $92
        lda.l .valid_actions,x
        and #$0010
        beq .barrel_skip

        jsr handle_death_link
        bcs .barrel_skip
        jsr handle_insta_death
        bcs .barrel_skip
        jsr handle_deal_damage
        bcs .barrel_skip

    .barrel
        ldx $92
        lda.l .valid_actions,x
        and #$0030
        beq ..skip
        jsr handle_spawn_dk_barrel
    ..skip

        lda $0AC3
        sta $0A9E
        rtl 

    .valid_actions
        db $11  ; 00- Player is on the ground
        db $11  ; 01- Player has jumped
        db $20  ; 02- Lose a player?
        db $11  ; 03- Cartwheel
        db $00  ; 04- Lose a life
        db $11  ; 05- Ducking
        db $10  ; 07- Player is riding Rambi/Rattly
        db $10  ; 08- Player jumped with Rambi/Rattly
        db $10  ; 09- Holding a barrel
        db $10  ; 0A- Throwing a barrel
        db $20  ; 0C- Used in stun like states(hit by Klobber, monkey thrown in air, charging with Rambi, etc)
        db $20  ; 0D- Used in directional blast barrels
        db $21  ; 0E- In a barrel (Transformation barrel, blast barrel, cannon etc)
        db $00  ; 0F- Stacked monkeys
        db $00  ; 10- Jump with stacked monkeys
        db $00  ; 11- Throw a monkey
        db $00  ; 12- Used when starting a throw
        db $11  ; 13- Climbing on a rope
        db $11  ; 14- Holding two ropes
        db $11  ; 15- Hanging down from a rope
        db $11  ; 16- Hanging from a hook
        db $11  ; 17- Swimming in water
        db $11  ; 18- On a honey wall
        db $11  ; 19- Standing in honey
        db $10  ; 1A- Held by a purple squawks
        db $10  ; 1B- Held by a green(normal) squawks
        db $20  ; 1D- Being spun by cat `o nine tails
        db $10  ; 1E- Riding Enguarde
        db $20  ; 1F- Stunned and can't move (Such as from Klubba or K. Rool gas)
        db $10  ; 20- On a Skull cart
        db $10  ; 21- Being blown up by wind
        db $00  ; 23- Waiting for co-op player
        db $10  ; 24- Carrying an object while stuck on honey
        db $20  ; 25- Charging with Rambi
        db $20  ; 25- Charging with Enguarde

handle_reverse:
        lda $0919
        and #$0001
        bne +
        lda !enable_reverse
        beq +
        dec
        sta !enable_reverse
        lda #$0001
        sta $0919
    +   
        rts 

handle_freeze:
        lda !enable_freeze
        beq +
        dec 
        sta !enable_freeze
        ldy #$0180
        jsl $BB8443
        lda $68
        sta $64
        tax 
        phk 
        pea.w .code_B881BB-$01
        pea.w $81BA-$01
        jml $B8815F
    .code_B881BB
        lda #$0013
        sta $091F
        pei ($64)
        ldx $68
        stx $64
        jsl $BB82B8
        pla 
        sta $64
    +   
        rts 

handle_deal_damage:
        lda !enable_deal_damage
        beq +
        dec 
        sta !enable_deal_damage
        phk 
        pea.w .code_B881BB-$01
        pea.w $81BA-$01
        jml $b88ca3
    .code_B881BB
        sec 
        rts 
    +   
        clc 
        rts 

handle_death_link:
        lda !death_link_force
        beq +
        lda #$0000
        sta !death_link_force
        phk 
        pea.w .code_B881BB1-$01
        pea.w $81BA-$01
        jml $B88C9D
    .code_B881BB1
        sec 
        rts 
    +   
        clc 
        rts 

handle_insta_death:
        lda !enable_insta_death
        beq +
        dec 
        sta !enable_insta_death
        phk 
        pea.w .code_B881BB1-$01
        pea.w $81BA-$01
        jml $B88C9D
    .code_B881BB1
        sec 
        rts 
    +   
        clc 
        rts 

handle_slippery_trap:
        lda $052B
        and #$3000
        cmp #$3000
        beq +
        lda !enable_slippery_trap
        beq +
        dec 
        sta !enable_slippery_trap
        lda #$3000 ; ice
        tsb $052B
        lda #$0624
        jsl $B58003
    +   
        rts 

handle_honey_trap:
        lda !honey_trap_timer
        bne +
        lda !enable_honey_trap
        beq +
        dec 
        sta !enable_honey_trap
        lda.w #20
        sta !honey_trap_timer
        lda #$0800
        tsb $052B   ; honey
        lda #$0624
        jsl $B58003
    +   
        rts 

handle_spawn_dk_barrel:
        lda $6E
        cmp #$0190
        beq .squitter
        lda $0510
        and #$0030
        beq .return
        bra .valid
    .squitter
        lda $0510
        and #$2000
        beq .return
    .valid
        lda !enable_insta_dk_barrel
        beq .return
        lda !enable_dk_barrels
        and #$0003
        cmp #$0003
        beq .check_kong
    .check_extra_hit
        lda !extra_hit_active
        bne .return
        lda #$0001 
        sta !extra_hit_active
        lda !enable_insta_dk_barrel
        dec 
        sta !enable_insta_dk_barrel
        lda #$005A
        sta !show_hit_counter
        lda #$0538
        jsl $B58003
        rts 
    .check_kong
        lda $08C2
        and #$4000
        bne .check_extra_hit
        
        ldy #$2216
        jsl $BB8432
        ldx $0593
        ldy $68
        lda $0006,x
        sta $0006,y
        lda $000A,x
        sta $000A,y
        lda !enable_insta_dk_barrel
        dec 
        sta !enable_insta_dk_barrel
        lda #$005A
        sta !show_hit_counter
    .return
        rts 

handle_barrel_trap:
        lda !barrel_trap_timer
        beq .valid
        dec 
        sta !barrel_trap_timer
        rts 
    .valid
        lda !enable_barrel_trap
        beq .return
        ldy.w #tnt_barrel_trap
        jsl $BB8432
        ldx $0593
        ldy $68
        lda $06,x
        clc 
        adc #$0004
        sta $0006,y
        ;lda $000A,x
        lda $0AE3
        sec 
        sbc #$0010
        sta $000A,y
        lda #$0046
        sta $0030,y
        tya 
        sta $004C,y
        lda #$0000
        sta $0020,y
        lda #$0615
        jsl $B58003
        lda.w #0180
        sta !barrel_trap_timer
        lda !enable_barrel_trap
        dec 
        sta !enable_barrel_trap
    .return
        rts 

sprite_in_water:
        lda $0D4E
        bpl .has_water
    .above_water
        clc  
        rtl 
    .has_water 
        clc 
        adc #$0010
        cmp $0A,x
        bcs .above_water
        sec 
        rtl 

pushpc
    org $B3D318
        jml tnt_barrel_edit
pullpc

tnt_barrel_edit:
        ldx $64
        lda $2E,x
        cmp #$0001
        bne .not_tnt
        stz $20,x
        lda #$0640
        sta $24,x
        jsl sprite_in_water
        bcc +
        lda #$01E0
        sta $24,x
    +   
        lda $4C,x
        cmp $64
        bne .not_tnt
        jsl $B8CF7F
        ldy $0593
        lda $0A,x
        lda $000A,y
        cmp $0A,x
        bcc .enable_terrain_interaction
        jml $B3D325
    .enable_terrain_interaction
        stz $4C,x
        jml $B3D325
    .not_tnt
        jsl $B8D5E0
        jml $B3D31C

pushpc
    org $B8B668
        jml honey_edit
pullpc

honey_edit:
        lda !honey_trap_timer
        bne .sticky
    .not_sticky
        lda $10,x
        and #$0200
        jml $B8B66D
    .sticky
        dec 
        sta !honey_trap_timer
        jml $B8B66F

pushpc
    ;# Skip demo load
    org $80B550
        nop #2
pullpc

;####################################################################
;# Hurt Kong routine hook

pushpc
    org $B88CAB
        jsl hurt_routine
        nop #2
    org $B8B626
        jml hurt_routine_lava_fix
        nop 
pullpc

hurt_routine:
        %jslrts($B88092,$B88EB7)
        pha 
        
        lda #$0078
        sta !show_hit_counter

        lda $0014,y
        bne .ignore_hit

        lda !extra_hit_active
        bne .tank_hit

    .ignore
        pla 
        bit $0D54
        rtl 

    .tank_hit
        pla 
        lda #$0060
        sta $0014,y
        lda #$0070
        sta $0016,y
        ldy #$0506
        lda $0593
        cmp #$0DE2
        beq $01
        iny 
        tya 
        jsl $B58003

        lda #$0000
        sta !extra_hit_active

        ; Reset reverse trap
        stz $0919

    .ignore_hit
        phk 
        pla 
        pla
        jml $B88C9C

    .lava_fix
        phx 
        %jslrts($B88092,$B88EB7)
        lda $0014,y
        bne ..ignore
        lda $0915
        bne ..ignore
    ..process
        plx 
        jml $B8B62D
    ..ignore
        plx 
        jml $B8B62B


;####################################################################
;# Extra hit UI

pushpc
    org $80F39B
        jsl draw_on_screen
pullpc

draw_on_screen:
        jsl $BEC695
        jsr draw_hit_counter
        jsr draw_extra_hit
        rtl 

draw_extra_hit:
        lda !extra_hit_active
        beq .nope
        lda #$AE09
        jsr draw_head_icon
    .nope
        rts


draw_head_icon:
        pha 
        ldy $70
        ldx #$0000
    .loop
        lda $01,s
        clc 
        adc.l .pos_data,x
        sta $0000,y
        lda.l .tile_data,x
        sta $0002,y
        iny #4
        inx #2
        cpx #$0008
        bcc .loop
        sty $70
        pla 
        rts 

    .pos_data 
        dw $0000,$0006,$0801,$0804
    .tile_data
        dw $33C0,$33C1,$33C2,$33C3


draw_hit_counter:
        lda !show_hit_counter
        bne .show
        rts
    .show
        dec 
        sta !show_hit_counter
        lda !enable_insta_dk_barrel
        cmp.w #99
        bcc +
        lda.w #99
    +   
        jsr .hex_to_dec
        pha 
        ldy $70
        lda $01,s
        and #$000F
        clc 
        adc #$31CC
        sta $0002,y
        adc #$000A
        sta $0006,y
        lda $01,s
        and #$0F00
        xba 
        clc 
        adc #$31CC
        sta $000A,y
        adc #$000A
        sta $000E,y
        pla 

        ldx $0593
        lda $0A,x
        sec 
        sbc $0ADB
        sbc #$0032
        and #$00FF
        xba 
        pha 
        lda $06,x
        sec 
        sbc $0AD7
        sbc #$0004
        and #$00FF
        ora $01,s
        sta $01,s
        sta $0000,y
        clc 
        adc #$0800
        sta $0004,y
        lda $01,s
        clc 
        adc #$0008
        sta $0008,y
        clc 
        adc #$0800
        sta $000C,y
        tya 
        clc 
        adc #$0010
        sta $70
        pla 
        sec 
        sbc #$000E
        jsr draw_head_icon
        rts 

    .hex_to_dec
        ldx #$0000
    ..loop
        cmp #$000A
        bcc ..return
        sbc #$000A
        inx 
        bra ..loop
    ..return
        and #$000F
        pha 
        txa 
        xba 
        and #$0F00
        ora $01,s
        xba 
        plx
        rts 


;####################################################################
;# edit level data

!initcommand_success = $8000
!initcommand_set_animation = $8100
!initcommand_skip = $2000
!initcommand_load_subconfig = $8300
!initcommand_set_palette = $8400
!initcommand_set_oam = $8500
!initcommand_spawn_relative = $8600
!initcommand_set_directional = $8700
!initcommand_set_position = $8800
!initcommand_setup_static = $8900
!initcommand_bulk_set = $8A00
!initcommand_set_oam_special = $8B00
!initcommand_set_palette2 = $8C00
!initcommand_set_alt_palette = $8D00
!initcommand_setup_static2 = $8E00
!version = 1

macro sprite(param, x, y, sprite)
	if !version == 0
		if <sprite> >= $0DB6
			dw <param>, <x>, <y>, <sprite>-2
		else
			dw <param>, <x>, <y>, <sprite>
		endif
	else
		dw <param>, <x>, <y>, <sprite>
	endif
endmacro

pushpc
    ;# Glimmer's Galleon no longer blinds players
    org $80C00E
        nop #3
    ;# Red Hot Ride - No Animal Sign now gives a banana coin
    org $FE14C8
        %sprite($0201, $14A0, $02B1, $0852)
    ;# Ghosly Grove - Kloak at the start now throws active TNT instead of a chest with a red balloon
    org $FFC74B
        db $10 : dw $FFC945
    ;# Parrot Chute Panic - No Animal Sign now gives an [O]
    org $FE2756
        %sprite($0001, $0194, $1312, $1046)
    ;# Artic Abyss - No Enguarde Sign before goal now gives a Red Balloon
    org $FE6508
	    %sprite($0001, $0322, $03AC, $0870)

    ;# Expand pointers and init scripts
    org $BBF846
        new_sprite_pointers:
            dw no_squawks_o_kong        ; 1046
            dw tnt_barrel_trap          ; 1048

    org $FFFF3A
        new_sprite_inits:
            no_squawks_o_kong:
                dw !initcommand_load_subconfig, $FF987C
                dw $0042, $0002
                dw !initcommand_set_animation, $02B7
                dw !initcommand_set_oam, $6000
                dw !initcommand_success
            tnt_barrel_trap:
                dw !initcommand_load_subconfig, $FFC9C3
                dw !initcommand_set_animation, $02FF
                dw !initcommand_set_alt_palette, $0002
                dw sprite.state, $0001
                dw sprite.interaction_flags, $0021
                dw !initcommand_success
pullpc

        
;#######################################################
;# Draw messages at the bottom of the screen

!vram_loc = $3400/2

pushpc
    org $BB8CA2
        jsl save_settings
        nop #1
    org $BB8CA9
        jsl save_settings
        nop #1
    org $80FFEE
        dw irq_hook
    org $80864A
        jsl setup_irq
        nop #1
    org $B5D443
        jsl setup_irq_from_map
    org $B5D238
        jsl setup_irq_from_big_map
    org $80FC00
        save_settings:
                lda.w $79E2,y
                sta $00,x
                sta.l !reg_backup-$2100,x
                rtl
        setup_irq:
            .from_level
                lda #$00
                sta !vram_index
            .shared
                lda $213F
                lda $2137
                jsl can_show_irq
                bcc .no_irq
            .valid
                lda !display_message_phase
                beq .no_irq
            .force
                lda #$00
                sta !display_message_irq_fire
                lda !display_message_y_pos
                sta $4209
                stz $420A
                lda #$A1
                sta $4200
                cli 
                rtl 
            .no_irq
                lda #$81
                sta $4200
                rtl 
            .turn_off_screen
                stz $2100
                rtl 
            .from_big_map
                jsl handle_messages_long
                jsl draw_reward_map_short
            .from_map
                jsl $808CA8
                sep #$30
                jsl setup_irq_shared
                lda #$02
                sta !vram_index
                rep #$30
                rtl 
                
        irq_hook:
                sei 
                rep #$30
                pha 
                phx 
                phy 
                phb 
                phk 
                plb 
                sep #$10
                lda $4300
                sta !dma_settings_backup
                lda $4302
                sta !dma_settings_backup+$02
                lda $4304
                sta !dma_settings_backup+$04
                lda $4306
                sta !dma_settings_backup+$06
                sep #$20
                lda !display_message_phase
                and #$07
                asl 
                tax 
                jsr wait_for_hblank
                lda #$80
                sta $2100
                stz $4200
                stz $420C

                lda !display_message_irq_fire
                beq .first
                lda #$00
                sta !display_message_irq_fire
                lda !display_message_phase
                cmp #$04
                bne .nope
                jmp .restore_cgram_and_vram
            .nope
                jmp .end

            .first
                lda #$01
                sta !display_message_irq_fire
                jmp (.ptrs,x)

            .ptrs
                dw .finish_short
                dw .backup_cgram
                dw .backup_vram
                dw .upload_vram
                dw .upload_layer_3_palette
                dw .finish_short
                dw .finish_short
                dw .finish_short

            .restore_cgram_and_vram
                rep #$20
                ldy #$00
                sty $2121
                lda #$2200
                sta $4300
                lda.w #!palette_backup_data
                sta $4302
                ldy.b #!palette_backup_data>>16
                sty $4304
                lda #$0040
                sta $4305
                ldx #$01
                stx $420B
                jmp .end
            
            .backup_vram
                rep #$20
                ldy #$80
                sty $2115
                lda !vram_index
                tax 
                lda.l .vram_tilemap,x
                sta $2116
                lda #$3981
                sta $4300
                lda.w #!vram_backup
                sta $4302
                ldy.b #!vram_backup>>16
                sty $4304
                lda #$0100
                sta $4305
                ldx #$01
                stx $420B
                sep #$20
                lda #$00
                jmp .finish_short

            .backup_cgram
                ldx #$00
                lda #$00
                sta $2121
            ..loop
                lda $213B
                sta.l !palette_backup_data,x
                lda $213B
                and #$7F
                sta.l !palette_backup_data+$01,x
                inx #2
                cpx #$40
                bcc ..loop
                jmp .end

            .upload_vram
                rep #$20
                ldy #$80
                sty $2115
                lda #$1801
                sta $4300
                ldy.b #$ED
                sty $4304
                lda.w #$57EF
                sta $4302
                lda !vram_index
                tax 
                lda.l .vram_chr,x
                sta $2116
                lda #$03C0
                sta $4305
                ldx #$01
                stx $420B
                sep #$20
                lda #$00
                jmp .finish_short

            .upload_layer_3_palette
                rep #$20
                ldy #$00
                sty $2121
                lda #$2200
                sta $4300
                lda.w #!palette_buffer
                sta $4302
                ldy.b #!palette_buffer>>16
                sty $4304
                lda #$0040
                sta $4305
                ldx #$01
                stx $420B
            ..upload_tilemap
                ldy #$80
                sty $2115
                lda #$1801
                sta $4300
                lda !vram_index
                tax 
                lda.l .vram_tilemap,x
                sta $2116
                lda.w #!text_buffer
                sta $4302
                ldy.b #!text_buffer>>16
                sty $4304
                lda #$0100
                sta $4305
                ldx #$01
                stx $420B
            
            .finish 
                sep #$20
                lda #$04
                sta $212C
                stz $212E
                lda #$30
                sta $2130
                stz $2131
                stz $2111
                stz $2111
                lda #$C0
                sta $2112
                lda #$01
                stz $2112
                
                lda !vram_index
                tax 
                lda.l .vram_tilemap_start,x
                sta $2109
                stz $210C

                lda #$0F
            .finish_short
                sta $2100
                lda #$DA
                sta $4209
                stz $420A
                lda #$21
                sta $4200
                bra .end_shared

            .end
                rep #$20
                lda !reg_backup+$2C
                sta $212C
                lda !reg_backup+$2E
                sta $212E
                lda !reg_backup+$30
                sta $2130
                sep #$20
                lda !reg_backup+$09
                sta $2109
                lda !reg_backup+$0C
                sta $210C

                stz $2100
              ;  jsl setup_irq_force
                lda #$81
                sta $4200
                jsl force_didi_reload

            ..shared
                rep #$30
                lda !dma_settings_backup
                sta $4300
                lda !dma_settings_backup+$02
                sta $4302
                lda !dma_settings_backup+$04
                sta $4304
                lda !dma_settings_backup+$06
                sta $4306
                plb 
                ply 
                plx 
                pla 
                rti 

            .vram_tilemap
                dw $3400/2
                dw $2C00/2
            .vram_tilemap_start
                dw $0018
                dw $0014
            .vram_chr
                dw $0000/2
                dw $2800/2
            .vram_chr_start
                dw $0018
                dw $0014

        wait_for_hblank:
            - 
                bit $4212
                bvc - 
            - 
                bit $4212
                bvs - 
        wait_for_scanline:
                nop #64
                rts 

    print pc
    assert pc() <= $80FFB0
pullpc

palette_data:
    dw $0000,$7FFF,$0000,$6318,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000,$7FF8,$00FF,$0000,$6318
    dw $7FF8,$037F,$0000,$6318,$7FF8,$7A76,$0000,$6318,$7FF8,$762E,$0000,$6318,$7FF8,$7BC0,$0000,$6318


handle_messages:
        lda !display_message_phase
        and #$0007
        asl 
        tax 
        jmp (.ptrs,x)
    .long
        jsr handle_messages
        rtl 

    .ptrs
        dw .check_button
        dw .move_up
        dw .move_up
        dw .move_up
        dw .process_messages
        dw .move_down
        dw .move_down
        dw .move_down

    .check_button
        ;lda $0510
        ;and #$0030
        ;beq ..nope
        ;lda.w #180
        ;sta !display_message_timer
        ;bra +
        lda $08C2
        and #$0040  ; game paused
        bne ..nope
        lda !display_message_activate
        beq ..nope
        lda !display_message_timer
        beq ..nope
    +   
        lda #$0000
        sta !display_message_activate
        lda $0B04
        sta !backup_vram_slot
        lda #$0DE2
        sta $0B04
        lda #$00E0
        sta !display_message_y_pos
        bra .move_up
    ..nope 
        rts 
    

    .move_up
        lda !display_message_y_pos
        sec 
        sbc #$0008
        sta !display_message_y_pos
        lda !display_message_phase
        inc 
        sta !display_message_phase
        rts 
    .move_down
        lda !display_message_y_pos
        clc 
        adc #$0008
        sta !display_message_y_pos
        lda !display_message_phase
        inc 
        and #$0007
        sta !display_message_phase
        rts 

    .process_messages
        lda $08C2
        and #$0040  ; game paused
        bne ..return
        lda !display_message_timer
        bne ..nope
        lda !backup_vram_slot
        sta $0B04
        bra .move_down
    ..nope 
        dec 
        sta !display_message_timer
    ..return
        rts 

can_show_irq:
        lda $08C2
        and #$40
        bne .invalid_by_lag
        lda !display_message_phase
        beq .lol
        lda $213D
        xba 
        lda $213D
        xba 
        rep #$20
        and #$01FF
        inc 
        cmp !display_message_y_pos
        bcs .invalid_by_lag_and_extend
    .lol
        rep #$20
        lda $20
        cmp #$F3E6
        beq .invalid
        sep #$20
        sec 
        rtl 
    .invalid
        rep #$20
        lda #$0000
        sta !display_message_timer
        sta !display_message_activate
        sta !display_message_y_pos
        sta !display_message_phase
        sep #$20
        clc
        rtl
    .invalid_by_lag_and_extend
        lda !display_message_timer
        inc 
        sta !display_message_timer
    .invalid_by_lag
        jsl force_didi_reload
        sep #$20
        clc 
        rtl 

;$BBBDCD
force_didi_reload:
        php 
        rep #$30
        ldx $0593
        cpx #$0DE2
        beq .primary
        ldx $0597
    .primary
        lda #$FFFF
        sta $16,x
        plp 
        rtl 

pushpc
    org $B5CE0D
        jsl clear_ram
    org $BB9214
        jsl clear_ram
    org $BBBDD0
        jsl back_up_message
pullpc

back_up_message:
        sta $0006CF
        lda !display_message_phase
        cmp #$0000
        beq .no_signal
        cmp #$0005
        bcs .no_signal
        cmp #$0004
        bne .not_on_timer
        lda !display_message_timer
        cmp.w #30
        bcc .no_signal
    .not_on_timer
        lda #$0001
        bra .clear
    .no_signal
        lda #$0000
    .clear
        sta !display_message_rerun
        lda #$0000
        sta !display_message_phase
        sta !display_message_timer
        sta !display_message_y_pos
        sta !display_message_activate
        sta !display_message_irq_fire
        sep #$30
        jsl setup_irq_turn_off_screen
        jsl setup_irq_no_irq
        rep #$30
        rtl 

clear_ram:
        lda !display_message_rerun
        pha 
        jsl $808E6A
        pla 
        sta !display_message_rerun
        rtl 


pushpc
    org $80EDDC
        jml edit_water_effect
pullpc

edit_water_effect:
        lda !display_message_phase
        bne .edit_for_message
        bra +
    .edit_for_message
        lda #$00F0
        sta $8833
    +   
        lda #$007F
        sta $8835
        lda #$0070
        sta $8836
        lda #$0001
        sta $8838
        lda #$0000
        sta $8839
        lda #$0000
        sta $883B
        jml $80EDEE

macro a()
    text_buffer:
        .level
            dw $2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000
            dw $2000,$2000,$2000,$2000,$2000,$2000,$2000,$2032,$2025,$2023,$2025,$2029,$2036,$2025,$2024,$2000,$3433,$3431,$3435,$3421,$3437,$342B,$3433,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000
            dw $2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2026,$2032,$202F,$202D,$2000,$302C,$3038,$3015,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000
            dw $2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000,$2000

        .map
            dw $2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280
            dw $2280,$2280,$2280,$2280,$2280,$2280,$2280,$2032|$0280,$2025|$0280,$2023|$0280,$2025|$0280,$2029|$0280,$2036|$0280,$2025|$0280,$2024|$0280,$2280,$3433,$3431,$3435,$3421,$3437,$342B,$3433,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280
            dw $2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2026,$2032,$202F,$202D,$2280,$302C,$3038,$3015,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280
            dw $2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280,$2280
endmacro