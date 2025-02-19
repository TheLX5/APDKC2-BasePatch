
pushpc
    org $808E11
        jsl handle_starting_kong
    org $B4912F
        jsl handle_starting_kong
    org $B4C093
        jsl handle_starting_kong
    org $808FC2
        jsl handle_starting_kong
pullpc

handle_starting_kong:
        lda.l handle_starting_kong
        and #$0002
        dec 
        jml $808837

;#######################################################
;# Disables DK barrels from being interacted with

pushpc
    ;# Grounded, grab-able barrels
    org $B393BC
        jsl handle_ground_dk_barrels

    ;# Suspended in mid air
    org $B3944D
        jml handle_air_dk_barrels

    org $B39378
        jml handle_dk_barrel_blink
pullpc

handle_ground_dk_barrels:
        lda !enable_dk_barrels
        and #$0003
        cmp #$0003
        bne .not_available
        jsl $B8D5E0
    .not_available
        rtl

handle_air_dk_barrels:
        lda !enable_dk_barrels
        and #$0003
        cmp #$0003
        bne .not_available
        lda $060B
        and #$0001
        jml $B39453
    .not_available
        jml $B39484

handle_dk_barrel_blink:
        lda !enable_dk_barrels
        and #$0003
        cmp #$0003
        bne .not_available
    .available
        lda $54,x
        sta $8E
        jml $B3937C
    .not_available
        lda #$0000
        sta $00,x
        jml $B39393

;#######################################################
;# Disables cartwheel

pushpc
    org $B8C9F8
        jml handle_cartwheel
pullpc

handle_cartwheel:
        lda !enable_cartwheel
        and #$00FF
        beq .not_available
        phk 
        pea.w .code_B8CC32-1
        pea.w $8EB7-1
        jml $B8CC32
    .code_B8CC32
        ldy $66
        jml $B8C9FD
    .not_available
        jml $B8CA06
        

;#######################################################
;# Disables carrying items

pushpc
    ; $B8C9CB
    org $B8CB8C
        jml handle_carry
pullpc

handle_carry:
        lda !enable_carry
        and #$00FF
        beq .not_available
        ldx $64
        lda $1E,x
        jml $B8CB90
    .not_available
        jml $B8CB95

;#######################################################
;# Disables climbing

pushpc
    org $B886A6
        jml handle_climbing
    org $B886FB
        jml handle_horizontal_climbing
    org $B88670
        jml handle_sprite_climbing

pullpc

handle_climbing:
        lda !enable_climb
        and #$00FF
        beq .not_available
        phk 
        pea.w .code_B886E0-1
        pea.w $8EB7-1
        jml $B886E0
    .code_B886E0
        lda #$0035
        jml $B886AC
    .not_available
        jml $B886CC

handle_horizontal_climbing:
        lda !enable_climb
        and #$00FF
        beq .not_available
        lda #$0038
        sta $2E,x
        jml $B88700
    .not_available
        jml $B8871A

handle_sprite_climbing:
        lda !enable_climb
        and #$00FF
        beq .not_available
        phk 
        pea.w .code_B88092-1
        pea.w $8EB7-1
        jml $B88092
    .code_B88092
        phk 
        pea.w .code_B88EBC-1
        pea.w $8EB7-1
        jml $B88EBC
    .code_B88EBC
        jml $B88676
    .not_available
        jml $B8869D


;#######################################################
;# Disables clinging

pushpc
    org $B3992E
        jml handle_cling
    org $B399EE
        jml handle_team_attack_cling
pullpc

handle_cling:
        lda !enable_cling
        and #$00FF
        beq .not_available
        ldx $64
        stx $0D82
        jml $B39933
    .not_available
        jml $B3996E

handle_team_attack_cling:
        lda !enable_cling
        and #$00FF
        beq .not_available
        lda #$000D
        jsl $B8D8BA
        jml $B399F5
    .not_available
        jml $B399EC

;#######################################################
;# Disables swimming

pushpc
    org $B8C76F
        jml handle_swim
pullpc

handle_swim:
        lda !enable_swim
        and #$00FF
        beq .not_available
        lda $0983
        and #$8000
        jml $B8C775
    .not_available
        jml $B8C777

;#######################################################
;# Disable Dixie's Helicopter Spin

pushpc
    ;# $B899FF
    org $B8CA23
        jml handle_helicopter_spin
