import day02, unittest

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
        check day02.part1(lines) == 150

    test "Part 2":
        check day02.part2(lines) == 900