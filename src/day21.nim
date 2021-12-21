import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm, options]

proc part1*(lines: seq[string]): int =
    let positions = lines.filter(x => not x.isEmptyOrWhitespace()).map(parseInt)
    var
        player1 = positions[0]
        player2 = positions[1]
        score1 = 0
        score2 = 0
        dice = 1
        rollCount = 0

    while true:
        var roll = 3 * (1 + dice)
        dice += 3
        rollCount += 3

        player1 = ((player1 + roll - 1) mod 10) + 1
        score1 += player1
        if score1 >= 1000:
            break

        roll = 3 * (1 + dice)
        dice += 3
        rollCount += 3

        player2 = ((player2 + roll - 1) mod 10) + 1
        score2 += player2
        if score2 >= 1000:
            break

    return rollCount * min(score1, score2)

proc part2*(lines: seq[string]): int =
    let positions = lines.filter(x => not x.isEmptyOrWhitespace()).map(parseInt)
    var
        player1 = positions[0]
        player2 = positions[1]
        score1 = 0
        score2 = 0
        dice = 1
        rollCount = 0

    while true:
        var roll = 3 * (1 + dice)
        dice += 3
        rollCount += 3

        player1 = ((player1 + roll - 1) mod 10) + 1
        score1 += player1
        if score1 >= 21:
            break

        roll = 3 * (1 + dice)
        dice += 3
        rollCount += 3

        player2 = ((player2 + roll - 1) mod 10) + 1
        score2 += player2
        if score2 >= 21:
            break

    return rollCount * min(score1, score2)

when isMainModule:
    let lines = parseInput("21")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
