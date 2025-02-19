pushpc

macro a()
    ; Cranky: Galleon
    org $B4C7B1
        dw DATA_F71EDB
        dw DATA_F71F14
        dw DATA_F71F6A
        dw DATA_F71FAB
        dw DATA_F72000
        dw DATA_F7207B

    ; Cranky: Cauldron
    org $B4C7BD
        dw DATA_F720DA
        dw DATA_F72134
        dw DATA_F72175
        dw DATA_F721CE
        dw DATA_F72222
        dw DATA_F72259

    ; Cranky: Quay
    org $B4C7C9
        dw DATA_F722CC
        dw DATA_F72327
        dw DATA_F72378
        dw DATA_F723CB
        dw DATA_F72422
        dw DATA_F72446

    ; Cranky: Kremland
    org $B4C7D5
        dw DATA_F72498
        dw DATA_F724EB
        dw DATA_F72540
        dw DATA_F7259A
        dw DATA_F7260E
        dw DATA_F72666

    ; Cranky: Gulch
    org $B4C7E1
        dw DATA_F726A8
        dw DATA_F726E4
        dw DATA_F72741
        dw DATA_F7279B
        dw DATA_F727D2
        dw DATA_F72811

    ; Cranky: Keep
    org $B4C7ED
        dw DATA_F7286E
        dw DATA_F728DF
        dw DATA_F72936
        dw DATA_F729A8
        dw DATA_F72A03
        dw DATA_F72A75

    ; Cranky: Lost World
    org $B4C7F9
        dw DATA_F72AE5
        dw DATA_F72B39
        dw DATA_F72B98
        dw DATA_F72BD2
        dw DATA_F72BF5
