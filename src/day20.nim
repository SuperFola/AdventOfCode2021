import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm, options]

proc pixelsToInt(pixels: seq[char]): int =
    return pixels.map(x => (if x == '.': '0' else: '1')).join("").parseBinInt

proc getLine(y: int, x: int, image: seq[string], emptyChar: char): seq[char] =
    let width = image[0].len

    for i in -1 .. 1:
        if x + i >= 0 and x + i < width:
            result.add image[y][x + i]
        else:
            result.add emptyChar

proc enhance(image: seq[string], algorithm: string, emptyChar: char): seq[string] =
    var
        output: seq[string]
        pixels: seq[char]
        times = 6
        filling = emptyChar.repeat(times)
        bigger = image.map(x => filling & x & filling)

    let empty = @[emptyChar.repeat(bigger[0].len)]
    for i in 1 .. times:
        bigger = concat(empty, bigger, empty)
    let height = bigger.len

    for y, line in bigger:
        var tempLine: seq[char]

        for x, pix in line:
            # first line
            if y == 0:
                pixels = pixels.concat emptyChar.repeat(3).toSeq
            else:
                pixels = pixels.concat getLine(y - 1, x, bigger, emptyChar)
            # second line
            pixels = pixels.concat getLine(y, x, bigger, emptyChar)
            # last line
            if y == height - 1:
                pixels = pixels.concat emptyChar.repeat(3).toSeq
            else:
                pixels = pixels.concat getLine(y + 1, x, bigger, emptyChar)

            tempLine.add algorithm[pixels.pixelsToInt]
            pixels = @[]
        output.add tempLine.join("")

    return output

proc part1*(lines: seq[string]): int =
    let
        algorithm = lines[0]
        image = lines[2 .. ^1].filter(x => not x.isEmptyOrWhitespace())

    let
        first = image.enhance(algorithm, '.')
        twice = first.enhance(algorithm, algorithm[0])

    return twice.join("").count('#')

proc part2*(lines: seq[string]): int =
    let
        algorithm = lines[0]
        image = lines[2 .. ^1].filter(x => not x.isEmptyOrWhitespace())

    var newImage = image.enhance(algorithm, '.')
    for i in 1 .. 49:
        var pixels: seq[char]
        for y in 0 .. 2:
            for x in 0 .. 2:
                pixels.add newImage[y][x]

        newImage = newImage.enhance(algorithm, algorithm[pixels.pixelsToInt])

    return newImage.join("").count('#')

when isMainModule:
    let lines = parseInput("20")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
