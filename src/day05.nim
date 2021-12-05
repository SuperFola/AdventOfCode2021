import utils

import std/[strutils, sequtils, strformat, sugar, tables]

type Point = tuple[x: int, y: int]

proc part1*(lines: seq[string]): int =
    # only horizontal lines or vertical lines

    var
        data = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.split(" -> ").map(y => y.split(",").map(parseInt)))
        crossing = initCountTable[Point]()

    for line in data:
        let
            segStart = (x: min(line[0][0], line[1][0]), y: min(line[0][1], line[1][1]))
            segEnd = (x: max(line[0][0], line[1][0]), y: max(line[0][1], line[1][1]))

        if segStart.x == segEnd.x:
            for y in segStart.y .. segEnd.y:
                crossing.inc((x: segStart.x, y: y))
        elif segStart.y == segEnd.y:
            for x in segStart.x .. segEnd.x:
                crossing.inc((x: x, y: segStart.y))

    return crossing.values().toSeq().filter(x => x >= 2).len()

proc part2*(lines: seq[string]): int =
    return 0

when isMainModule:
    let lines = parseInput("05")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
