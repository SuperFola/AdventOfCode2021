import utils
import strutils, sequtils

let lines = parseInput("01").map(parseInt)
var previous = lines[0]
var countLargerThanPrev = 0

for num in lines:
    if num > previous:
        inc countLargerThanPrev
    previous = num

echo countLargerThanPrev