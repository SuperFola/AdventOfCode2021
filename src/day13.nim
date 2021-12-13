import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm]

type
    Axis = enum AxisX, AxisY
    Fold = object
        axis: Axis
        pos: int
    Paper = object
        dots: seq[tuple[x: int, y: int]]
        folds: seq[Fold]

proc parseInput(lines: seq[string]): Paper =
    var
        parsed: Paper
        lineIndex = 0

    for line in lines:
        if line.isEmptyOrWhitespace():
            inc lineIndex
            break
        let xy = line.split(",").map(parseInt)
        parsed.dots.add((xy[0], xy[1]))
        inc lineIndex

    for foldData in lines[lineIndex .. ^1]:
        if foldData.isEmptyOrWhitespace():
            break

        let
            inst = foldData["fold along ".len .. ^1].split("=")
            axis = if inst[0] == "x": AxisX else: AxisY
            pos  = parseInt(inst[1])

        parsed.folds.add(Fold(axis: axis, pos: pos))

    return parsed

proc fold(dot: tuple[x: int, y: int], fold: Fold): tuple[x: int, y: int] =
    result = dot

    case fold.axis:
    of AxisX:
        if dot.x > fold.pos:
            result = (x: 2 * fold.pos - dot.x, y: dot.y)
    of AxisY:
        if dot.y > fold.pos:
            result = (x: dot.x, y: 2 * fold.pos - dot.y)


proc visibleDots(paper: Paper): int =
    for dot in paper.dots:
        if dot.x >= 0 and dot.y >= 0:
            inc result

proc part1*(lines: seq[string]): int =
    var paper = parseInput(lines)
    let fold = paper.folds[0]

    for i, dot in paper.dots:
        paper.dots[i] = dot.fold(fold)

    paper.dots = paper.dots.toCountTable.keys.toSeq
    return paper.visibleDots


proc part2*(lines: seq[string]): int =
    var paper = parseInput(lines)

    for fold in paper.folds:
        for i, dot in paper.dots:
            paper.dots[i] = dot.fold(fold)

    proc cmpY(d, e: tuple[x: int, y: int]): int =
        result = d.y - e.y
        if result == 0:
            result = d.x - e.x

    paper.dots = sorted(paper.dots.toCountTable.keys.toSeq, cmpY)

    var
        di = 0
        output = ""

    for sy in 0 .. 7:
        for sx in 0 .. 50:
            if di < paper.dots.len and paper.dots[di] == (x: sx, y: sy):
                output.add "#"
                inc di
            else:
                output.add " "
        output.add "\n"

    echo output

    return 0

when isMainModule:
    let lines = parseInput("13")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
