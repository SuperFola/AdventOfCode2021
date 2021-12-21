import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm, options]

type
    Position = object
        x: int
        y: int
        z: int
    Beacon = object
        x: int
        y: int
        z: int
    Scanner = object
        id: int
        beacons: seq[Beacon]

proc parseInput(lines: seq[string]): seq[Scanner] =
    var
        scanners: seq[Scanner]
        temp: Scanner

    let
        scannerBeginTag = "--- scanner "
        scannerEndTag = " ---"

    for line in lines:
        if line.isEmptyOrWhitespace():
            scanners.add temp
        elif line.startsWith(scannerBeginTag):
            let num = line[scannerBeginTag.len .. ^(scannerEndTag.len + 1)]
            temp = Scanner(id: num.parseInt, beacons: @[])
        else:
            let coords = line.split(",").map(x => x.parseInt())
            temp.beacons.add Beacon(x: coords[0], y: coords[1], z: coords[2])

    return scanners

proc match(master: seq[Beacon], slave: seq[Beacon]): Option[Position] =
    return some(Position(x: 0, y: 0, z: 0))

proc part1*(lines: seq[string]): int =
    var scanners = parseInput(lines)
    let reference = scanners[0]

    for scanner in scanners[1 .. ^1]:
        let match = match(reference.beacons, scanner.beacons)

    return 0

proc part2*(lines: seq[string]): int =
    var scanners = parseInput(lines)
    return 0

when isMainModule:
    let lines = parseInput("19")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
