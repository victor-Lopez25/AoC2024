package day1

import "core:strings"
import "core:strconv"
import "core:slice"
import "core:fmt"
import "core:os"

main :: proc()
{
	data, ok := os.read_entire_file("day1/input.txt");
	assert(ok, "Could not read input file");
	
	lines := strings.split(string(data), "\n");
	
	list1 := make([]int, len(lines));
	list2 := make([]int, len(lines));
	
	for lineIdx := 0; lineIdx < len(lines); lineIdx += 1
	{
		line := lines[lineIdx];
		n: int;
		list1[lineIdx], _ = strconv.parse_int(line, 0, &n);
		list2[lineIdx], _ = strconv.parse_int(strings.trim_space(line[n:]));
	}
	
	slice.sort(list1);
	slice.sort(list2);
	
	total: int;
	for i := 0; i < len(lines); i += 1
	{
		/* part 1 */
		//total += abs(list1[i] - list2[i]);
		
		num := list1[i];
		multiplier := 0;
		for j := 0; j < len(lines); j += 1
		{
			if list2[j] == num do multiplier += 1;
			else if list2[j] > num do break;
		}
		
		total += num*multiplier;
	}
	
	fmt.println(total);
}