@echo off

set opts=-debug -vet -vet-using-param -vet-style

odin build %cd%/day2 -out:AoC.exe %opts%
AoC.exe