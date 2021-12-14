import day14, unittest, strutils

suite "AOC day 14":
    setup:
        let lines: seq[string] = (dedent """
            NNCB

            CH -> B
            HH -> N
            CB -> H
            NH -> C
            HB -> C
            HC -> B
            HN -> C
            NN -> C
            BH -> H
            NC -> B
            NB -> B
            BN -> B
            BB -> N
            BC -> B
            CC -> N
            CN -> C
        """).splitLines()

    test "Part 1":
        check part1(lines) == 1588

    test "Part 2":
        check part2(lines) == 2188189693529