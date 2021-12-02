import day01
import day02

import unittest

suite "AOC day 01":
    setup:
        let lines: seq[int] = @[199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

    test "Part 1":
        check part1(lines) == 7

    test "Part 2":
        check part2(lines) == 5

suite "AOC day 02":
    setup:
        let lines: seq[seq[string]] = @[
            @["forward", "5"],
            @["down", "5"],
            @["forward", "8"],
            @["up", "3"],
            @["down", "8"],
            @["forward", "2"]
        ]

    test "Part 1":
        check part1(lines) == 150

    test "Part 2":
        check part2(lines) == 900