macro credits_write_line(text, color)
    db ?end-?text
    db <color>
    ?text:
        db "<text>"
    ?end:
    db $00
    if <color> == $08
        dw $0000,$0000
    endif
endmacro

macro credits_write_new_line()
    dw $0000
endmacro

pushpc
    ;# Always load ENG files
    ;org $BAB86D
    ;    db $80
    org $BAB90B
        db "````", $00, $00, $00
        %credits_write_line("DONKEY KONG COUNTRY 2", $08)
        %credits_write_line("FOR ARCHIPELAGO", $08)
        %credits_write_line("VERSION 3.0.0", $08)
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_line("DEVELOPER", $08)
        %credits_write_line("LX5", $10)
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_line("LOGIC", $08)
        %credits_write_line("VASH VARKET", $10)
        %credits_write_line("SHINY", $10)
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_line("BETA TESTERS", $08)
        %credits_write_line("VASH VARKET", $10)
        %credits_write_line("SHINY", $10)
        %credits_write_line("M.", $10)
        %credits_write_line("BIG BRAWLER", $10)
        %credits_write_line("CARLD923", $10)
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_line("TRIVIA", $08)
        %credits_write_line("ANONIMATO", $10)
        %credits_write_line("BETHANY", $10)
        %credits_write_line("CARLD923", $10)
        %credits_write_line("CAT", $10)
        %credits_write_line("GIGA OTOMIA", $10)
        %credits_write_line("IVANSWORD", $10)
        %credits_write_line("JERRYERIS", $10)
        %credits_write_line("LOLOGURU", $10)
        %credits_write_line("LX5", $10)
        %credits_write_line("M.", $10)
        %credits_write_line("SHINY", $10)
        %credits_write_line("MENTHOLEUS", $10)
        %credits_write_line("MITTYVEE", $10)
        %credits_write_line("MOONBEAM FUNK", $10)
        %credits_write_line("RAINDROPDRY", $10)
        %credits_write_line("SUPER STAR EARTH", $10)
        %credits_write_line("VASH VARKET", $10)
        %credits_write_line("YINYARN", $10)
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_line("SPECIAL THANKS", $08)
        %credits_write_line("P4PLUS2", $10)
        %credits_write_line("H4V0C21", $10)
        %credits_write_line("MASAKARIPLZ", $10)
        %credits_write_line("RAINBOWSPRINKLEZ", $10)
        %credits_write_line("MATTRIZZLE", $10)
        %credits_write_line("BLAHBLAHBLAHYESBLAHBLAH", $10)
        %credits_write_line("RASPBERRYFLOOF", $10)
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
        %credits_write_new_line()
	    db $62, "````", $00, $00, $00, $00, $00
        db $61
        print "CREDITS: $", pc,"/$BAC0D1"
        padbyte $00
        pad $BAC0D1
        db $63
    assert pc() <= $BAC0D2
pullpc