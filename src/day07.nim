import utils

import std/[strutils, sequtils, strformat, sugar, tables]

proc part1*(lines: seq[string]): int =
    var
        crabs = initTable[int, int]()
        fuels = initTable[int, int]()

    for pos in lines.join("").split(",").map(parseInt):
        crabs[pos] = crabs.getOrDefault(pos, 0) + 1

    let maxPos = crabs.keys().toSeq().max()
    for i in 0 .. maxPos:
        for pos in crabs.keys():
            let count = crabs[pos]
            fuels[i] = fuels.getOrDefault(i, 0) + abs(i - pos) * count

    var sorted = fuels.pairs().toSeq().toOrderedTable()
    sorted.sort(proc (x, y: (int, int)): int = cmp(x[1], y[1]))
    return sorted[sorted.keys().toSeq()[0]]

proc part2*(lines: seq[string]): int =
    return 0

when isMainModule:
    let lines = parseInput("07")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
