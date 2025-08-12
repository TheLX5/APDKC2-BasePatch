pushpc
    ;# Default icons
    org $B4B3E3;$B480BF
        lda.w #$5555
    org $B4B40B
        lda.w #$5555
    org $B480BF
        lda.w #$5555
    ;org $b4b3f7
    ;    lda.w #$5555
    ;org $b4b315
    ;    lda.w #$5555

    ;# Disable Cranky on map with L/R after beating everything
    org $B48795
        db $80
pullpc

;# $B5D3E7 enters levels


;#######################################################
;# Preload path data

pushpc
    org $B4B415
        jsl preload_path_data
        nop #1
pullpc

preload_path_data:
        ldx #$0000
    .loop
        lda.l .open_paths,x
        sta $7E5992,x
        inx #2
        cpx #$0010
        bcc .loop
        rtl

    .open_paths
        db $FF,$FF,$FF,$FF
        db $EF,$DF,$FF,$FD
        db $FF,$03,$8C,$FF
        db $3F,$F8,$00,$00


;#######################################################
;# Skip events

pushpc
    org $B4834C
        jml level_skip_move
    org $B4B33F
        stz $06AD
pullpc

level_skip_move:
        ldx #$0000
        lda $20
    .loop
        cmp.l .nmi_ptrs,x
        beq .process
        inx #2
        cpx #$0004
        bcc .loop
        lda $06A3
        and #$1060
        ora #$0040
        sta $06A3
    .process
        jml $B48352

    .nmi_ptrs
        dw $8CE9        ; Main Map
        dw $8CF1        ; Sub Maps

;#######################################################
;# Lock map

pushpc
    org $B487B7
        jml lock_map
pullpc

