import day11, unittest, strutils

suite "AOC day 11":
    setup:
        let lines: seq[string] = (dedent """
            5483143223
            2745854711
            5264556173
            6141336146
            6357385478
            4167524645
            2176841721
            6882881134
            4846848554
            5283751526
        """).splitLines()

    test "Part 1":
        check part1(lines) == 1656

    test "Part 2":
        check part2(lines) == 195