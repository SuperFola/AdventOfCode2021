import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

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
    var
        parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.map(y => charAsInt(y) + 1))
        uid = 1

    # init board
    for y, line in parsed:
        for x, level in line:
            if level == 10:
                # 0 will be the "do not touch" mark
                parsed[y][x] = 0
            else:
                # 1 will be the "not marked" mark
                parsed[y][x] = 1

    # begin marking
    for y, line in parsed:
        for x, level in line:
            if level >= 1:
                var
                    oldX = if x > 0: parsed[y][x - 1] else: 0
                    oldY = if y > 0: parsed[y - 1][x] else: 0
                let predecessor = if oldX != 0 and oldY != 0: min(oldX, oldY) elif oldX == 0: oldY else: oldX

                if predecessor != 0:
                    parsed[y][x] = predecessor
                else:
                    parsed[y][x] = uid
                    inc uid

    for y in countdown(parsed.len() - 1, 0):
        let line = parsed[y]
        for x in countdown(line.len() - 1, 0):
            let level = line[x]

            if level > 0:
                var
                    oldX = if x != line.len() - 1: parsed[y][x + 1] else: 0
                    oldY = if y != parsed.len() - 1: parsed[y + 1][x] else: 0
                let predecessor = if oldX != 0 and oldY != 0: min(oldX, oldY) elif oldX == 0: oldY else: oldX

                if predecessor > 0 and parsed[y][x] != predecessor:
                    parsed[y][x] = predecessor

    for y in 0 ..< parsed.len():
        let line = parsed[y]
        for x in 0 ..< line.len():
            let level = line[x]

            if level > 0:
                var
                    oldX = if x > 0: parsed[y][x - 1] else: 0
                    oldY = if y > 0: parsed[y - 1][x] else: 0
                let predecessor = if oldX != 0 and oldY != 0: min(oldX, oldY) elif oldX == 0: oldY else: oldX

                if predecessor > 0 and parsed[y][x] != predecessor:
                    parsed[y][x] = predecessor

    let bassinsSizes = parsed.foldl(concat(a, b)).toCountTable
    let filtered = bassinsSizes.pairs().toSeq().filter(proc(x: (int, int)): bool = return x[0] != 0)
    return filtered.map(x => x[1]).sorted(Descending)[0 ..< 3].foldl(a * b)

when isMainModule:
    let lines = parseInput("09")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
