@echo off

set opts=-debug -vet-style

odin build %cd%/day5 -out:AoC.exe %opts%
AoC.exe