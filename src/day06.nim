import utils

import std/[strutils, sequtils, strformat, tables]

proc evolve(lines: seq[string], until: int): int =
    var fishes = initTable[int, int]()
    for daysToLive in lines.join("").split(",").map(parseInt):
        fishes[daysToLive] = fishes.getOrDefault(daysToLive, 0) + 1
    for i in 0 .. 8:
        discard fishes.hasKeyOrPut(i, 0)

    for day in 0 ..< until:
        var temp: int = fishes[0]
        for i in 1 .. 8:
            fishes[i - 1] = fishes[i]
        # handle 0 here
        fishes[8] = temp
        fishes[6] += temp

    return fishes.values().toSeq().foldl(a + b)

proc part1*(lines: seq[string]): int =
    return evolve(lines, 80)

proc part2*(lines: seq[string]): int =
    return evolve(lines, 256)

when isMainModule:
    let lines = parseInput("06")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
