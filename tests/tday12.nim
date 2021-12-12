import day12, unittest, strutils

suite "AOC day 12":
    setup:
        let lines: seq[string] = (dedent """
            start-A
            start-b
            A-c
            A-b
            b-d
            A-end
            b-end
        """).splitLines()

    test "Part 1":
        check part1(lines) == 10

    test "Part 2":
        check part2(lines) == 0