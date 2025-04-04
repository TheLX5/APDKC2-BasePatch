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
        lda $08C2
        and #$4000
        bne ..skip
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
        lda !enable_dk_barrels
        and #$0003
        cmp #$0003
        bne .return
        
        lda $0510
        and #$0030
        beq .return

        lda !enable_insta_dk_barrel
        beq .return
        
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
