import utils
import std/strformat, std/strutils, std/sequtils

type Bit = tuple[zeros: int, ones: int]

proc retrieveBit(t: Bit, condition: string): string =
    var rs: int
    case condition
    of "min":
        rs = min(t.zeros, t.ones)
    of "max":
        rs = max(t.zeros, t.ones)

    if rs == t.zeros:
        return "0"
    else:
        return "1"

proc getMostCommon(lines: seq[string]): seq[Bit] =
    var bits: seq[Bit]

    for bin in lines:
        for i, bit in bin:
            if i >= bits.len:
                bits.add((zeros: 0, ones: 0))

            case bit:
            of '0':
                inc bits[i].zeros
            of '1':
                inc bits[i].ones
            else:
                discard

    return bits

proc part1*(lines: seq[string]): int =
    let
        bits = getMostCommon(lines)
        gammaRate = bits.map(proc(t: Bit): string = return retrieveBit(t, "max")).join("").parseBinInt
        epsilonRate = bits.map(proc(t: Bit): string = return retrieveBit(t, "min")).join("").parseBinInt

    return gammaRate * epsilonRate

proc filter(bits: seq[string], common: seq[Bit], cmp: string, index: int = 0): string =
    let
        mostCommon = if common[index].ones >= common[index].zeros: '1' else: '0'
        leastCommon = if common[index].ones >= common[index].zeros: '0' else: '1'
        newSeq = bits.filter(proc(x: string): bool =
            if cmp == ">":
                return x[index] == mostCommon
            else:
                return x[index] == leastCommon
        )

    if newSeq.len() == 1:
        return newSeq[0]
    else:
        return newSeq.filter(getMostCommon(newSeq), cmp, index + 1)

proc part2*(lines: seq[string]): int =
    let
        common = getMostCommon(lines)
        oxygen = lines.filter(common, ">").parseBinInt
        co2 = lines.filter(common, "<").parseBinInt

    # oxygen: most common bit for each position or 1
    # co2: least common bit for each position or 0

    return oxygen * co2

when isMainModule:
    let lines = parseInput("03")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"