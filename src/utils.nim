import strutils

proc parseInput*(day: string): seq[string] =
    let content = readFile("input/" & day & ".txt").strip()
    return content.splitLines()
