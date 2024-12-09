package day6

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"
import "core:mem"
import "core:os"

Direction :: enum {
	Left,
	Right,
	Up,
	Down,
}

PreviousPos :: struct {
	data: u8, // 'X' or 0 or '#'
	dirs: [4]bool,
}

OUT_TO_FILE :: false

when OUT_TO_FILE {
	file: os.Handle;
	PrintMap :: proc(data: []PreviousPos, width, height: int)
	{
		for y := 0; y < height; y += 1
		{
			for x := 0; x < width; x += 1
			{
				if data[y*width + x].data == 0 {
					fmt.fprint(file, " ", flush=false);
				}
				else {
					fmt.fprintf(file, "%c", data[y*width + x].data, flush=false);
				}
			}
			fmt.fprint(file, "\n", flush=false);
		}
	}
}

HandleNextObstacle :: proc(lines: []string, width, height, guardX, guardY: i32, guardDir: ^Direction, extraObstaclePos: [2]i32) -> bool
{
	changedDir := false;
	switch guardDir^ {
		case .Left: {
			if (guardX > 0 &&
					(extraObstaclePos.x == guardX - 1 && extraObstaclePos.y == guardY ||
					 lines[guardY][guardX - 1] == '#'))
			{
				changedDir = true;
				guardDir^ = .Up;
			}
		}
		case .Right: {
			if (guardX < width - 1 && 
					(extraObstaclePos.x == guardX + 1 && extraObstaclePos.y == guardY ||  
					 lines[guardY][guardX + 1] == '#'))
			{
				changedDir = true;
				guardDir^ = .Down;
			}
		}
		case .Up: {
			if (guardY > 0 &&
					(extraObstaclePos.x == guardX && extraObstaclePos.y == guardY - 1 || lines[guardY - 1][guardX] == '#'))
			{
				changedDir = true;
				guardDir^ = .Right;
			}
		}
		case .Down: {
			if (guardY < height - 1 &&
					(extraObstaclePos.x == guardX && extraObstaclePos.y == guardY + 1 || lines[guardY + 1][guardX] == '#'))
			{
				changedDir = true;
				guardDir^ = .Left;
			}
		}
	}
	
	return changedDir;
}

main :: proc()
{
	data := #load("input.txt", string);
	
	ferr: os.Error;
	when OUT_TO_FILE {
		file, ferr = os.open("log.txt", os.O_WRONLY | os.O_CREATE | os.O_TRUNC);
		defer os.close(file);
	}
	
	lines := strings.split_lines(data);
	width := i32(len(lines[0]));
	height := i32(len(lines));
	
	outData := make([]PreviousPos, width*height);
	
	initialGuardDir: Direction;
	initguardPos: [2]i32;
	
	for y : i32 = 0; y < height; y += 1
	{
		for x : i32 = 0; x < width; x += 1
		{
			switch(lines[y][x]) {
				case '<': {
					initguardPos = {x,y};
					initialGuardDir = .Left;
					break;
				}
				case '>': {
					initguardPos = {x,y};
					initialGuardDir = .Right;
					break;
				}
				case '^': {
					initguardPos = {x,y};
					initialGuardDir = .Up;
					break;
				}
				case 'v': {
					initguardPos = {x,y};
					initialGuardDir = .Down;
					break;
				}
			}
		}
	}
	
	extraObstaclePos: [2]i32;
	loopCounter := 0;
	for y : i32 = 0; y < height; y += 1
	{
		for x : i32 = 0; x < width; x += 1
		{
			if lines[y][x] == '#' do continue;
			if x == initguardPos.x && y == initguardPos.y do continue;
			
			extraObstaclePos = {x,y};
			mem.set(raw_data(outData), 0, int(width*height*size_of(outData[0])));
			guardX := initguardPos.x;
			guardY := initguardPos.y;
			guardDir := initialGuardDir;
			
			loop := false;
			// Move guard
			for guardX < width && guardX >= 0 && guardY < height && guardY >= 0
			{
				//mutableLineData := transmute([]u8)lines[guardY];
				//mutableLineData[guardX] = 'X';
				when OUT_TO_FILE do outData[guardY*width + guardX].data = 'X';
				
				if outData[guardY*width + guardX].dirs[guardDir] {
					// went into a loop
					loopCounter += 1;
					loop = true;
					break;
				}
				outData[guardY*width + guardX].dirs[guardDir] = true;
				
				changedDir := 
					HandleNextObstacle(lines, width, height, guardX, guardY, &guardDir, extraObstaclePos);
				if !changedDir {
					switch guardDir {
						case .Left: guardX -= 1;
						case .Right: guardX += 1;
						case .Up: guardY -= 1;
						case .Down: guardY += 1;
					}
				}
			}
			
			when OUT_TO_FILE {
				outData[y*width + x].data = 'O';
				if loop {
					fmt.fprintf(file, "(%d, %d):\n", x, y, flush=true);
					PrintMap(outData, width, height);
				}
			}
		}
	}
	
	when OUT_TO_FILE do fmt.fprint(file, "\n", flush=true);
	
	// part 1 counter, not useful in part 2
	/*counter := 0;
	for y := 0; y < height; y += 1
	{
		for x := 0; x < width; x += 1
		{
			if outData[y*width + x].data == 'X' {
				counter += 1;
			}
		}
	}*/
	
	fmt.println(loopCounter);
}