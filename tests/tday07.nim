import day07, unittest, strutils

suite "AOC day 07":
    setup:
        let lines: seq[string] = (dedent """
            16,1,2,0,4,2,7,1,2,14
        """).splitLines()

    test "Part 1":
        check part1(lines) == 37

    test "Part 2":
        check part2(lines) == 0