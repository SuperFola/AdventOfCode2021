import utils
import strutils, sequtils, math

let lines = parseInput("01").map(parseInt)
var
    countLargerThanPrev = 0
    previous = -1

for windowIndex in countup(0, lines.len - 1):
    let upper = min(windowIndex + 2, lines.len - 1)
    let window = lines[windowIndex .. upper]

    if previous != -1 and window.sum > previous:
        inc countLargerThanPrev
    previous = window.sum

echo countLargerThanPrev