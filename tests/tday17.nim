import day17, unittest, strutils

suite "AOC day 17":
    setup:
        let lines: seq[seq[int]] = @[@[20, 30], @[-5, -10]]

    test "Part 1":
        check part1(lines) == 45

    test "Part 2":
        check part2(lines) == 112