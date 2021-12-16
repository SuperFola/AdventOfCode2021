import day16, unittest, strutils

suite "AOC day 16":
    setup:
        let lines1: seq[string] = (dedent """
            8A004A801A8002F478
            620080001611562C8802118E34
            C0015000016115A2E0802F182340
            A0016C880162017C3686B18A3D4780
        """).splitLines()
        let lines2: seq[string] = (dedent """
            C200B40A82
            04005AC33890
            880086C3E88112
            CE00C43D881120
            D8005AC2A8F0
            F600BC2D8F
            9C005AC2F8F0
            9C0141080250320F1802104A08
        """).splitLines()

    test "Part 1":
        check part1(lines1) == (16 + 12 + 23 + 31)

    test "Part 2":
        check part2(lines2) == @[3, 54, 7, 9, 1, 0, 0, 1]