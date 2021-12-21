import day21, unittest, strutils

suite "AOC day 21":
    setup:
        let lines: seq[string] = (dedent """
            4
            8
        """).splitLines()

    test "Part 1":
        check part1(lines) == 739785

    test "Part 2":
        check part2(lines) == 444356092776315