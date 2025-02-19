!debug = 0

!null_pointer = $FFFF
!level_id = $D3
!completed_level_flags = $7E59F2
!level_paths = $7E5992

!lost_world_rocks = $08F9

!ram = $B06800
;!ram = $7FFF00

!dk_coins = $08CE
!kremkoins = $08CC
!banana_coins = $08CA

!enable_carry = !ram+$00
!enable_cartwheel = !ram+$01
!enable_climb = !ram+$02
!enable_cling = !ram+$03
!enable_helicopter_spin = !ram+$04
!enable_swim = !ram+$05
!enable_team_attack = !ram+$06
!enable_rambi = !ram+$07
!enable_squawks = !ram+$08
!enable_enguarde = !ram+$09
!enable_squitter = !ram+$0A
!enable_rattly = !ram+$0B
!enable_clapper = !ram+$0C
!enable_glimmer = !ram+$0D
!enable_dk_barrels = !ram+$0E
!enable_barrels = !ram+$0F
!enable_kong_barrels = !ram+$10
!enable_controllable_barrels = !ram+$11
!enable_invincible_barrel = !ram+$12
!enable_warp_barrel = !ram+$13
!enable_skull_kart = !ram+$14

!enable_gangplank_galleon = !ram+$28
!enable_crocodile_cauldron = !ram+$29
!enable_krem_quay = !ram+$2A
!enable_krazy_kremland = !ram+$2B
!enable_gloomy_gulch = !ram+$2C
!enable_krools_keep = !ram+$2D
!enable_flying_krock = !ram+$2E
!enable_kore = !ram+$2F

!boss_tokens = !ram+$24

!energy_link_transfer = !ram+$4E
!energy_link_extractinator = !ram+$4C

!enable_freeze = !ram+$40
!enable_reverse = !ram+$42
!enable_deal_damage = !ram+$44
!enable_insta_death = !ram+$46
!enable_insta_dk_barrel = !ram+$48
!enable_barrel_trap = !ram+$50
!barrel_trap_timer = !ram+$52
!at_kong_menu = !collectible_flags-$04
!teleporting = !collectible_flags-$02

!collectible_flags = $7FFF00
!saved_index = $B88B8D

!extended_save_data = !ram+$200

!enable_lost_world = !ram+$30

!recv_index = !ram+$20
!init_flag = !ram+$22


!map_state = $0A10
!palette_backup = $0A12


if !debug == 0
    org $FDFF80
        setting_starting_kong:
            skip 1
        setting_goal:
            skip 1
        setting_lost_world_rocks:
            skip 1
        setting_starting_carry:
            skip 1
        setting_starting_climb:
            skip 1
        setting_starting_cling:
            skip 1
        setting_starting_cartwheel:
            skip 1
        setting_starting_swim:
            skip 1
        setting_starting_team_attack:
            skip 1
        setting_starting_helicopter_spin:
            skip 1
        setting_starting_rambi:
            skip 1
        setting_starting_squawks:
            skip 1
        setting_starting_enguarde:
            skip 1
        setting_starting_squitter:
            skip 1
        setting_starting_rattly:
            skip 1
        setting_starting_clapper:
            skip 1
        setting_starting_glimmer:
            skip 1
        setting_starting_skull_kart:
            skip 1
        setting_starting_barrel_kannons:
            skip 1
        setting_starting_barrel_exclamation:
            skip 1
        setting_starting_barrel_kong:
            skip 1
        setting_starting_barrel_warp:
            skip 1
        setting_starting_barrel_control:
            skip 1
        setting_krock_boss_tokens:
            skip 1
        setting_death_link:
            skip 1
        setting_energy_link:
            skip 1
        setting_trap_link:
            skip 1
        setting_reserved_link:
            skip 5
        setting_dk_coin_checks:
            skip 1
        setting_kong_checks:
            skip 1
        setting_balloonsanity:
            skip 1
        setting_coinsanity:
            skip 1
        setting_bananasanity:
            skip 1
        setting_swanky_checks:
            skip 1
        setting_reserved_check:
            skip 2
        setting_freeze_trap:
            skip 1
        setting_reverse_trap:
            skip 1
        setting_damage_trap:
            skip 1
        setting_insta_death_trap:
            skip 1
endif


struct sprite $0000
	.type:			skip 2	;00
	.render_order:		skip 2	;02
	.x_sub_position:	skip 2	;04
	.x_position:		skip 2	;06
	.y_sub_position:	skip 2	;08
	.y_position:		skip 2	;0A
	.ground_y_position:	skip 2	;0C
	.ground_distance:	skip 2	;0E
	.terrain_attributes:	skip 2	;10
	.oam_property:		skip 2	;12
	.unknown_14:		skip 2	;14
	.unknown_16:		skip 2	;16
	.unknown_18:		skip 2	;18
	.unknown_1A:		skip 2	;1A
	.unknown_1C:		skip 2	;1C
	.terrain_interaction:	skip 2	;1E
	.x_speed:		skip 2	;20
	.unknown_22:		skip 2	;22
	.y_speed:		skip 2	;24
	.max_x_speed:		skip 2	;26
	.unknown_28:		skip 2	;28
	.max_y_speed:		skip 2	;2A
	.x_force:		skip 2	;2C
	.state:			skip 1	;2E \ This is a pair in most cases, but a couple sprites use 2F alone
	.sub_state:		skip 1	;2F /
	.interaction_flags:	skip 2	;30
	.unknown_32:		skip 2	;32
	.unknown_34:		skip 2	;34
	.animation_id:		skip 2	;36
	.animation_timer:	skip 2	;38
	.animation_control:	skip 2	;3A
	.animation_address:	skip 2	;3C
	.unknown_3E:		skip 2	;3E
	.unknown_40:		skip 2	;40
	.general_purpose_42:	skip 2	;42
	.general_purpose_44:	skip 2	;44
	.general_purpose_46:	skip 2	;46
	.general_purpose_48:	skip 2	;48
	.general_purpose_4A:	skip 2	;4A
	.general_purpose_4C:	skip 2	;4C
	.general_purpose_4E:	skip 2	;4E
	.parameter:		skip 2	;50
	.movement_state:	skip 1	;52
	.movement_sub_state:	skip 1	;53
	.constants_address:	skip 2	;54
	.placement_number:	skip 2	;56
	.placement_parameter:	skip 2	;58
	.despawn_time:		skip 2	;5A
	.unknown_5C:		skip 2	;5C
endstruct