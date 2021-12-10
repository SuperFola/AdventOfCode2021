import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

proc getPoints(c: char): int =
    case c:
    of ')': return 3
    of ']': return 57
    of '}': return 1197
    of '>': return 25137
    else: return 0

proc part1*(lines: seq[string]): int =
    # focus on the corrupted chunks (wrong ending)
    var
        parsed = lines.filter(x => not x.isEmptyOrWhitespace())
        score = 0

    for chunk in parsed:
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

        score += tempScore

    return score


proc part2*(lines: seq[string]): int =
    return 0

when isMainModule:
    let lines = parseInput("10")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
