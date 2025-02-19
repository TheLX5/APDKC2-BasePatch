del "%~dp0dkc2_basepatch.sfc"
del "%~dp0dkc2_basepatch.bsdiff4"
copy /b/v/y "%~dp0Donkey Kong Country 2 - Diddy's Kong Quest (USA) (En,Fr) (Rev 1).sfc" "%~dp0dkc2_basepatch.sfc"

asar.exe parche.asm "dkc2_basepatch.sfc"
python generate_bsdiff.py "Donkey Kong Country 2 - Diddy's Kong Quest (USA) (En,Fr) (Rev 1).sfc" "dkc2_basepatch.sfc"

python parse_questions.py

copy /b/v/y "%~dp0dkc2_basepatch.bsdiff4" "A:\Archipelago\worlds\dkc2\data\dkc2_basepatch.bsdiff4"