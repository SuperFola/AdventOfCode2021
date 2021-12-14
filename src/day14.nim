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
                count = currentPolymer[pair]
            newPolymer.inc(newPair1, count)
            newPolymer.inc(newPair2, count)

        currentPolymer = newPolymer

    var elements = initCountTable[char]()
    for pair, count in currentPolymer:
        elements.inc(pair[1], count)
    elements.inc(polymer[0])

    let counts = sorted(elements.values.toSeq, Descending)
    return counts[0] - counts[^1]

proc part1*(lines: seq[string]): int =
    return simulate(lines, 10)


proc part2*(lines: seq[string]): int =
    return simulate(lines, 40)

when isMainModule:
    let lines = parseInput("14")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
