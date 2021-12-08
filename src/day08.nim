import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

proc part1*(lines: seq[string]): int =
    let parsed = lines.filter(a => not a.isEmptyOrWhitespace()).map(x => x.split("|").map(y => y.split(" ").filter(z => not z.isEmptyOrWhitespace())))

    var uniqueDigits = initCountTable[int]()

    for input in parsed:
        let
            signals = input[0]
            digits = input[1]

        for dig in digits:
            case dig.len():
            of 2:
                uniqueDigits.inc(1)
            of 4:
                uniqueDigits.inc(4)
            of 3:
                uniqueDigits.inc(7)
            of 7:
                uniqueDigits.inc(8)
            else:
                discard

    return uniqueDigits.values().toSeq().foldl(a + b)

proc part2*(lines: seq[string]): int =
    let parsed = lines.filter(a => not a.isEmptyOrWhitespace()).map(x => x.split("|").map(y => y.split(" ").filter(z => not z.isEmptyOrWhitespace())))
    var sum = 0

    for input in parsed:
        let
            signals = input[0]
            digits = input[1]

        var deduced = initTable[int, string]()
        # find 1, 4, 7 and 8
        for sig in signals:
            case sig.len():
            of 2:
                deduced[1] = sig
            of 4:
                deduced[4] = sig
            of 3:
                deduced[7] = sig
            of 7:
                deduced[8] = sig
            else:
                discard

        let
            len5Sigs = signals.filter(x => x.len() == 5)
            len6Sigs = signals.filter(x => x.len() == 6)

        # 3 has 5 segments, with two being common with 1
        for sig in signals:
            let sigOne = deduced[1]
            if sig.len() == 5 and all(sig.toSeq(), x => x in sigOne):
                deduced[3] = sig
                break

        if 3 in deduced:
            # 9 has 6 segments, with each of them being common with 3
            for sig in signals:
                let sigThree = deduced[3]
                if sig.len() == 6 and all(sig.toSeq(), x => x in sigThree):
                    deduced[9] = sig
                    break
            # 0 has 6 segments, with each of them being common with 7, but it's not a 9
            for sig in signals:
                let sigSeven = deduced[7]
                if sig.len() == 6 and sig != deduced[9] and all(sig.toSeq(), x => x in sigSeven):
                    deduced[0] = sig
                    break
            # 6 is the last 6 segments signal
            deduced[6] = len6Sigs.filter(x => x != deduced[0] and x != deduced[9])[0]
        else:
            # we can deduce 6 from 7
            deduced[6] = len6Sigs.filter(x => x.toSeq().map(y => y in deduced[7]).filter(z => z).len() == 2)[0]
            # we can deduce 9 from 4
            deduced[9] = len6Sigs.filter(x => all(deduced[4].toSeq(), y => y in x))[0]
            # 0 is the last 6 segments signal
            deduced[0] = len6Sigs.filter(x => x != deduced[6] and x != deduced[9])[0]

        if 6 in deduced:
            # 5 has each of its segments in common with 6
            deduced[5] = len5Sigs.filter(x => all(x.toSeq(), y => y in deduced[6]))[0]

        if 5 in deduced:
            # deduce 2 and 3 from 9 and 5
            for sub in len5Sigs:
                if sub != deduced[5]:
                    let maskLen = sub.map(x => x in deduced[9]).filter(y => y).len()
                    if maskLen == 4:
                        deduced[2] = sub
                    elif maskLen == 5:
                        deduced[3] = sub

        if 3 in deduced and 5 in deduced:
            # 2 is the remaining 5 segments signal
            deduced[2] = len5Sigs.filter(x => x != deduced[5] and x != deduced[3])[0]

        var inversedDeduced = initTable[string, int]()
        for pair in deduced.pairs():
            let (key, value) = pair
            var sorted = value
            sorted.sort()
            inversedDeduced[sorted] = key

        var output: int = 0
        for i, dig in digits:
            let pow10 = if i == 0: 1000 elif i == 1: 100 elif i == 2: 10 else: 1
            var sorted = dig
            sorted.sort()
            output += pow10 * inversedDeduced[sorted]
        sum += output

    return sum

when isMainModule:
    let lines = parseInput("08")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