lock_map:
        jsl $B5801E
        lda #$0000
        sta !honey_trap_timer
        sta !death_link_flag
        sta !death_link_force
        lda #$0078
        sta !show_hit_counter
    .check_submaps
        lda $06AB
        cmp #$0007
        bcs .check_kore
        pha 
        lda.l setting_krock_boss_tokens
        and #$00FF
        beq .krock_item
        cmp !boss_tokens
        beq +
        bcs .krock_item
    +
        sep #$20
        lda #$01
        sta !enable_flying_krock
        rep #$20
    .krock_item
        pla 
        phx 
        tax 
        lda !enable_gangplank_galleon,x
        plx 
        and #$00FF
        bne .unlocked
    .locked_play_sound
        lda $0510
        and #$D0C0
        beq .locked
        lda #$005F
        jsl $B58003
    .locked
        jml $B487C2
    .unlocked
        lda $0510
        bit #$D0C0
        beq .locked
        jml $B48A46
    .check_kore
        ldx #$0008
    .loop
        cmp.l .kore_levels,x
        beq .found_kore
        dex #2
        bpl .loop
        jmp .process_bosses
        ;bra .unlocked
    .found_kore
        jsr compute_kore_unlock
        bcc .locked
        bra .unlocked

    .kore_levels
        dw $0061 ; Cauldron
        dw $0065 ; Quay
        dw $0069 ; Kremland
        dw $006D ; Gulch
        dw $0071 ; Keep

    .process_bosses
        lda $066E
        cmp.l galleon_levels
        bne +
        jmp .krow
    +   
        cmp.l cauldron_levels
        bne +
        jmp .kleever
    +   
        cmp.l quay_levels
        bne +
        jmp .kudgel
    +   
        cmp.l kremland_levels
        bne +
        jmp .king_zing
    +   
        cmp.l gulch_levels
        bne +
        jmp .kreepy
    +   
        cmp.l keep_levels
        bne +
        jmp .showdown
    +   
        cmp.l krock_levels
        bne +
        jmp .duel
    +   
        jmp .unlocked
    
    .krow
        ldy #$0000
        tyx
    ..loop
        phx 
        lda.l galleon_levels+$02,x
        jsr check_current_level_clear
        bcc ..incomplete_level
        iny 
    ..incomplete_level
        plx 
        inx #2
        cpx.w #10
        bcc ..loop
        tya 
        cmp.l required_galleon_levels
        bcs ..unlock
        jmp .locked_play_sound
    ..unlock
        jmp .unlocked


    .kleever
        ldy #$0000
        tyx
    ..loop
        phx 
        lda.l cauldron_levels+$02,x
        jsr check_current_level_clear
        bcc ..incomplete_level
        iny 
    ..incomplete_level
        plx 
        inx #2
        cpx.w #10
        bcc ..loop
        tya 
        cmp.l required_cauldron_levels
        bcs ..unlock
        jmp .locked_play_sound
    ..unlock
        jmp .unlocked


    .kudgel
        ldy #$0000
        tyx
    ..loop
        phx 
        lda.l quay_levels+$02,x
        jsr check_current_level_clear
        bcc ..incomplete_level
        iny 
    ..incomplete_level
        plx 
        inx #2
        cpx.w #12
        bcc ..loop
        tya 
        cmp.l required_quay_levels
        bcs ..unlock
        jmp .locked_play_sound
    ..unlock
        jmp .unlocked


    .king_zing
        ldy #$0000
        tyx
    ..loop
        phx 
        lda.l kremland_levels+$02,x
        jsr check_current_level_clear
        bcc ..incomplete_level
        iny 
    ..incomplete_level
        plx 
        inx #2
        cpx.w #12
        bcc ..loop
        tya 
        cmp.l required_kremland_levels
        bcs ..unlock
        jmp .locked_play_sound
    ..unlock
        jmp .unlocked


    .kreepy
        ldy #$0000
        tyx
    ..loop
        phx 
        lda.l gulch_levels+$02,x
        jsr check_current_level_clear
        bcc ..incomplete_level
        iny 
    ..incomplete_level
        plx 
        inx #2
        cpx.w #10
        bcc ..loop
        tya 
        cmp.l required_gulch_levels
        bcs ..unlock
        jmp .locked_play_sound
    ..unlock
        jmp .unlocked


    .showdown
        ldy #$0000
        tyx
    ..loop
        phx 
        lda.l keep_levels+$02,x
        jsr check_current_level_clear
        bcc ..incomplete_level
        iny 
    ..incomplete_level
        plx 
        inx #2
        cpx.w #12
        bcc ..loop
        tya 
        cmp.l required_keep_levels
        bcs ..unlock
        jmp .locked_play_sound
    ..unlock
        jmp .unlocked


    .duel
        ldy #$0000
        lda.l krock_levels+$02
        jsr check_current_level_clear
        bcc ..incomplete_level
        iny 
    ..incomplete_level
        tya 
        cmp.l required_krock_levels
        bcs ..unlock
        jmp .locked_play_sound
    ..unlock
        jmp .unlocked

check_current_level_clear:
        sta $5E
        and #$000F
        asl 
        tax 
        lda.l $BB817F,x
        sta $60
        lda $5E
        lsr #4
        asl 
        tax 
        lda.l $7E59F2,x
        and $60
        bne +
        clc 
        rts
    +   
        sec 
        rts



;###################################
;# Draw map
; $B5A919
; credits text 80F946
pushpc
    org $B5D3E3
        jsl draw_reward_map
pullpc

draw_reward_map:
        jsl $B48368
    .short
        ldy $70
        lda !reward_type
        and #$0001
        asl 
        tax 
        lda.l .tile_data,x
        sta $0002,y
        lda #$C8E8
        sta $0000,y
        tya 
        clc 
        adc #$0004
        sta $70
        tya 
        and #$000C
        tax 
        tya 
        lsr #4
        and #$001F
        tay 
        lda.l $BEC985,x
        ora $0400,y
        sta $0400,y

        lda $0512
        and #$000F
        cmp #$000F
        bne .dont_toggle
    .display_tracker
        lda !display_message_is_tracker
        bne .check_reward
        lda $0510
        and #$0030
        beq .check_reward
        lda #$0001
        sta !display_message_is_tracker
        lda #$0508
        jsl $B58021
    .check_reward
        lda $0510
        and #$2000
        beq .dont_toggle
        ldy #$052C
        lda !reward_type
        eor #$0001
        sta !reward_type
        beq ..sound
        ldy #$051B
    ..sound
        tya 
        jsl $B58021
    .dont_toggle

        rtl 

    .tile_data
        dw $3C00,$3C02