pullpc

handle_helicopter_spin:
        lda !enable_helicopter_spin
        and #$00FF
        beq .not_available
    .available
        lda $24,x
        bpl .code_B8CA28
    .not_available
        jml $B8CA27
    .code_B8CA28
        jml $B8CA28

;#######################################################
;# Initial Kong

pushpc
    org $808FC2
        jsl load_initial_kong
pullpc

load_initial_kong:
        lda.l setting_starting_kong
        and #$0003
        cmp #$0003
        bne .one_kong
        lda #$0001
    .one_kong
        dec 
        and #$0001
        jml $808837

;#######################################################
;# Disables team attack

pushpc
    org $B88430
        jml handle_team_attack
pullpc

handle_team_attack:
        lda !enable_team_attack
        and #$00FF
        beq .not_available
        ldx #$0540
        ldy #$0540
        jml $B88436
    .not_available
        jml $B8848D

;#######################################################
;# Disables barrels

pushpc
    org $B3EF18
        jsl handle_barrel
    org $B3E8DD
        jsl handle_barrel_blink
    org $B3EF6A
        jml handle_team_attack_barrel
pullpc

; 4004 - arrow barrel
; 0000 - regular barrel, rotates
; 000C - auto blast barrel - shoots right
; 200C - warp barrel - shoots up
; 2004 - bonus barrel
; 4000 - regular barrel, rotates
; 1000 - controllable barrel - free rotation
; 0006 - diddy barrel
; 0005 - dixie barrel
; 48E0 - barrel - moves and shoots up
; 12E0 - controllable barrel - free rotation, automoves
; 0810 - controllable barrel - free movement

; Barrel bits
; A?WC R??? MMMM baDD
; DD = Usage
;   00 - Always enterable
;   01 - Exclusive to Dixie (Disables Diddy)
;   02 - Exclusive to Diddy (Disables Dixie)
;   03 - Disable interaction
; a = Auto shoots
; b = Bonus barrel
; R = Disable rotation?
; C = Can be controlled
; W = Warps to another level
; A = Animal barrel
; MMMM = Movement type?


handle_barrel:
        ldx $64
        lda $46,x
        bmi .animal_barrel
        lda $46,x
        and #$2008
        beq +
        bra .warp_barrel
    +   
        lda $46,x
        and #$1010
        beq +
        bra .controllable_barrel
    +   
        lda $46,x
        and #$0003
        bne .kong_barrel
    .regular_barrel
        lda !enable_barrels
        and #$00FF
        bne .return_valid
        clc 
        rtl 

    .kong_barrel
        lda !enable_kong_barrels
        and #$00FF
        bne .return_valid
        clc 
        rtl 

    .warp_barrel
        cmp #$2000
        bcc .return_valid
        and #$0008
        cmp #$0008
        bne .return_valid
        lda !level_id
        and #$00FF      ; terrible fix for klobber karnage
        cmp #$0080
        beq .return_valid
        lda !enable_warp_barrel
        and #$00FF
        bne .return_valid
        clc 
        rtl 
    

    .controllable_barrel
        lda !enable_controllable_barrels
        and #$00FF
        bne .return_valid
        clc 
        rtl 

    .return_valid
        lda $26,x
        lda #$0010
        jml $B8D8BA

    .animal_barrel
        lda $26,x
        and #$00FF
        beq ..squitter
        cmp #$0001
        beq ..rattly
        cmp #$0002
        beq ..squawks
        cmp #$0003
        beq ..rambi
    ..enguarde
        lda !enable_enguarde
        and #$00FF
        bne .return_valid
        bra .not_available
    ..squawks
        lda !enable_squawks
        and #$00FF
        bne .return_valid
        bra .not_available
    ..squitter
        lda !enable_squitter
        and #$00FF
        bne .return_valid
        bra .not_available
    ..rattly
        lda !enable_rattly
        and #$00FF
        bne .return_valid
        bra .not_available
    ..rambi
        lda !enable_rambi
        and #$00FF
        bne .return_valid
        bra .not_available
        
    .not_available
        clc 
        rtl 

;# $B3E939
;# Tells apart from barrel types
;# if 8000 then it's an animal barrel

