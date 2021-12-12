import utils

import std/[strutils, sequtils, sugar, strformat, tables]

# big caves: uppercase
# small caves: lowercase, don't visit them more than once each

type Kind = enum StartCave, EndCave, SmallCave, LargeCave

proc getKind(node: string): Kind =
    if node == "start":
        return StartCave
    elif node == "end":
        return EndCave
    elif node.toLower() == node:
        return SmallCave
    else:
        return LargeCave

proc visit(nodes: Table[string, seq[string]]): int =
    var
        stack: seq[seq[string]]
        paths = 0

    for node in nodes["start"]:
        stack.add @["start", node]

    while stack.len() > 0:
        let
            curPath = stack.pop()
            curNode = curPath[^1]

        for neigh in nodes[curNode]:
            case neigh.getKind():
            of StartCave:
                discard
            of EndCave:
                inc paths
            of LargeCave:
                stack.add(curPath & neigh)
            of SmallCave:
                if neigh notin curPath:
                    stack.add(curPath & neigh)

    return paths

proc part1*(lines: seq[string]): int =
    # find paths that visit small caves at most once

    let parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.split("-"))
    var nodes = initTable[string, seq[string]]()

    for pair in parsed:
        let
            a = pair[0]
            b = pair[1]

        nodes[a] = nodes.getOrDefault(a, @[]) & b
        nodes[b] = nodes.getOrDefault(b, @[]) & a

    return visit(nodes)


proc part2*(lines: seq[string]): int =
    return 0

when isMainModule:
    let lines = parseInput("12")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
