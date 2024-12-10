package day9

import "core:fmt"
import "core:slice"
import "core:strconv"
import "core:strings"

PartOne :: proc(expandedDiskMap: ^[]u32, exIdx: int)
{
	endIdx := exIdx - 1;
	startIdx := 0;
	for endIdx > startIdx
	{
		if expandedDiskMap[endIdx] == EMPTY_ID {
			endIdx -= 1;
			continue;
		}
		
		if expandedDiskMap[startIdx] == EMPTY_ID {
			temp := expandedDiskMap[endIdx];
			expandedDiskMap[endIdx] = expandedDiskMap[startIdx];
			expandedDiskMap[startIdx] = temp;
			startIdx += 1;
			endIdx -= 1;
		}
		else {
			startIdx += 1;
		}
	}
}

// WARNING: Do not print bginput result on windows since it'll be too big (could be at most 200_000 characters)
PrintDisk :: proc(expandedDiskMap: ^[]ID, exIdx: int)
{
	for i := 0; i < exIdx; i += 1 {
		if expandedDiskMap[i] == EMPTY_ID {
			fmt.print('.', flush = false);
		} else {
			fmt.print(expandedDiskMap[i], flush = false);
		}
	}
	fmt.println(flush = true);
}

// better than what is asked :(
BetterPack :: proc(expandedDiskMap: ^[]ID, idSizes: []SizeNIndex, idIdx: ID, emptySizes: ^[dynamic]SizeNIndex)
{
	for i := int(idIdx) - 1; i > 0; i -= 1
	{
		for j := 0; j < len(emptySizes); j += 1
		{
			if idSizes[i].size <= emptySizes[j].size && idSizes[i].diskIdx > emptySizes[j].diskIdx {
				startIdx := emptySizes[j].diskIdx;
				moveIdx := idSizes[i].diskIdx;
				idSizes[i].diskIdx = startIdx + u32(idSizes[i].size) - 1;
				emptySizes[j].size -= idSizes[i].size;
				emptySizes[j].diskIdx += u32(idSizes[i].size);
				if emptySizes[j].size == 0 {
					ordered_remove(emptySizes, j);
				}
				found := false;
				for k := 0; k < len(emptySizes); k += 1
				{
					checkIdx := int(emptySizes[k].diskIdx) + 
						int(emptySizes[k].size) + int(idSizes[i].size) - 1;
					if checkIdx == int(moveIdx) {
						found = true;
						emptySizes[k].size += idSizes[i].size;
						
						idx_check := u32(int(moveIdx) + 1);
						idx := -1;
						for e, l in emptySizes[:] {
							if e.diskIdx == idx_check {
								idx = l;
								break;
							}
						}
						if idx != -1 {
							emptySizes[k].size += emptySizes[idx].size;
							ordered_remove(emptySizes, idx);
						}
						
						break;
					}
				}
				if !found {
					append(emptySizes, SizeNIndex{u32(int(moveIdx) - int(idSizes[i].size) + 1), idSizes[i].size});
				}
				
				for k := 0; k < int(idSizes[i].size); k += 1
				{
					temp := expandedDiskMap[startIdx];
					expandedDiskMap[startIdx] = expandedDiskMap[moveIdx];
					expandedDiskMap[moveIdx] = temp;
					startIdx += 1;
					moveIdx -= 1;
				}
				
				j = -1;
				i = int(idIdx) - 1;
			}
		}
	}
}

SizeNIndex :: struct {
	diskIdx: u32,
	size: u8,
}

ID :: u32
EMPTY_ID :: 0xFFFFFFFF