handle_barrel_blink:
        ldx $64
        lda $46,x
        bmi .animal_barrel
        lda $46,x
        and #$2008
        beq +
    .warp_barrel
        bra .return
    +   
        lda $46,x
        and #$1010
        beq +
        bra .controllable_barrel
    +   
        lda $46,x
        and #$0003
        bne .kong_barrel
    .regular_barrel
        lda !enable_barrels
        jsr .blink
        bra .return

    .kong_barrel
        lda !enable_kong_barrels
        jsr .blink
        bra .return

    .controllable_barrel
        lda !enable_controllable_barrels
        jsr .blink
        
    .return
        lda $32,x
        rtl 

    .animal_barrel
        lda $26,x
        and #$00FF
        beq ..squitter
        cmp #$0001
        beq ..rattly
        cmp #$0002
        beq ..squawks
        cmp #$0003
        beq ..rambi
    ..enguarde
        lda !enable_enguarde
        jsr .blink
        bra .return
    ..squawks
        lda !enable_squawks
        jsr .blink
        bra .return
    ..squitter
        lda !enable_squitter
        jsr .blink
        bra .return
    ..rattly
        lda !enable_rattly
        jsr .blink
        bra .return
    ..rambi
        lda !enable_rambi
        jsr .blink
        bra .return

    .blink
        and #$00FF
        bne .available
        lda #$0000
        sta $1C,x
        lda $2C
        lsr #3
        bcs .no_blink
        lda #$C000
        sta $1C,x
    .no_blink
        rts 
    .available
        rts 


handle_team_attack_barrel:
        lda $46,x
        bmi .animal_barrel
        lda $46,x
        and #$2008
        beq +
        bra .warp_barrel
    +   
        lda $46,x
        and #$1010
        beq +
        bra .controllable_barrel
    +   
        lda $46,x
        and #$0003
        bne .kong_barrel
    .regular_barrel
        lda !enable_barrels
        and #$00FF
        bne .available
        bra .not_available

    .kong_barrel
        lda !enable_kong_barrels
        and #$00FF
        bne .available
        bra .not_available

    .warp_barrel
        cmp #$2000
        bcc .available
        and #$0008
        cmp #$0008
        bne .available
        lda !level_id
        and #$00FF      ; terrible fix for klobber karnage
        cmp #$0080
        beq .available
        lda !enable_warp_barrel
        and #$00FF
        bne .available
        bra .not_available

    .controllable_barrel
        lda !enable_controllable_barrels
        and #$00FF
        bne .available
        bra .not_available

    .available
        lda #$000F
        jsl $B8D8BA
        jml $B3EF71

    .not_available
        jml $B3EF44

    .animal_barrel
        lda $26,x
        and #$00FF
        beq ..squitter
        cmp #$0001
        beq ..rattly
        cmp #$0002
        beq ..squawks
        cmp #$0003
        beq ..rambi
    ..enguarde
        lda !enable_enguarde
        and #$00FF
        bne .available
        bra .not_available
    ..squawks
        lda !enable_squawks
        and #$00FF
        bne .available
        bra .not_available
    ..squitter
        lda !enable_squitter
        and #$00FF
        bne .available
        bra .not_available
    ..rattly
        lda !enable_rattly
        and #$00FF
        bne .available
        bra .not_available
    ..rambi
        lda !enable_rambi
        and #$00FF
        bne .available
        bra .not_available


;#######################################################
;# Disables animals

pushpc
    org $BBC065
        jml handle_animal_spawn
    org $B893B0
        jml handle_animal_mount
    org $B38B08
        jsl handle_rattly_blink
    org $B38A3A
        jsl handle_rambi_squitter_blink
    org $B38DA8
        jsl handle_enguarde_blink
    org $B38C08
        jsl handle_squawks_blink
pullpc

handle_animal_spawn:
        lda.l $BBC070,x
        sta $6E
        cpx #$0002
        beq .squitter
        cpx #$0004
        beq .rattly
        cpx #$0006
        beq .squawks
        cpx #$0008
        beq .rambi
        cpx #$000A
        beq .enguarde
        bra .valid
    .squitter
        lda !enable_squitter
        and #$00FF
        beq .invalid
        bra .valid
    .rattly
        lda !enable_rattly
        and #$00FF
        beq .invalid
        bra .valid
    .squawks
        lda !enable_squawks
        and #$00FF
        beq .invalid
        bra .valid
    .rambi
        lda !enable_rambi
        and #$00FF
        beq .invalid
        bra .valid
    .enguarde
        lda !enable_squitter
        and #$00FF
        beq .invalid
        bra .valid
    .invalid
        stz $6E
    .valid
        lda $6E
        jml $BBC06B


