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
  "day07"
]


# Dependencies

requires "nim >= 1.6.0"


# Tasks

task test, "Runs the test suite":
  exec "nim c --outdir:build/ -r tests/tester.nim"