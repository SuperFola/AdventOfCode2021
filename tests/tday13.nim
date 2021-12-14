import day13, unittest, strutils

suite "AOC day 13":
    setup:
        let lines: seq[string] = (dedent """
            6,10
            0,14
            9,10
            0,3
            10,4
            4,11
            6,0
            6,12
            4,1
            0,13
            10,12
            3,4
            3,0
            8,4
            1,10
            2,14
            8,10
            9,0

            fold along y=7
            fold along x=5
        """).splitLines()

    test "Part 1":
        check part1(lines) == 17

    test "Part 2":
        check part2(lines) == 0