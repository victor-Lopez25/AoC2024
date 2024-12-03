@echo off

set opts=-debug -vet-style

odin build %cd%/day3 -out:AoC.exe %opts%
AoC.exe