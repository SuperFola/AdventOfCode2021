import day09, unittest, strutils

suite "AOC day 09":
    setup:
        let lines: seq[string] = (dedent """
            2199943210
            3987894921
            9856789892
            8767896789
            9899965678
        """).splitLines()

    test "Part 1":
        check part1(lines) == 15

    test "Part 2":
        check part2(lines) == 0