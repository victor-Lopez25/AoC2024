package day7

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

Operator :: enum {
	Add,
	Mul,
	Concat,
	
	Count_Operators,
}

PART_ONE :: false

main :: proc()
{
	data := #load("bginput.txt", string);
	
	itoaBuf: [64]u8;
	concatBuilder: strings.Builder;
	
	totalCalibration: u128;
	operands: [dynamic]u128;
	operatorChooser: [dynamic]Operator;
	for line in strings.split_lines_iterator(&data)
	{
		line := line;
		clear(&operands);
		clear(&operatorChooser);
		n: int;
		testVal, _ := strconv.parse_u128(line, 10, &n);
		
		line = line[n+2:]; // skip ': '
		t, _ := strconv.parse_u128(line, 10, &n);
		append(&operands, t);
		append(&operatorChooser, Operator.Add);
		
		for {
			line = line[n+1:]; // skip space
			t, _ = strconv.parse_u128(line, 10, &n);
			append(&operands, t);
			append(&operatorChooser, Operator.Add);
			if n + 1 >= len(line) do break;
		}
		
		when PART_ONE {
			for i := 0; i < (1 << uint(len(operands))) - 1; i += 1
			{
				// if I is 0 -> sum else -> mul
				total := operands[0];
				for j : uint = 1; j < len(operands); j += 1
				{
					//if i & pow2[j] == 0 {
					if i & (1 << j) == 0 {
						total += operands[j];
					}
					else {
						total *= operands[j];
					}
				}
				if total == testVal {
					totalCalibration += testVal;
					break;
				}
			}
		}
        else {
            for i := 0; operatorChooser[len(operatorChooser) - 1] == .Add; i += 1
            {
                total := operands[0];
                for j := 1; j < len(operands); j += 1
                {
                    switch operatorChooser[j - 1] {
                        case .Add: total += operands[j];
                        case .Mul: total *= operands[j];
                        case .Concat: {
                            // NOTE: This was something I found in the aoc reddit.
                            // I don't think there's a pow for integers in the Odin standard library though
                            //newVal := operands[j]*10^math.ceil(math.log(operands[j-1], 10)) + operands[j-1];
                            s1 := strconv.append_u128(itoaBuf[:], total, 10);
                            s2 := strconv.append_u128(itoaBuf[len(s1):], operands[j], 10);
                            
                            total, _ = strconv.parse_u128(string(itoaBuf[:len(s1)+len(s2)]), 10, &n);
                        }
                        
                        case .Count_Operators: {}
                    }
                }
                
                if total == testVal {
                    totalCalibration += testVal;
                    break;
                }
                
                operatorChooser[0] += Operator(1);
                for idx := 1;; idx += 1
                {
                    if operatorChooser[idx - 1] != .Count_Operators do break;
                    operatorChooser[idx - 1] = .Add;
                    operatorChooser[idx] += Operator(1);
                }
            }
        }
	}
	
	fmt.println(totalCalibration);
	delete(operands);
}