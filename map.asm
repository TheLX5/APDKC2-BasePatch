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
        bra .unlocked
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

        
;#######################################################
;# Draw sprites for tracking purposes


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