main :: proc()
{
	diskMap := #load("bginput.txt", string);
	
	// if all characters of the disk are 9 length, it would expand 9*len(diskMap)
	expandedDiskMap := make([]ID, 10*len(diskMap));
	
	idSizes := make([]SizeNIndex, len(diskMap));
	emptySizes: [dynamic]SizeNIndex;
	
	// expand
	exIdx := 0;
	idIdx : ID = 0;
	for i := 0; i < len(diskMap); i += 1
	{
		if i % 2 == 0 {
			for j := 0; j < int(diskMap[i] - '0'); j += 1
			{
				expandedDiskMap[exIdx] = idIdx;
				exIdx += 1;
			}
			if diskMap[i] - '0' > 0 {
				idSizes[idIdx] = {u32(exIdx - 1), diskMap[i] - '0'};
			}
			idIdx += 1;
		}
		else {
			if diskMap[i] - '0' > 0 {
				append(&emptySizes, SizeNIndex{u32(exIdx), diskMap[i] - '0'});
			}
			for j := 0; j < int(diskMap[i] - '0'); j += 1
			{
				expandedDiskMap[exIdx] = EMPTY_ID;
				exIdx += 1;
			}
		}
	}
	
	//slice.sort_by(idSizes, szidx_less);
	//slice.sort_by(emptySizes, szidx_less);
	//fmt.println(idSizes);
	//fmt.println(emptySizes);
	
	//PrintDisk(&expandedDiskMap, exIdx);
	
	// pack
	for i := int(idIdx) - 1; i > 0; i -= 1
	{
		for j := 0; j < len(emptySizes); j += 1
		{
			if idSizes[i].size <= emptySizes[j].size && idSizes[i].diskIdx > emptySizes[j].diskIdx {
				startIdx := emptySizes[j].diskIdx;
				moveIdx := idSizes[i].diskIdx;
				idSizes[i].diskIdx = startIdx + u32(idSizes[i].size) - 1;
				emptySizes[j].size -= idSizes[i].size;
				emptySizes[j].diskIdx += u32(idSizes[i].size);
				if emptySizes[j].size == 0 {
					ordered_remove(&emptySizes, j);
				}
				
				for k := 0; k < int(idSizes[i].size); k += 1
				{
					temp := expandedDiskMap[startIdx];
					expandedDiskMap[startIdx] = expandedDiskMap[moveIdx];
					expandedDiskMap[moveIdx] = temp;
					startIdx += 1;
					moveIdx -= 1;
				}
				
				j = -1;
				//i = int(idIdx) - 1;
			}
		}
	}
	
	/*
				endIdx := exIdx - 1;
				sstartIdx := 0;
				for i := 0; i < exIdx; i += 1 {
					if expandedDiskMap[i] == '.' {
						sstartIdx = i;
						break;
					}
				}
				moveId := expandedDiskMap[endIdx];
				for endIdx > sstartIdx
				{
					startIdx := sstartIdx;
					moveIdx := endIdx;
					countContiguousSpace := 0;
					for startIdx < exIdx
					{
						if expandedDiskMap[startIdx] == '.' {
							countContiguousSpace += 1;
							if countContiguousSpace == idSizes[moveId] {
								startIdx -= countContiguousSpace;
								for j := 0; j < countContiguousSpace; j += 1
								{
									temp := expandedDiskMap[startIdx];
									expandedDiskMap[startIdx] = expandedDiskMap[moveIdx];
									expandedDiskMap[moveIdx] = temp;
									startIdx += 1;
									moveIdx -= 1;
								}
							}
						}
						else {
							countContiguousSpace = 0;
						}
					}
					if expandedDiskMap[moveIdx] == moveId {
						for expandedDiskMap[moveIdx] == moveId {
							moveIdx += 1;
						}
					}
					for expandedDiskMap[moveIdx] == EMPTY_ID {
						moveIdx += 1;
					}
				}
					*/
	
	//PartOne(&expandedDiskMap, exIdx);
	
	//PrintDisk(&expandedDiskMap, exIdx);
	
	checkSum := 0;
	for i := 1; i < exIdx; i += 1
	{
		if expandedDiskMap[i] != EMPTY_ID {
			checkSum += i*int(expandedDiskMap[i]);
		}
	}
	
	fmt.println(checkSum);
}