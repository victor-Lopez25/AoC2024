package day8

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

AntennaNode :: struct {
	freq: u8,
	pos: [2]int,
}

CheckForAntinodes :: proc(antinodes: ^map[[2]int]u8, a1, a2: AntennaNode, width, height: int)
{
	diff := [2]int{a1.pos.x - a2.pos.x, a1.pos.y - a2.pos.y};
	pos := a1.pos;
	for pos.x >= 0 && pos.y >= 0 && 
		pos.x < width && pos.y < height
	{
		pos -= diff;
	}
	pos += diff;
	
	for pos.x >= 0 && pos.y >= 0 && 
		pos.x < width && pos.y < height
	{
		if !(pos in antinodes^) {
			antinodes[pos] = a1.freq;
		}
		pos += diff;
	}
}

main :: proc()
{
	data := #load("bginput.txt", string);
	
	lines := strings.split_lines(data);
	width := len(lines[0]);
	height := len(lines);
	antennae: [dynamic]AntennaNode;
	
	for y := 0; y < height; y += 1
	{
		for x := 0; x < width; x += 1
		{
			if lines[y][x] != '.' {
				append(&antennae, AntennaNode{lines[y][x], {x, y}});
			}
		}
	}
	
	for node in antennae {
		fmt.printfln("freq = %c, pos = %v", node.freq, node.pos);
	}
	
	antinodes: map[[2]int]u8;
	
	// part 2
	for i := 0; i < len(antennae); i += 1
	{
		for j := 0; j < len(antennae); j += 1
		{
			if i == j do continue;
			for k := 0; k < len(antennae); k += 1
			{
				if i == k || j == k do continue;
				
				a1 := antennae[i];
				a2 := antennae[j];
				a3 := antennae[k];
				if a1.freq == a2.freq && a2.freq == a3.freq
				{
					CheckForAntinodes(&antinodes, a1, a2, width, height);
					CheckForAntinodes(&antinodes, a1, a3, width, height);
					CheckForAntinodes(&antinodes, a2, a3, width, height);
				}
			}
		}
	}
	
	for i := 0; i < len(antennae); i += 1
	{
		for j := 0; j < len(antennae); j += 1
		{
			if i == j do continue;
			
			if antennae[i].freq == antennae[j].freq {
				x1, x2, y1, y2: int;
				if antennae[i].pos.x > antennae[j].pos.x {
					x1 = antennae[j].pos.x - abs(antennae[i].pos.x - antennae[j].pos.x);
					x2 = antennae[i].pos.x + abs(antennae[i].pos.x - antennae[j].pos.x);
				}
				else {
					x1 = antennae[i].pos.x - abs(antennae[i].pos.x - antennae[j].pos.x);
					x2 = antennae[j].pos.x + abs(antennae[i].pos.x - antennae[j].pos.x);
				}
				
				if antennae[i].pos.y > antennae[j].pos.y {
					y1 = antennae[j].pos.y - abs(antennae[i].pos.y - antennae[j].pos.y);
					y2 = antennae[i].pos.y + abs(antennae[i].pos.y - antennae[j].pos.y);
				}
				else {
					y1 = antennae[i].pos.y - abs(antennae[i].pos.y - antennae[j].pos.y);
					y2 = antennae[j].pos.y + abs(antennae[i].pos.y - antennae[j].pos.y);
				}
				
				pos1, pos2: [2]int;
				if antennae[i].pos.x > antennae[j].pos.x {
					if antennae[i].pos.y > antennae[j].pos.y {
						pos1 = {x1,y1};
						pos2 = {x2,y2};
						if x1 >= 0 && y1 >= 0 && !(pos1 in antinodes) {
							antinodes[pos1] = antennae[i].freq;
						}
						if x2 < width && y2 < height && !(pos2 in antinodes) {
							antinodes[pos2] = antennae[i].freq;
						}
					}
					else {
						pos1 = {x2, y1};
						pos2 = {x1, y2};
						if x2 < width && y1 >= 0 && !(pos1 in antinodes) {
							antinodes[pos1] = antennae[i].freq;
						}
						if x1 >= 0 && y2 < height && !(pos2 in antinodes) {
							antinodes[pos2] = antennae[i].freq;
						}
					}
				}
				else {
					if antennae[i].pos.y > antennae[j].pos.y {
						pos1 = {x2, y1};
						pos2 = {x1, y2};
						if x2 < width && y1 >= 0 && !(pos1 in antinodes) {
							antinodes[pos1] = antennae[i].freq;
						}
						if x1 >= 0 && y2 < height && !(pos2 in antinodes) {
							antinodes[pos2] = antennae[i].freq;
						}
					}
					else {
						// same as first condition, could swap pos1 & pos2 but result would be the same
						pos1 = {x1,y1};
						pos2 = {x2,y2};
						if x1 >= 0 && y1 >= 0 && !(pos1 in antinodes) {
							antinodes[pos1] = antennae[i].freq;
						}
						if x2 < width && y2 < height && !(pos2 in antinodes) {
							antinodes[pos2] = antennae[i].freq;
						}
					}
				}
			}
		}
	}
	
	fmt.println(antinodes);
	/*for anode in antinodes {
		fmt.printfln("%v", anode);
	}*/
	fmt.println(len(antinodes));
	delete(lines);
}