import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm, options]

let hexTable = {
    "0": "0000",
    "1": "0001",
    "2": "0010",
    "3": "0011",
    "4": "0100",
    "5": "0101",
    "6": "0110",
    "7": "0111",
    "8": "1000",
    "9": "1001",
    "A": "1010",
    "B": "1011",
    "C": "1100",
    "D": "1101",
    "E": "1110",
    "F": "1111"
}.toTable

type
    LitteralValue = int
    Operator = object
        length: int
        subpackets: seq[Packet]
    Packet = object
        version: int
        typeId: int
        value: Option[LitteralValue]
        operator: Option[Operator]
        bitsCount: int

proc parsePacket(bits: string): Packet =
    var packet = Packet(
        version: bits[0 .. 2].parseBinInt,
        typeId: bits[3 .. 5].parseBinInt,
        value: none(LitteralValue),
        operator: none(Operator),
        bitsCount: 0,
    )

    if packet.typeId == 4:
        var
            num: seq[string]
            lastGroup = false

        for i, c in bits[6 .. ^1]:
            if i mod 5 == 0:
                if not lastGroup:
                    num.add ""
                    if c == '0':
                        lastGroup = true
                else:
                    break
            else:
                num[^1].add $c

        packet.bitsCount = 3 + 3 + num.map(x => x.len + 1).foldl(a + b)
        packet.value = some(num.join("").parseBinInt.LitteralValue)
    else:  # typeId == 6
        # operator
        let
            lenBit = if bits[6] == '0': 15 else: 11
            litteral = bits[7 ..< 7 + lenBit].parseBinInt
        packet.bitsCount = 3 + 3 + 1 + lenBit

        var subpackets: seq[Packet]
        if lenBit == 15:
            var usedBits = 0
            while usedBits != litteral:
                let sub = parsePacket(bits[packet.bitsCount .. ^1])
                subpackets.add sub
                usedBits += sub.bitsCount
                packet.bitsCount += sub.bitsCount
        else:
            # lenBit == 11, number of packets
            var usedPackets = 0
            while usedPackets != litteral:
                let sub = parsePacket(bits[packet.bitsCount .. ^1])
                subpackets.add sub
                packet.bitsCount += sub.bitsCount
                inc usedPackets

        packet.operator = some(Operator(
            length: lenBit,
            subpackets: subpackets,
        ))

    return packet

proc sumVersion(p: Packet): int =
    var s = p.version
    if p.typeId != 4:
        # operator
        for sub in p.operator.get().subpackets:
            s += sumVersion(sub)
    return s

proc eval(p: Packet): int =
    if p.typeId == 4:
        return p.value.get()

    case p.typeId:
    of 0:
        return p.operator.get().subpackets.map(x => x.eval).foldl(a + b)
    of 1:
        return p.operator.get().subpackets.map(x => x.eval).foldl(a * b)
    of 2:
        let sub = p.operator.get().subpackets.map(x => x.eval)
        var m = sub[0]
        for v in sub[1 .. ^1]:
            if v < m:
                m = v
        return m
    of 3:
        let sub = p.operator.get().subpackets.map(x => x.eval)
        var m = sub[0]
        for v in sub[1 .. ^1]:
            if v > m:
                m = v
        return m
    of 5:
        let
            sub = p.operator.get().subpackets
            a = sub[0].eval
            b = sub[1].eval
        return if a > b: 1 else: 0
    of 6:
        let
            sub = p.operator.get().subpackets
            a = sub[0].eval
            b = sub[1].eval
        return if a < b: 1 else: 0
    of 7:
        let
            sub = p.operator.get().subpackets
            a = sub[0].eval
            b = sub[1].eval
        return if a == b: 1 else: 0
    else:
        discard

proc part1*(lines: seq[string]): int =
    let packets = lines.filter(x => not x.isEmptyOrWhitespace())
    var sum = 0

    for p in packets:
        let
            bits = p.map(x => hexTable[$x]).join("")
            parsed = parsePacket(bits)

        sum += parsed.sumVersion

    return sum

proc part2*(lines: seq[string]): seq[int] =
    let packets = lines.filter(x => not x.isEmptyOrWhitespace())
    var evaluated: seq[int]

    for p in packets:
        let
            bits = p.map(x => hexTable[$x]).join("")
            parsed = parsePacket(bits)

        evaluated.add parsed.eval

    return evaluated

when isMainModule:
    let lines = parseInput("16")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)[0]}"
