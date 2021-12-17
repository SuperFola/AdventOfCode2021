import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

proc inRange(val: int, rangeA: int, rangeB: int): bool =
    return rangeA <= val and val <= rangeB

proc simulate(lines: seq[seq[int]], part: 1..2): int =
    var
        maxHeight = 0
        inRange = 0

    let
        targetStartX = lines[0][0]
        targetEndX = lines[0][1]
        targetStartY = lines[1][0]
        targetEndY = lines[1][1]

    for tx in -350 .. 350:
        for ty in -100 .. 100:
            # reset params
            var
                x = 0
                y = 0
                tempMaxHeight = 0
                vx = tx
                vy = ty

            # echo fmt"({tx}, {ty})"
            while true:
                x += vx
                y += vy
                if vx > 0:
                    dec vx
                elif vx < 0:
                    inc vx
                dec vy

                # echo fmt"  x:{x}, y:{y}, {targetStartX}-{targetEndX} {inRange(x, targetStartX, targetEndX)}, {targetStartY}-{targetEndY} {inRange(y, targetEndY, targetStartY)}"

                tempMaxHeight = max(y, tempMaxHeight)

                if inRange(x, targetStartX, targetEndX) and inRange(y, targetEndY, targetStartY):
                    maxHeight = max(maxHeight, tempMaxHeight)
                    inc inRange
                    break
                if x > targetEndX or y < targetEndY:
                    tempMaxHeight = -1
                    break

            # if tempMaxHeight > 0:
            #     echo fmt"({tx}, {ty}), maxHeight {tempMaxHeight}"

    if part == 1:
        return maxHeight
    else:
        return inRange

proc part1*(lines: seq[seq[int]]): int =
    return simulate(lines, 1)

proc part2*(lines: seq[seq[int]]): int =
    return simulate(lines, 2)

when isMainModule:
    let lines = @[@[241, 273], @[-63, -97]]
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
