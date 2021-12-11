import utils

import std/[strutils, sequtils, sugar, strformat]

proc simulate(parsed: var seq[seq[int]]): int =
    var
        flashMap = parsed.map(x => x.map(y => false))
        flashCount = 0
    let
        height = parsed.len()
        width = parsed[0].len()

    for y, line in parsed:
        for x, energy in line:
            inc parsed[y][x]

    while true:
        for y, line in parsed:
            for x, energy in line:
                if energy > 9 and not flashMap[y][x]:
                    flashMap[y][x] = true
                    # flash
                    if x > 0:
                        inc parsed[y][x - 1]
                        if y > 0:
                            inc parsed[y - 1][x - 1]
                    if y > 0:
                        inc parsed[y - 1][x]
                        if x + 1 < width:
                            inc parsed[y - 1][x + 1]
                    if x + 1 < width:
                        inc parsed[y][x + 1]
                        if y + 1 < height:
                            inc parsed[y + 1][x + 1]
                    if y + 1 < height:
                        inc parsed[y + 1][x]
                        if x > 0:
                            inc parsed[y + 1][x - 1]
        # while we can still flash
        let
            currentFlash = flashMap.map(x => x.count(true)).foldl(a + b)
            canFlash = parsed.map(x => x.map(y => (if y > 9: -1 else: y))).map(x => x.count(-1)).foldl(a + b)
        if currentFlash == canFlash:
            break

    flashMap = flashMap.map(x => x.map(y => false))

    for y, line in parsed:
        for x, energy in line:
            if energy > 9:
                parsed[y][x] = 0
                inc flashCount

    return flashCount

proc part1*(lines: seq[string]): int =
    var
        parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.map(charAsInt))
        flashCount = 0

    for i in 0 ..< 100:
        flashCount += simulate(parsed)

    return flashCount


proc part2*(lines: seq[string]): int =
    var
        parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.map(charAsInt))
        step = 0
    let octoCount = parsed.len() * parsed[0].len()

    while true:
        let flashCount = simulate(parsed)
        inc step

        if flashCount == octoCount:
            return step

when isMainModule:
    let lines = parseInput("11")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
