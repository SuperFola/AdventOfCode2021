import day15, unittest, strutils

suite "AOC day 15":
    setup:
        let lines: seq[string] = (dedent """
            1163751742
            1381373672
            2136511328
            3694931569
            7463417111
            1319128137
            1359912421
            3125421639
            1293138521
            2311944581
        """).splitLines()

    test "Part 1":
        check part1(lines) == 40

    test "Part 2":
        check part2(lines) == 315