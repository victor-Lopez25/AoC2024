@echo off

set opts=-debug -vet-style
::set opts=-o:speed -no-bounds-check -no-type-assert

odin build %cd%/day9 -out:AoC.exe %opts%
AoC.exe