import std/[json, options, sequtils, strformat, sugar, strutils]
import utils

type
    TreeObj = object
        left: Tree
        right: Tree
        value: int
        parent: Tree

    Tree = ref TreeObj

proc `$`*(tree: Tree): string =
    if tree == nil:
        return "[]"

    if tree.left == nil:
        assert tree.right == nil
        return $tree.value

    return &"[{tree.left}, {tree.right}]"

proc leftValue(tree: Tree): Option[int] =
    if tree.left != nil and tree.left.left == nil:
        return some(tree.left.value)

    let left = tree.left.leftValue()
    if left.isSome():
        return left

    return none(int)

proc rightValue(tree: Tree): Option[int] =
    if tree.right != nil and tree.right.right == nil:
        return some(tree.right.value)

    let right = tree.right.rightValue()
    if right.isSome():
        return right

    return none(int)

proc leftmostNode(tree: Tree): Tree =
    var current = tree
    while current.left != nil:
        current = current.left

    return current

proc rightmostNode(tree: Tree): Tree =
    var current = tree
    while current.right != nil:
        current = current.right

    return current

proc getLeftNeighbor(tree: Tree): Tree =
    var parent = tree.parent
    if parent.right == tree:
        assert parent.left.left == nil
        return parent.left

    var current = tree

    while true:
        current = current.parent
        parent = current.parent

        if parent == nil:
            return nil

        # Since the tree always has left and right nodes at each step,
        # if we're already in a left branch,
        # then we need to go to the next level to look for a neighbor
        if parent.left == current:
            continue

        return parent.left.rightmostNode()

proc getRightNeighbor(tree: Tree): Tree =
    var parent = tree.parent
    if parent.left == tree:
        assert parent.right.left == nil
        return parent.right

    var current = tree

    while true:
        current = current.parent
        parent = current.parent

        if parent == nil:
            return nil

        if parent.right == current:
            continue

        return parent.right.leftmostNode()

proc findSplitNode(tree: Tree): Tree =
    if tree == nil:
        return nil

    if tree.left == nil and tree.value >= 10:
        return tree

    let tryLeft = findSplitNode(tree.left)
    if tryLeft != nil:
        return tryLeft

    return findSplitNode(tree.right)

proc split(tree: var Tree): bool =
    let leftmost = findSplitNode(tree)
    if leftmost == nil:
        return false

    let number = leftmost.value
    let left = number div 2
    let right = left + number mod 2

    let parent = leftmost.parent
    let newNode = Tree(left: Tree(value: left), right: Tree(value: right), parent: parent)
    newNode.left.parent = newNode
    newNode.right.parent = newNode

    if parent.left == leftmost:
        parent.left = newNode
    else:
        parent.right = newNode

    return true

proc findExplodeNode(tree: Tree, depth = 0): Tree =
    if tree == nil:
        return nil

    if depth >= 4:
        if tree.left != nil and tree.left.left == nil and tree.left.right == nil:
            return tree

        if tree.right != nil and tree.right.left == nil and tree.right.right == nil:
            return tree

    let tryLeft = findExplodeNode(tree.left, depth + 1)
    if tryLeft != nil:
        return tryLeft

    return findExplodeNode(tree.right, depth + 1)

proc explode(tree: var Tree): bool =
    let leftmost = findExplodeNode(tree)

    if leftmost == nil:
        return false

    let left = getLeftNeighbor(leftmost.left)
    let right = getRightNeighbor(leftmost.right)

    if left != nil:
        left.value += leftmost.left.value

    if right != nil:
        right.value += leftmost.right.value

    leftmost.left = nil
    leftmost.right = nil
    leftmost.value = 0
    return true

proc parseTree(node: JsonNode, parent: Tree = nil): Tree =
    case node.kind:
        of JInt:
            return Tree(value: node.getInt())
        of JArray:
            assert node.len() == 2
            var left = parseTree(node[0])
            var right = parseTree(node[1])
            result = Tree(left: left, right: right)
            result.left.parent = result
            result.right.parent = result
            return
        else:
            echo "invalid JSON type encountered"
            echo node
            quit 1

proc `+`(left, right: Tree): Tree =
    result = Tree(left: left, right: right)
    result.left.parent = result
    result.right.parent = result

    while true:
        var modified = false
        if explode(result):
            modified = true
        elif split(result):
            modified = true

        if not modified:
            break

proc magnitude(tree: Tree): int64 =
    if tree.left == nil:
        assert tree.right == nil
        return tree.value

    return 3 * tree.left.magnitude() + 2 * tree.right.magnitude()

proc part1*(lines: seq[string]): int64 =
    let tree = lines.filter(x => not x.isEmptyOrWhitespace()).mapIt(parseTree(parseJson(it))).foldl(a + b)
    result = tree.magnitude()

proc part2*(lines: seq[string]): int64 =
    let trees = lines.filter(x => not x.isEmptyOrWhitespace()).mapIt(parseTree(parseJson(it)))

    for ix, tree1 in trees:
        for tree2 in trees[ix + 1 .. trees.high]:
            for pair in [[tree1.deepCopy(), tree2.deepCopy()], [tree2.deepCopy(), tree1.deepCopy()]]:
                let answer = (pair[0] + pair[1]).magnitude()
                if answer > result:
                    result = answer

when isMainModule:
    let lines = parseInput("18")
    echo fmt"Part1: {part1(lines)}"
    echo fmt"Part2: {part2(lines)}"
