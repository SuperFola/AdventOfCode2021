import day03, unittest

suite "AOC day 03":
    setup:
        let lines: seq[string] = @[
            "00100",
            "11110",
            "10110",
            "10111",
            "10101",
            "01111",
            "00111",
            "11100",
            "10000",
            "11001",
            "00010",
            "01010"
        ]

    test "Part 1":
        check part1(lines) == 198

    test "Part 2":
        check part2(lines) == 230