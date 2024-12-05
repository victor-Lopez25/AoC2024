package main

import "core:text/regex"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:fmt"
import "core:os"

main::proc(){
    data, ok := os.read_entire_file("day3/input.txt");
    assert(ok);

    left, right, pos, total: int
    m1regex, regerr := regex.create(`(mul\(\d{1,3},\d{1,3}\))`,{.Global})
    assert(regerr == nil)

    remainder := data;
    for capture in regex.match(m1regex,string(remainder)) {
        defer regex.destroy_capture(capture)
        left, _ = strconv.parse_int(capture.groups[0][4:],0,&pos)
        right, _ = strconv.parse_int(capture.groups[0][5+pos:])
        total += left*right
        //fmt.println(capture.groups[0], ": ", left, "," , right)
        remainder = remainder[capture.pos[0][1]:]
    }

    fmt.println(total)

    m2regex, m2error := regex.create(`(mul\(\d{1,3},\d{1,3}\))|(do\(\))|(don't\(\))`,{.Global})
    assert(m2error == nil)

    total = 0;
    multiplying := true;
    remainder = data;
    for capture in regex.match(m2regex,string(remainder)) {
        defer regex.destroy_capture(capture)
        switch capture.groups[0]{
            case "do()":    multiplying=true;
            case "don't()": multiplying=false;
            case:
                if(multiplying){
                    left, _ = strconv.parse_int(capture.groups[0][4:],0,&pos)
                    right, _ = strconv.parse_int(capture.groups[0][5+pos:])
                    total += left*right
                }
        }
        remainder=remainder[capture.pos[0][1]:]
    }

    fmt.println(total)
}