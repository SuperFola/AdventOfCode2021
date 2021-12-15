import utils

import std/[strutils, sequtils, sugar, strformat, tables, algorithm, sets, times]

type
    Graph = object
        vertices: HashSet[string]
        neighbours: Table[string, seq[tuple[dst: string, cost: float]]]

proc dijkstraPath(graph: Graph; first, last: string): seq[tuple[dst: string, cost: float]] =
    var
        dist = initTable[string, float]()
        previous = initTable[string, string]()
        notSeen = graph.vertices

    for vertex in graph.vertices:
        dist[vertex] = Inf
    dist[first] = 0

    while notSeen.card > 0:
        # Search vertex with minimal distance.
        var
            vertex1: string
            mindist = Inf

        for vertex in notSeen:
            if dist[vertex] < mindist:
                vertex1 = vertex
                mindist = dist[vertex]

        if vertex1 == last:
            break
        notSeen.excl(vertex1)

        # Find shortest paths to neighbours.
        for (vertex2, cost) in graph.neighbours.getOrDefault(vertex1):
            if vertex2 in notSeen:
                let altdist = dist[vertex1] + cost
                if altdist < dist[vertex2]:
                    # Found a shorter path to go to vertex2.
                    dist[vertex2] = altdist
                    previous[vertex2] = vertex1    # To go to vertex2, go through vertex1.

        if previous.len mod 100 == 0:
            echo previous.len / graph.vertices.len * 100

    var
        vertex = last
        vertices: seq[string]

    while vertex.len > 0:
        vertices.add(vertex)
        vertex = previous.getOrDefault(vertex)
    vertices.reverse()

    var costSeq: seq[tuple[dst: string, cost: float]]

    # ignore the end node
    for i, node in vertices[0 .. ^2]:
        # search cost of node to vertices[i + 1]
        let neighbours = graph.neighbours[node]
        for (dst, cost) in neighbours:
            if dst == vertices[i + 1]:
                costSeq.add((dst, cost))
                break

    return costSeq

proc genNodeName(x: int, y: int): string =
    let letters = "abcdefghijklmnopqrstuvwxyz".toSeq
    return letters[x div letters.len] & letters[x mod letters.len] & $y

proc initGraph(grid: seq[seq[int]]): Graph =
    let
        height = grid.len() - 1
        width = grid[0].len() - 1
        time = cpuTime()

    for y, line in grid:
        for x, cost in line:
            let dst = genNodeName(x, y)
            result.vertices.incl(dst)

            if x > 0:
                result.neighbours.mgetOrPut(genNodeName(x - 1, y), @[]).add((dst, cost.toFloat))
            if x + 1 < width:
                result.neighbours.mgetOrPut(genNodeName(x + 1, y), @[]).add((dst, cost.toFloat))
            if y > 0:
                result.neighbours.mgetOrPut(genNodeName(x, y - 1), @[]).add((dst, cost.toFloat))
            if y + 1 < height:
                result.neighbours.mgetOrPut(genNodeName(x, y + 1), @[]).add((dst, cost.toFloat))

    debugEcho "average neighbors per node: ", result.neighbours.values.toSeq.map(x => x.len()).foldl(a + b) / result.neighbours.len
    debugEcho "Graph created in ", cpuTime() - time, " seconds"


# top left to bottom right
# can not move diagonally
# don't count the risk level of the starting position

proc solver(grid: seq[seq[int]]): int =
    let
        graph = initGraph(grid)
        first = genNodeName(0, 0)
        last = genNodeName(grid[0].len() - 1, grid.len() - 1)
        path = graph.dijkstraPath(first, last)

    return path.map(x => x.cost.toInt).foldl(a + b)

proc part1*(lines: seq[string]): int =
    let parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.map(charAsInt))
    return solver(parsed)


proc part2*(lines: seq[string]): int =
    let
        parsed = lines.filter(x => not x.isEmptyOrWhitespace()).map(x => x.map(charAsInt))
        ogHeight = parsed.len()
        ogWidth = parsed[0].len()

    var tempInput: seq[seq[int]]
    for y, line in parsed:
        tempInput.add(parsed[y])
        for i in 1 .. 4:
            for x, cost in line:
                var newCost = tempInput[y][ogWidth * (i - 1) + x] + 1
                if newCost > 9:
                    newCost = 1
                tempInput[^1].add(newCost)

    var newInput = tempInput
    for i in 1 .. 4:
        for y, line in tempInput:
            newInput.add(@[])
            for x, cost in line:
                var newCost = newInput[ogHeight * (i - 1) + y][x] + 1
                if newCost > 9:
                    newCost = 1
                newInput[^1].add(newCost)

    return solver(newInput)

when isMainModule:
    let lines = parseInput("15")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
