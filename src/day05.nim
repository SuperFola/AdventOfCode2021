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
    var
        data = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.split(" -> ").map(y => y.split(",").map(parseInt)))
        crossing = initCountTable[Point]()

    for line in data:
        let
            segStart = (x: line[0][0], y: line[0][1])
            segEnd = (x: line[1][0], y: line[1][1])

        if segStart.x == segEnd.x:
            let
                y1 = min(segStart.y, segEnd.y)
                y2 = max(segStart.y, segEnd.y)
            for y in y1 .. y2:
                crossing.inc((x: segStart.x, y: y))
        elif segStart.y == segEnd.y:
            let
                x1 = min(segStart.x, segEnd.x)
                x2 = max(segStart.x, segEnd.x)
            for x in x1 .. x2:
                crossing.inc((x: x, y: segStart.y))
        else:
            var
                newStart: Point
                newEnd: Point

            if segStart.x < segEnd.x and segStart.y < segEnd.y:
                newStart = segStart
                newEnd = segEnd
            elif segStart.x > segEnd.x and segStart.y > segEnd.y:
                newStart = segEnd
                newEnd = segStart
            elif segStart.x < segEnd.x and segStart.y > segEnd.y:
                newStart = segStart
                newEnd = segEnd
            else:
                newStart = segEnd
                newEnd = segStart

            if newStart.y < newEnd.y:
                for pos in zip((newStart.x .. newEnd.x).toSeq(), (newStart.y .. newEnd.y).toSeq()):
                    let (xd, yd) = pos
                    crossing.inc((x: xd, y: yd))
            else:
                for pos in zip((newStart.x .. newEnd.x).toSeq(), countdown(newStart.y, newEnd.y).toSeq()):
                    let (xd, yd) = pos
                    crossing.inc((x: xd, y: yd))

    return crossing.values().toSeq().filter(x => x >= 2).len()

when isMainModule:
    let lines = parseInput("05")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
