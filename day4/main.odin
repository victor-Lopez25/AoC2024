package day4

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
	data := #load("input.txt", string);
	runes: [dynamic]rune;
	
	lines := strings.split_lines(data);
	width := len(lines[0]);
	height := len(lines);
	
	counter := 0;
	
	// horizontal
	for y := 0; y < height; y += 1
	{
		for x := 0; x < width - len("XMAS") + 1; x += 1
		{
			if lines[y][x:x+4] == "XMAS" || lines[y][x:x+4] == "SAMX" {
				counter += 1;
			}
		}
	}
	
	// vertical
	for x := 0; x < width; x += 1
	{
		for y := 0; y < height - len("XMAS") + 1; y += 1
		{
			if lines[y][x] == 'X' && lines[y+1][x] == 'M' &&
				lines[y+2][x] == 'A' && lines[y+3][x] == 'S'
			{
				counter += 1;
				//fmt.printfln("up to down (%d, %d)", x, y);
			}
			else if lines[y][x] == 'S' && lines[y+1][x] == 'A' &&
				lines[y+2][x] == 'M' && lines[y+3][x] == 'X'
			{
				counter += 1;
				//fmt.printfln("down to up (%d, %d)", x, y);
			}
		}
	}
	
	// southeast
	for y := 0; y < height - len("XMAS") + 1; y += 1
	{
		for x := 0; x < width - len("XMAS") + 1; x += 1
		{
			if data[y*(width+1) + x] == 'X' && data[(y + 1)*(width+1) + x + 1] == 'M' &&
				data[(y + 2)*(width+1) + x + 2] == 'A' && data[(y + 3)*(width+1) + x + 3] == 'S'
			{
				counter += 1;
				//fmt.printfln("southeast (%d, %d)", x, y);
			}
			else if data[y*(width+1) + x] == 'S' && data[(y + 1)*(width+1) + x + 1] == 'A' &&
				data[(y + 2)*(width+1) + x + 2] == 'M' && data[(y + 3)*(width+1) + x + 3] == 'X'
			{
				counter += 1;
				//fmt.printfln("northwest (%d, %d)", x, y);
			}
		}
	}
	
	// southwest
	for y := 0; y < height - len("XMAS") + 1; y += 1
	{
		for x := len("XMAS") - 1; x < width; x += 1
		{
			if data[y*(width+1) + x] == 'X' && data[(y + 1)*(width+1) + x - 1] == 'M' &&
				data[(y + 2)*(width+1) + x - 2] == 'A' && data[(y + 3)*(width+1) + x - 3] == 'S'
			{
				counter += 1;
			}
			else if data[y*(width+1) + x] == 'S' && data[(y + 1)*(width+1) + x - 1] == 'A' &&
				data[(y + 2)*(width+1) + x - 2] == 'M' && data[(y + 3)*(width+1) + x - 3] == 'X'
			{
				counter += 1;
			}
		}
	}
	
	fmt.println(counter);
	
	// X-MAS
	counter = 0;
	
	// southeast
	for y := 0; y < height - len("MAS") + 1; y += 1
	{
		for x := 0; x < width - len("MAS") + 1; x += 1
		{
			if lines[y][x] == 'M' && lines[y+1][x+1] == 'A' && lines[y+2][x+2] == 'S'
			{
				if lines[y][x+2] == 'M' && lines[y+1][x+1] == 'A' && lines[y+2][x] == 'S'
				{
					counter += 1;
				}
				else if lines[y][x+2] == 'S' && lines[y+1][x+1] == 'A' && lines[y+2][x] == 'M'
				{
					counter += 1;
				}
			}
			else if lines[y][x] == 'S' && lines[y+1][x+1] == 'A' && lines[y+2][x+2] == 'M'
			{
				if lines[y][x+2] == 'M' && lines[y+1][x+1] == 'A' && lines[y+2][x] == 'S'
				{
					counter += 1;
				}
				else if lines[y][x+2] == 'S' && lines[y+1][x+1] == 'A' && lines[y+2][x] == 'M'
				{
					counter += 1;
				}
			}
		}
	}
	
	fmt.println(counter);
}