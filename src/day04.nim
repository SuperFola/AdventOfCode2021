import utils

import std/strutils, std/sequtils, std/strformat, std/sugar

type
    Bingo = object
        numbers: seq[int]
        boards: seq[seq[int]]

proc parseBingo(lines: seq[string]): Bingo =
    let num = lines[0].split(",").map(parseInt)
    var boards: seq[seq[int]]

    for line in lines[1 .. ^1]:
        if line.isEmptyOrWhitespace():
            boards.add(@[])
        else:
            for el in line.split(" ").map(x => x.strip()).filter(x => not x.isEmptyOrWhitespace()).map(parseInt):
                boards[^1].add(el)

    return Bingo(numbers: num, boards: boards.filter(x => x.len() != 0))

proc markNumber(num: int, board: seq[int]): seq[int] =
    var copy = board
    for i, el in copy:
        if el == num:
            copy[i] = -1
    return copy

proc column(board: seq[int], index: int): seq[int] =
    return @[
        board[index],
        board[index + 5],
        board[index + 10],
        board[index + 15],
        board[index + 20]
    ]

proc isWinning(board: seq[int]): bool =
    if board.len() == 5:
        return board.count(-1) == 5

    return isWinning(board[0 ..< 5]) or
        isWinning(board[5 ..< 10]) or
        isWinning(board[10 ..< 15]) or
        isWinning(board[15 ..< 20]) or
        isWinning(board[20 ..< 25]) or
        isWinning(board.column(0)) or
        isWinning(board.column(1)) or
        isWinning(board.column(2)) or
        isWinning(board.column(3)) or
        isWinning(board.column(4))

proc part1*(lines: seq[string]): int =
    var
        bingo = parseBingo(lines)
        winning = 0

    block playing:
        for num in bingo.numbers:
            for i, board in bingo.boards:
                bingo.boards[i] = markNumber(num, board)
                if bingo.boards[i].isWinning():
                    winning = num * bingo.boards[i].filter(x => x != -1).foldl(a + b)
                    break playing

    return winning

proc part2*(lines: seq[string]): int =
    var
        bingo = parseBingo(lines)
        winningBoards: seq[int]
        losing = 0

    block playing:
        for num in bingo.numbers:
            for i, board in bingo.boards:
                bingo.boards[i] = markNumber(num, board)
                if bingo.boards[i].isWinning():
                    if not winningBoards.contains(i):
                        winningBoards.add(i)
                    # we have the last winning board
                    if winningBoards.len() == bingo.boards.len():
                        losing = num * bingo.boards[i].filter(x => x != -1).foldl(a + b)
                        break playing

    return losing

when isMainModule:
    let lines = parseInput("04")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
