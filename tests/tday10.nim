import day10, unittest, strutils

suite "AOC day 10":
    setup:
        let lines: seq[string] = (dedent """
            [({(<(())[]>[[{[]{<()<>>
            [(()[<>])]({[<{<<[]>>(
            {([(<{}[<>[]}>{[]{[(<()>
            (((({<>}<{<{<>}{[]{[]{}
            [[<[([]))<([[{}[[()]]]
            [{[{({}]{}}([{[{{{}}([]
            {<[[]]>}<{[{[{[]{()[[[]
            [<(<(<(<{}))><([]([]()
            <{([([[(<>()){}]>(<<{{
            <{([{{}}[<[[[<>{}]]]>[]]
        """).splitLines()

    test "Part 1":
        check part1(lines) == 26397

    test "Part 2":
        check part2(lines) == 288957