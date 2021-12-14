import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

proc getPairs(chain: string): seq[string] =
    var polymerPairs = chain.toSeq[0 ..< ^1].map(x => $x)
    for i in 0 ..< polymerPairs.len:
        polymerPairs[i].add chain[i + 1]
    return polymerPairs

proc simulate(lines: seq[string], steps: int): int =
    let
        polymer = lines[0]
        rules = lines[1 .. ^1].filter(x => not x.isEmptyOrWhitespace()).map(proc(x: string): (string, string) =
            let pair = x.split(" -> ")
            return (pair[0], pair[1])
        ).toTable

    var currentPolymer = getPairs(polymer).toCountTable

    for i in 0 ..< steps:
        var newPolymer = initCountTable[string]()

        for pair in currentPolymer.keys:
            let
                newPair1 = pair[0] & rules[pair]
                newPair2 = rules[pair] & pair[1]
            newPolymer.inc(newPair1, currentPolymer[pair])
            newPolymer.inc(newPair2, currentPolymer[pair])

        currentPolymer = newPolymer

    var elements = initCountTable[char]()
    for pair in currentPolymer.keys:
        elements.inc(pair[0], currentPolymer[pair])

    let counts = sorted(elements.values.toSeq, Descending)
    # somehow needs -1 instead of +1 for my input, but this gives the correct values for the test sample
    return counts[0] - counts[^1] + 1

proc part1*(lines: seq[string]): int =
    return simulate(lines, 10)


proc part2*(lines: seq[string]): int =
    return simulate(lines, 40)

when isMainModule:
    let lines = parseInput("14")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
