import utils

import std/strutils, std/sequtils, std/strformat

proc part1*(lines: seq[seq[string]]): int =
    var
        depth = 0
        horizontal = 0

    for inst in lines:
        let
            direction = inst[0]
            count = parseInt(inst[1])

        case direction:
        of "forward":
            horizontal += count
        of "down":
            depth += count
        of "up":
            depth -= count

    return depth * horizontal

proc part2*(lines: seq[seq[string]]): int =
    var
        aim = 0
        depth = 0
        horizontal = 0

    for inst in lines:
        let
            direction = inst[0]
            count = parseInt(inst[1])

        case direction:
        of "forward":
            horizontal += count
            depth += aim * count
        of "down":
            aim += count
        of "up":
            aim -= count

    return depth * horizontal

when isMainModule:
    let lines = parseInput("02").map(proc(s: string): seq[string] = s.split(" "))
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
