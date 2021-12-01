import strutils

proc parseInput*(day: string): seq[string] =
    let content = readFile("input/" & day & "/input.txt").strip()
    return content.splitLines()
