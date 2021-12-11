import strutils

proc parseInput*(day: string): seq[string] =
    let content = readFile("input/" & day & ".txt").strip()
    return content.splitLines()

proc charAsInt*(c: char): int =
    case c:
    of '0': return 0
    of '1': return 1
    of '2': return 2
    of '3': return 3
    of '4': return 4
    of '5': return 5
    of '6': return 6
    of '7': return 7
    of '8': return 8
    of '9': return 9
    else: return 0