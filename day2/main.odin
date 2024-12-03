package day2

import "core:strings"
import "core:strconv"
import "core:fmt"
import "core:os"

// ignore is index to ignore
isValid :: proc "contextless"(report: [dynamic]int, ignore := -1) -> bool
{
	valid := true;
	increasing := 0; // undecided = 0, inc = 1, dec = -1
	start := 1 if ignore != 0 else 2;
	diff: int;
	
	for j := start; j < len(report); j += 1
	{
		if j == ignore {
			continue;
		}
		if j - 1 == ignore {
			diff = report[j] - report[j - 2];
		}
		else {
			diff = report[j] - report[j - 1];
		}
		
		if ((abs(diff) > 3 || abs(diff) < 1) ||
				(increasing == 1 && diff < 0) ||
				(increasing == -1 && diff > 0)) {
			valid = false;
			break;
		}
		increasing = 1 if diff > 0 else -1;
	}
	
	return valid;
}

main :: proc()
{
	data, ok := os.read_entire_file("day2/input.txt");
	assert(ok, "Could not read input file");
	
	lines := strings.split(string(data), "\n");
	
	reports := make([][dynamic]int, len(lines));
	
	for lineIdx := 0; lineIdx < len(lines); lineIdx += 1
	{
		line := lines[lineIdx];
		
		temp: int;
		n := -1;
		for {
			if n+1 > len(line) do break;
			line = line[n + 1:];
			temp, ok = strconv.parse_int(line, 0, &n);
			append(&reports[lineIdx], temp);
		}
	}
	
	numValid := 0;
	
	for i := 0; i < len(lines); i += 1
	{
		report := reports[i];
		
		valid := isValid(report);
		
		for j := 0; j < len(report) && !valid; j += 1
		{
			valid = isValid(report, j);
		}
		
		fmt.println(report, "valid?", valid);
		
		if valid do numValid += 1;
	}
	
	fmt.println(numValid);
}