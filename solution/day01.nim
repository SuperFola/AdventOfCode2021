import utils

import strutils, sequtils, math
import std/strformat

proc part1(lines: seq[int]): int =
    var previous = lines[0]
    var countLargerThanPrev = 0

    for num in lines:
        if num > previous:
            inc countLargerThanPrev
        previous = num

    return countLargerThanPrev

proc part2(lines: seq[int]): int =
    var
        countLargerThanPrev = 0
        previous = -1

    for windowIndex in countup(0, lines.len - 1):
        let upper = min(windowIndex + 2, lines.len - 1)
        let window = lines[windowIndex .. upper]

        if previous != -1 and window.sum > previous:
            inc countLargerThanPrev
        previous = window.sum

    return countLargerThanPrev

let lines = parseInput("01").map(parseInt)
echo fmt"Part1: {part1(lines)}"
echo fmt"Part2: {part2(lines)}"
