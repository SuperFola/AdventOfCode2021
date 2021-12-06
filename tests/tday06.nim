import day06, unittest, strutils

suite "AOC day 06":
    setup:
        let lines: seq[string] = (dedent """
            3,4,3,1,2
        """).splitLines()

    test "Part 1":
        check part1(lines) == 5934

    test "Part 2":
        check part2(lines) == 26984457539