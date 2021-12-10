import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

proc getPoints(c: char): int =
    case c:
    of ')': return 3
    of ']': return 57
    of '}': return 1197
    of '>': return 25137
    else: return 0

proc getChunkScore(chunk: string): int =
    var
        tempScore = 0
        expected: seq[char]

    for c in chunk:
        case c:
        of '(':
            expected.add(')')
        of ')':
            if expected[^1] != ')':
                tempScore += getPoints(c)
                break
            else:
                expected = expected[0 ..< ^1]
        of '[':
            expected.add(']')
        of ']':
            if expected[^1] != ']':
                tempScore += getPoints(c)
                break
            else:
                expected = expected[0 ..< ^1]
        of '{':
            expected.add('}')
        of '}':
            if expected[^1] != '}':
                tempScore += getPoints(c)
                break
            else:
                expected = expected[0 ..< ^1]
        of '<':
            expected.add('>')
        of '>':
            if expected[^1] != '>':
                tempScore += getPoints(c)
                break
            else:
                expected = expected[0 ..< ^1]
        else:
            discard

    return tempScore

proc part1*(lines: seq[string]): int =
    # focus on the corrupted chunks (wrong ending)
    var
        parsed = lines.filter(x => not x.isEmptyOrWhitespace())
        score = 0

    for chunk in parsed:
        score += getChunkScore(chunk)

    return score


proc part2*(lines: seq[string]): int =
    # focus on the incomplete lines and discard the corrupted ones
    var
        parsed = lines.filter(x => not x.isEmptyOrWhitespace())
        incomplete: seq[string]
        scores: seq[int]

    # retrieve the incomplete chunks only
    for chunk in parsed:
        if getChunkScore(chunk) == 0:
            incomplete.add(chunk)

    for chunk in incomplete:
        var expected: seq[char]

        for c in chunk:
            case c:
            of '(':
                expected.add(')')
            of ')':
                if expected[^1] == ')':
                    expected = expected[0 ..< ^1]
            of '[':
                expected.add(']')
            of ']':
                if expected[^1] == ']':
                    expected = expected[0 ..< ^1]
            of '{':
                expected.add('}')
            of '}':
                if expected[^1] == '}':
                    expected = expected[0 ..< ^1]
            of '<':
                expected.add('>')
            of '>':
                if expected[^1] == '>':
                    expected = expected[0 ..< ^1]
            else:
                discard

        var tempScore = 0

        for idx in countdown(expected.len() - 1, 0):
            let missing = expected[idx]

            tempScore *= 5
            case missing:
            of ')': tempScore += 1
            of ']': tempScore += 2
            of '}': tempScore += 3
            of '>': tempScore += 4
            else: discard

        scores.add(tempScore)

    return scores.sorted()[(scores.len() - 1) div 2]

when isMainModule:
    let lines = parseInput("10")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
