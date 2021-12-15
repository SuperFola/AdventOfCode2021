# Package

version       = "0.1.0"
author        = "Alexandre Plateau"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @[
  "day01",
  "day02",
  "day03",
  "day04",
  "day05",
  "day06",
  "day07",
  "day08",
  "day09",
  "day10",
  "day11",
  "day12",
  "day13",
  "day14",
  "day15"
]


# Dependencies

requires "nim >= 1.6.0"


# Tasks

task test, "Runs the test suite":
  exec "nim c --outdir:build/ -d:release -r tests/tester.nim"