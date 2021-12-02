import "../solution/day01"

import unittest

suite "AOC day 01":
    setup:
        let lines: seq[int] = @[199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

    test "Part 1":
        check part1(lines) == 7

    test "Part 2":
        check part2(lines) == 5