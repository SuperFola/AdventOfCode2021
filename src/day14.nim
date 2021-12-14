import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

proc simulate(lines: seq[string], steps: int): int =
    let
        polymer = lines[0]
        rules = lines[1 .. ^1].filter(x => not x.isEmptyOrWhitespace()).map(proc(x: string): (string, string) =
            let pair = x.split(" -> ")
            return (pair[0], pair[1])
        ).toTable

    var currentPolymer = polymer

    for i in 0 ..< steps:
        var
            tempPair = ""
            newPolymer = ""

        for j, c in currentPolymer:
            if tempPair.len() <= 1:
                tempPair.add c
            if tempPair.len() == 2:
                newPolymer.add tempPair[0] & rules[tempPair]
                tempPair = "" & tempPair[1]

        currentPolymer = newPolymer & currentPolymer[^1]
        echo "step ", i
        # echo i, ", length: ", currentPolymer.len, " ", currentPolymer, "\n"

    let counts = sorted(currentPolymer.toCountTable.values.toSeq, Descending)
    return counts[0] - counts[^1]

proc part1*(lines: seq[string]): int =
    return simulate(lines, 10)


proc part2*(lines: seq[string]): int =
    return simulate(lines, 40)

when isMainModule:
    let lines = parseInput("14")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
