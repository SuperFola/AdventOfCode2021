import utils

import std/[strutils, sequtils, strformat, tables]

proc findCrabRave(lines: seq[string], addLinear: bool): int =
    var
        crabs = initTable[int, int]()
        fuels = initTable[int, int]()

    for pos in lines.join("").split(",").map(parseInt):
        crabs[pos] = crabs.getOrDefault(pos, 0) + 1

    let maxPos = crabs.keys().toSeq().max()
    for i in 0 .. maxPos:
        for pos in crabs.keys():
            let
                count = crabs[pos]
                n = abs(i - pos)
                val = if addLinear: n else: (n * (n + 1)) div 2
            fuels[i] = fuels.getOrDefault(i, 0) + val * count

    var sorted = fuels.pairs().toSeq().toOrderedTable()
    sorted.sort(proc (x, y: (int, int)): int = cmp(x[1], y[1]))
    return sorted[sorted.keys().toSeq()[0]]

proc part1*(lines: seq[string]): int =
    return findCrabRave(lines, true)

proc part2*(lines: seq[string]): int =
    return findCrabRave(lines, false)

when isMainModule:
    let lines = parseInput("07")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
