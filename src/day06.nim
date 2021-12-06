import utils

import std/[strutils, sequtils, strformat, sugar]

type Fish = object
    daysUntilSpawn: int
    currentDays: int
    isNew: bool

proc part1*(lines: seq[string]): int =
    var fishes = lines.join("").split(",").map(parseInt).map(x => Fish(daysUntilSpawn: x, currentDays: x, isNew: false))
    var temp: seq[Fish]

    for day in 0 ..< 80:
        for i, fish in fishes:
            if fish.currentDays == 0:
                fishes[i] = Fish(daysUntilSpawn: 6, currentDays: 6, isNew: false)
                temp.add(
                    Fish(daysUntilSpawn: 8, currentDays: 8, isNew: true)
                )
            else:
                fishes[i] = Fish(daysUntilSpawn: fish.daysUntilSpawn, currentDays: fish.currentDays - 1, isNew: false)

        for fish in temp:
            fishes.add(fish)
        temp.setLen(0)

        # echo "After " & $(day + 1) & " days:\t" & fishes.map(x => $x.currentDays).join(",")

    return fishes.len()

proc part2*(lines: seq[string]): int =
    return 0

when isMainModule:
    let lines = parseInput("06")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