endmacro

    org $B495A8
        ldx.w #funky_menu

    org $B4C4ED
	    dw !null_pointer
	    dw funky_menu
	    dw !null_pointer
	    dw !null_pointer
	    dw klubba_menu

    org $B4C4F7
        dw cranky_menu_galleon
        dw cranky_menu_cauldron
        dw cranky_menu_quay
	    dw !null_pointer
        dw cranky_menu_gulch
        dw cranky_menu_keep
	    dw !null_pointer
	    dw !null_pointer
        dw cranky_menu_kremland
        dw cranky_menu_lost_world
        dw cranky_menu_lost_world
        dw cranky_menu_lost_world
        dw cranky_menu_lost_world
        dw cranky_menu_lost_world

    org $B4C513
        dw wrinkly_menu_galleon
        dw wrinkly_menu_cauldron
        dw wrinkly_menu_quay
        dw wrinkly_menu_kremland
        dw wrinkly_menu_gulch
        dw wrinkly_menu_keep
        dw wrinkly_menu_krock

    org $B4C521
        dw swanky_menu_galleon
        dw swanky_menu_cauldron
        dw swanky_menu_quay
	    dw !null_pointer
        dw swanky_menu_gulch
        dw swanky_menu_keep
	    dw !null_pointer
	    dw !null_pointer
        dw swanky_menu_kremland

    org $BAD000
        cranky_menu_galleon:
            dw $000E
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Leave Hint Shop", $00, $00

        cranky_menu_cauldron:
            dw $000E
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Leave Hint Shop", $00, $00

        cranky_menu_quay:
            dw $000E
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Leave Hint Shop", $00, $00
        cranky_menu_kremland:
            dw $000E
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Leave Hint Shop", $00, $00
        cranky_menu_gulch:
            dw $000E
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Leave Hint Shop", $00, $00
        cranky_menu_keep:
            dw $000E
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Leave Hint Shop", $00, $00
        cranky_menu_lost_world:
            dw $000C
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Hint           - 1 COIN ", $00, $00
            db "     Leave Hint Shop", $00, $00


        funky_menu:
            dw $0004
            db "     Hire Plane - FREE   ", $00, $00
            db "     Leave Airport", $00, $00, $00, $00


        wrinkly_menu_galleon:
            dw $0010
            db "     Save Game     - FREE", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Leave Kollege", $00, $00

        wrinkly_menu_cauldron:
            dw $0010
            db "     Save Game     - FREE", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Leave Kollege", $00, $00
            
        wrinkly_menu_quay:
            dw $0010
            db "     Save Game     - FREE", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Leave Kollege", $00, $00

        wrinkly_menu_kremland:
            dw $000A
            db "     Save Game     - FREE", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Leave Kollege", $00, $00

        wrinkly_menu_gulch:
            dw $000A
            db "     Save Game     - FREE", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Leave Kollege", $00, $00

        wrinkly_menu_keep:
            dw $0008
            db "     Save Game     - FREE", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Leave Kollege", $00, $00

        wrinkly_menu_krock:
            dw $0008
            db "     Save Game     - FREE", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Hint          - 1 COIN ", $00, $00
            db "     Leave Kollege", $00, $00

        swanky_menu_galleon:
            dw $0008
            db "     Easy Quiz       - FREE", $00, $00
            db "     Medium Quiz     - 1 COIN", $00, $00
            db "     Hard Quiz       - 2 COINS", $00, $00
            ;db "     Easy Quiz 2     - FREE", $00, $00
            db "     Leave Studio", $00, $00

        swanky_menu_cauldron:
            dw $0008
            db "     Easy Quiz       - 1 COIN", $00, $00
            db "     Medium Quiz     - 2 COINS", $00, $00
            db "     Hard Quiz       - 3 COINS", $00, $00
            db "     Leave Studio", $00, $00

        swanky_menu_quay:
            dw $0008
            db "     Easy Quiz       - 1 COIN", $00, $00
            db "     Medium Quiz     - 2 COINS", $00, $00
            db "     Hard Quiz       - 3 COINS", $00, $00
            db "     Leave Studio", $00, $00

        swanky_menu_kremland:
            dw $0008
            db "     Easy Quiz       - 1 COIN", $00, $00
            db "     Medium Quiz     - 2 COINS", $00, $00
            db "     Hard Quiz       - 3 COINS", $00, $00
            db "     Leave Studio", $00, $00

        swanky_menu_gulch:
            dw $0008
            db "     Easy Quiz       - 1 COIN", $00, $00
            db "     Medium Quiz     - 2 COINS", $00, $00
            db "     Hard Quiz       - 3 COINS", $00, $00
            db "     Leave Studio", $00, $00

        swanky_menu_keep:
            dw $0008
            db "     Easy Quiz       - 1 COIN", $00, $00
            db "     Medium Quiz     - 2 COINS", $00, $00
            db "     Hard Quiz       - 3 COINS", $00, $00
            db "     Leave Studio", $00, $00


        klubba_menu:
            dw $0006
            db "     Pay Up - 1 Item", $00, $00
            db "     Fight Him!", $00, $00
            db "     Run Away", $00, $00


    ; Cranky: Galleon
    org $B4CB3F
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Cranky: Cauldron
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Cranky: Quay
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Cranky: Kremland
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Cranky: Gulch
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Cranky: Keep
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Cranky: Lost World
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000

    ; Wrinkly costs
    org $B4CBF3
        dw $0000
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Wrinkly: Cauldron
        dw $0000
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Wrinkly: Quay
        dw $0000
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Wrinkly: Kremland
        dw $0000
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Wrinkly: Gulch
        dw $0000
        dw $0001
        dw $0001
        dw $0001
        dw $0000
    ; Wrinkly: Keep
        dw $0000
        dw $0001
        dw $0001
        dw $0000
    ; Wrinkly: Krock
        dw $0000
        dw $0001
        dw $0001
        dw $0000

    ;# Expands action menu
;    org $B4CBB5
;        dw $0000
;        dw $0001
;        dw $0002
;        dw $0000
;        dw $0000

;    org $B4CCD7
;	    dw $A391
;	    dw $A391
;	    dw $A391
;	    dw $A391
;	    dw $A98C

; _B4CD41

; B4C591: POINTERS A CUESTIONES DE SWANKY
; POR HACER:
; MOVER TABLA A OTRO LADO Y DE AHI COMENZAR A LLENAR POINTERS
; VERIFICAR QUE SE TENGA SUFICIENTE ESPACIO

pullpc