handle_squawks_blink:
        lda !enable_squawks
        jsr handle_animal_blink
        lda $54,x
        sta $8E
        rtl 

handle_enguarde_blink:
        lda !enable_enguarde
        jsr handle_animal_blink
        lda $54,x
        sta $8E
        rtl 

handle_rambi_squitter_blink:
        lda $00,x
        cmp #$019C
        beq .rambi
    .squitter
        lda !enable_squitter
        jsr handle_animal_blink
        bra .return
    .rambi 
        lda !enable_rambi
        jsr handle_animal_blink
    .return
        lda $54,x
        sta $8E
        rtl 

handle_rattly_blink:
        ldx $64
        lda !enable_rattly
        jsr handle_animal_blink
        lda $54,x
        rtl 


handle_animal_blink:
        and #$00FF
        bne .available
        lda #$0000
        sta $1C,x
        lda $2C
        lsr #3
        bcs .no_blink
        lda #$C000
        sta $1C,x
    .no_blink
        rts 
    .available
        lda #$0000
        sta $1C,x
        rts 

handle_animal_mount:
        ldx $0A84
        lda $00,x
        cmp #$019C
        beq .rambi
        cmp #$01A0
        beq .enguarde
        cmp #$0198
        beq .squawks
        cmp #$0190
        beq .squitter
    .rattly
        lda !enable_rattly
        and #$00FF
        beq .not_available
        bra .available
    .rambi
        lda !enable_rambi
        and #$00FF
        beq .not_available
        bra .available
    .squawks
        lda !enable_squawks
        and #$00FF
        beq .not_available
        bra .available
    .enguarde
        lda !enable_enguarde
        and #$00FF
        beq .not_available
        bra .available
    .squitter
        lda !enable_squitter
        and #$00FF
        beq .not_available
        bra .available

    .available
        phk 
        pea.w .code_B8939C-1
        pea.w $8EB7-1
        jml $B8939C
    .code_B8939C
        ldx #$0540
        jml $B893B6
    .not_available
        jml $B893AF

;#######################################################
;# Disables skull karts

pushpc
    org $BED81D
        jml handle_skull_kart
    org $BED801
        jsl handle_skull_kart_blink
pullpc

handle_skull_kart:
        lda !enable_skull_kart
        and #$00FF
        beq .not_available
    .available
        ldy $6A
        lda $0024,y
        jml $BED822
    .not_available
        jml $BED887

handle_skull_kart_blink:
        ldx $64
        lda !enable_skull_kart
        and #$00FF
        bne .available
        lda #$0000
        sta $00,x
    .available
        lda $42,x
        rtl 


;#######################################################
;# Disables glimmer

pushpc
    org $B38EBE
        jml handle_glimmer
pullpc

handle_glimmer:
        lda !enable_glimmer
        and #$00FF
        beq .not_available
        lda $64
        sta $0989
        jml $B38EC3
    .not_available
        ldx $64
        lda #$0000
        sta $00,x
        jml $B38EEE

;#######################################################
;# Disables clapper

pushpc
    org $B3D98E
        jsl handle_clapper
    org $B3D93B
        jsl handle_clapper_blink
pullpc

handle_clapper:
        pha
        lda !enable_clapper
        and #$00FF
        beq .not_available
    .available
        pla 
        jsl $BEBE8B
        rtl 

    .not_available
        pla 
        rtl 

handle_clapper_blink:
        ldx $64
        lda !enable_clapper
        and #$00FF
        bne .available
        lda #$0000
        sta $1C,x
        lda $2C
        lsr #3
        bcs .no_blink
        lda #$C000
        sta $1C,x
    .no_blink
        lda $002E,y
        asl 
        rtl 
    .available
        lda #$0000
        sta $1C,x
        bra .no_blink



;#######################################################
;# Disables invincibility barrels

pushpc
    org $B39A96
        jsl handle_invincibility_barrels
pullpc

handle_invincibility_barrels:
        pha 
        lda !enable_invincible_barrel
        and #$00FF
        beq .not_available
    .available
        pla 
        jsl $B8D1FB
        rtl 
    .not_available
        pla 
        rtl 