;#######################################################
;# Lock lost world

pushpc
    org $B49CE4
        jml lock_lost_world_levels
pullpc

lock_lost_world_levels:
        ldx.w #$0008
        lda $06AB
        and #$00FF
    .loop
        cmp.l .valid_levels,x
        beq .found
        dex #2
        bpl .loop
    .return
        lda $0654
        dec 
        jml $B49CE8
    .found
        lda $0654
        cmp #$0001
        bne .return
        txa 
        lsr 
        tax 
        lda !enable_lost_world,x
        and #$00FF
        bne .unlocked
    .locked
        jml $B49CF7
    .unlocked
        jml $B49D4F

    .valid_levels
        dw $0012,$001F,$0047,$002F,$0038

;#######################################################
;# Handle lost world kore

pushpc
    ; skip tracking stones
    org $B4B29C
        jmp $B2A9

    ; play animation
    org $B480EF
        jml play_kore_animation
pullpc

play_kore_animation:
        lda $06B1
        cmp #$000A
        bcc .not_map
        jsr compute_kore_unlock
        bcc .locked
    .unlocked
        sep #$20 
        lda #$05
        sta !lost_world_rocks
        rep #$20
        jml $B480FA
    .locked
        sep #$20 
        stz !lost_world_rocks
        rep #$20
    .not_map
        jml $B48147

compute_kore_unlock:
        sep #$20
        lda !enable_kore
        cmp.l setting_lost_world_rocks
        rep #$20
        rts 

;#######################################################
;# Handle flying krock

pushpc
    org $BBC34A
        jsl $B8A691
        jsl $B4AFAD
        jmp $C150
    org $B6A43B
        jml spawn_dk_showdown
    org $BB93EE
        jml showdown_song_fix
    org $BBAD09
        jml showdown_cutscene_fix

pullpc

spawn_dk_showdown:
        lda $7E59C9
        and #$0002
        beq .spawn_dk
        jml $B6A434
    .spawn_dk
        ora #$0002
        sta $7E59C9
        jml $B6A449

showdown_cutscene_fix:
        lda $7E59C9
        and #$0002
        jml $BBAD0F

showdown_song_fix:
        lda $7E59C9
        and #$0002
        beq .crisis_song
    .castle_song
        jml $BB93F6
    .crisis_song
        jml $BB93FE


pushpc
    starting_load_pointer = $FD819A
    org $FD81B4
        ;dw load_graphics_gangplank_galleon-starting_load_pointer
        ;dw load_graphics_crocodile_cauldron-starting_load_pointer
        ;dw load_graphics_krem_quay-starting_load_pointer
pullpc

load_graphics:
    .gangplank_galleon
        db $E6,$F3,$FC
        dw $2000|$8000
        dw $6DC0
        db $D9,$7B,$F9 
        dw $7800
        dw $0700
        ;# Add text loading
        db $ED,$EF,$57 
        dw $6000
        dw $2000
        db $00

    .crocodile_cauldron
        db $E7,$71,$54 
        dw $2000|$8000
        dw $7000
        db $E7,$71,$4D
        dw $7800
        dw $0700
        ;# Add text loading
        db $ED,$EF,$57 
        dw $6000
        dw $2000
        db $00

    .krem_quay
        db $E7,$78,$9E 
        dw $2000|$8000
        dw $7CA0
        db $D7,$A7,$F9
        dw $7000|$8000
        dw $0700
        db $C4,$C0,$F9 
        dw $7400|$8000
        dw $0700
        ;# Add text loading
        db $ED,$EF,$57 
        dw $6000
        dw $2000
        db $00