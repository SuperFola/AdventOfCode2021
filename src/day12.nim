import utils

import std/[strutils, sequtils, sugar, strformat, tables]

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

proc visit(nodes: Table[string, seq[string]], part: 1 .. 2): int =
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
                case part:
                of 1:
                    if neigh notin curPath:
                        stack.add(curPath & neigh)
                of 2:
                    let
                        smallCaves = curPath.filter(x => x.getKind() == SmallCave)
                        countSmall = smallCaves.toCountTable.values.toSeq
                    if (neigh notin curPath) or (countSmall.filter(x => x > 1).len() == 0):
                        stack.add(curPath & neigh)

    return paths

proc createNodes(lines: seq[string]): Table[string, seq[string]] =
    let parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.split("-"))
    var nodes = initTable[string, seq[string]]()

    for pair in parsed:
        let
            a = pair[0]
            b = pair[1]

        nodes[a] = nodes.getOrDefault(a, @[]) & b
        nodes[b] = nodes.getOrDefault(b, @[]) & a

    return nodes

proc part1*(lines: seq[string]): int =
    return visit(createNodes(lines), 1)


proc part2*(lines: seq[string]): int =
    return visit(createNodes(lines), 2)

when isMainModule:
    let lines = parseInput("12")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
