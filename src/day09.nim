import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

proc charAsInt(c: char): int =
    case c:
    of '0': return 0
    of '1': return 1
    of '2': return 2
    of '3': return 3
    of '4': return 4
    of '5': return 5
    of '6': return 6
    of '7': return 7
    of '8': return 8
    of '9': return 9
    else: return 0

proc checkAt(x: int, y: int, data: seq[seq[int]], level: int): bool =
    let
        height = data.len()
        width = data[0].len()

    var
        couldCheck = 0
        checked = 0

    if x > 0:
        inc couldCheck
        if data[y][x - 1] > level:
            inc checked
    if y > 0:
        inc couldCheck
        if data[y - 1][x] > level:
            inc checked
    if y + 1 < height:
        inc couldCheck
        if data[y + 1][x] > level:
            inc checked
    if x + 1 < width:
        inc couldCheck
        if data[y][x + 1] > level:
            inc checked

    return couldCheck == checked

proc part1*(lines: seq[string]): int =
    let
        parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.map(charAsInt))
    var riskLevel = 0

    for y, line in parsed:
        for x, level in line:
            if checkAt(x, y, parsed, level):
                riskLevel += 1 + level

    return riskLevel

proc part2*(lines: seq[string]): int =
    return 0

when isMainModule:
    let lines = parseInput("09")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
