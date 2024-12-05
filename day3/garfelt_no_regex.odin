package day3

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:slice"
import "core:unicode/utf8"

// my solution with no regex looked ugly as hell, I found this one from @garnfelt which is much prettier

runes_eq_str :: proc(runes : []rune, word : string) -> bool {
    i := 0
    for c in word {
        if runes[i] != c do return false
        i += 1 
    }
    return true
}

main :: proc() {
    data := #load("input.txt", string)
    runes: [dynamic]rune
    for r in data do append(&runes, r);
    // leave 5 characters for look-ahead
    for i in 0..<5 do append(&runes, ' ')

    sum := 0
    j := 0

    skip := false 
    for ; j < len(runes)-5; j +=1 {
        i := j
        if runes_eq_str(runes[i:], "do") do skip = false
        if runes_eq_str(runes[i:], "don't") do skip = true 
        
        if skip {
            i += 1
            continue;
        }

        if runes_eq_str(runes[i:], "mul(") {
            i += 4
            // take until we see a ,
            l1 : [dynamic]rune
            for runes[i] != ',' {
                append(&l1, runes[i])
                i += 1
            }
            // take until we see a )
            i += 1
            l2 : [dynamic]rune
            for runes[i] != ')' {
                append(&l2, runes[i])
                i += 1
            }
            digit1, ok := strconv.parse_int(utf8.runes_to_string(l1[:]))
            digit2, ok2 := strconv.parse_int(utf8.runes_to_string(l2[:]))
            if ok && ok2 do sum += digit1 * digit2
        }
    }
    fmt.println(sum)
}