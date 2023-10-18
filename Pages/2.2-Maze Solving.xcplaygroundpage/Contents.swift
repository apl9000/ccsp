import Foundation


enum Cell: Character {
    case Empty = "⬜️"
    case Blocked = "🔥"
    case Start = "🟢"
    case Goal = "🏁"
    case Path = "🚶‍♀️"
}

typealias Maze = [[Cell]]

srand48(time(nil)) // Seed random number generator

// sparseness is the approximate percentage of wals represented
// as a number between 0 and 1
func generateMaze(rows: Int, columns: Int, sparseness: Double) -> Maze {
    // initialize maze full of empty spaces
    var maze: Maze = Maze(repeating: [Cell](repeating: .Empty, count: columns), count: rows)
    // put walls in
    for row in 0..<rows {
        for col in 0..<columns {
            if drand48() < sparseness { // chance of wall
                maze[row][col] = .Blocked
            }
        }
    }
    return maze
}

func printMaze(_ maze: Maze) {
    for i in 0..<maze.count {
        print(String(maze[i].map{ $0.rawValue }))
    }
}

struct MazeLocation: Hashable {
    let row: Int
    let col: Int
    var hashValue: Int {
        return row.hashValue ^ col.hashValue
    }
}

func == (lhs: MazeLocation, rhs: MazeLocation) -> Bool {
    return lhs.row == rhs.row && lhs.col == rhs.col
}


func goalTest(ml: MazeLocation) -> Bool {
    return ml == goal
}

// successor function to determine next possible moves for maze
func successorsForMaze(_ maze: Maze) -> (MazeLocation) -> [MazeLocation] {
    func successors(ml: MazeLocation) -> [MazeLocation] {
        var nextPossibleMazeLocs: [MazeLocation] = [MazeLocation]()
        // LEFT
        if (ml.row + 1 < maze.count) && (maze[ml.row + 1][ml.col] != .Blocked) {
            nextPossibleMazeLocs.append(MazeLocation(row: ml.row + 1, col: ml.col))
        }
        // RIGHT
        if (ml.row - 1 >= 0) && (maze[ml.row - 1][ml.col] != .Blocked) {
            nextPossibleMazeLocs.append(MazeLocation(row: ml.row - 1, col: ml.col))
        }
        // UP
        if (ml.col + 1 < maze[0].count) && (maze[ml.row][ml.col + 1] != .Blocked) {
            nextPossibleMazeLocs.append(MazeLocation(row: ml.row, col: ml.col + 1))
        }
        // DOWN
        if (ml.col - 1 >= maze[0].count) && (maze[ml.row][ml.col - 1] != .Blocked) {
            nextPossibleMazeLocs.append(MazeLocation(row: ml.row, col: ml.col - 1))
        }
        return nextPossibleMazeLocs
    }
    return successors
}

// Depth-first search (DFS)
public class Stack<T> {
    private var container: [T] = [T]()
    public var isEmpty: Bool {
        return container.isEmpty
    }
    public func push(item: T) {
        container.append(item)
    }
    public func pop() -> T {
        return container.removeLast()
    }
}

class Node<T>: Comparable, Hashable {
    let state: T
    let parent: Node?
    let cost: Float
    let heuristic: Float
    
    init(state: T, parent: Node?, cost: Float = 0.0, heuristic: Float = 0.0) {
        self.state = state
        self.parent = parent
        self.cost = cost
        self.heuristic = heuristic
    }
    
    var hashValue: Int {
        return Int(cost + heuristic)
    }

}

func <<T>(lhs: Node<T>, rhs: Node<T>) -> Bool {
    return (lhs.cost + lhs.heuristic) < (rhs.cost + rhs.heuristic)
}

func ==<T>(lhs: Node<T>, rhs: Node<T>) -> Bool {
    return lhs === rhs
}

func dfs<StateType: Hashable>(initialState: StateType, goalTestFn: (StateType) -> Bool, successorFn: (StateType) -> [StateType]) -> Node<StateType>? {
    // frontier is where we've yet to go
    let frontier: Stack<Node<StateType>> = Stack<Node<StateType>>()
    frontier.push(item: Node(state: initialState, parent: nil))
    // explored is where we've been
    var explored: Set<StateType> = Set<StateType>()
    explored.insert(initialState)
    
    // keep going while there is more to expore
    while !frontier.isEmpty {
        let currentNode = frontier.pop()
        let currentState = currentNode.state
        // if we found the goal we're done
        if goalTestFn(currentState)  {
            return currentNode
        }
        // check where we can go next and haven't explored
        for child in successorFn(currentState) where !explored.contains(child) {
            explored.insert(child)
            frontier.push(item: Node(state: child, parent: currentNode))
        }
    }
    print("No Solution")
    return nil // never found the goal
}

func nodeToPath<StateType>(_ node: Node<StateType>) -> [StateType] {
    var path: [StateType] = [node.state]
    var node = node // local modifible copy of reference
    // work backwards from end to front
    while let currentNode = node.parent {
        path.insert(currentNode.state, at: 0)
        node = currentNode
    }
    return path
}

// "inout" indicates the original maze value will be modifed instead of being copied as temp varible in markMaze
// analogous to "call by reference"
func markMaze(_ maze: inout Maze, path: [MazeLocation], start: MazeLocation, goal: MazeLocation) {
    for ml in path {
        maze[ml.row][ml.col] = .Path
    }
    maze[start.row][start.col] = .Start
    maze[goal.row][goal.col] = .Goal
}

let start = MazeLocation(row: 0, col: 0)
let goal = MazeLocation(row: 19, col: 19)

print("---------------------- DFS ----------------------")
var maze = generateMaze(rows: 20, columns: 20, sparseness: 0.2)
if let solution = dfs(initialState: start, goalTestFn: goalTest, successorFn: successorsForMaze(maze)) {
    let path = nodeToPath(solution)
    markMaze(&maze, path: path, start: start, goal: goal)
    printMaze(maze)
}
print("---------------------- DFS ----------------------")


// Breadth-first Search (BFS)
public class Queue<T> {
    private var container: [T] = [T]()
    public var isEmpty: Bool { return container.isEmpty }
    public func push(item: T) { container.append(item) }
    public func pop() -> T { return container.removeFirst() }
}

func bfs<StateType: Hashable>(initialState: StateType, goalTestFn: (StateType) -> Bool, successorFn: (StateType) -> [StateType]) -> Node<StateType>? {
    // Frontier is where you've yet to go
    let frontier: Queue<Node<StateType>> = Queue<Node<StateType>>()
    frontier.push(item: Node(state: initialState, parent: nil))
    // Explored is where you've been
    var explored: Set<StateType> = Set<StateType>()
    explored.insert(initialState)
    // Keep going where there is more to explore!
    while !frontier.isEmpty {
        let currentNode = frontier.pop()
        let currentState = currentNode.state
        // if we found the goal we win!
        if goalTestFn(currentState) {
            return currentNode
        }
        for child in successorFn(currentState) where !explored.contains(child) {
            explored.insert(child)
            frontier.push(item: Node(state: child, parent: currentNode))
        }
    }
    print("No Solution")
    return nil
}

print("---------------------- BFS ----------------------")
var maze2 = generateMaze(rows: 20, columns: 20, sparseness: 0.2)
if let solution = bfs(initialState: start, goalTestFn: goalTest, successorFn: successorsForMaze(maze2)) {
    let path = nodeToPath(solution)
    markMaze(&maze2, path: path, start: start, goal: goal)
    printMaze(maze2)
}
print("---------------------- BFS ----------------------")

// A-star (A*) search

func aStar<StateType: Hashable>(
    initialState: StateType,
    goalTestFn: (StateType) -> Bool,
    successorFn: (StateType) -> [StateType],
    heuristicFunc: (StateType) -> Float
) -> Node<StateType>? {
    var frontier: PriorityQueue<Node<StateType>> = 
        PriorityQueue<Node<StateType>>(
            ascending: true,
            startingValues: [
                Node(state: initialState, parent: nil, cost: 0, heuristic: heuristicFunc(initialState))])
    
    var explored = Dictionary<StateType, Float>()
    explored[initialState] = 0
    
    while let currentNode = frontier.pop() {
        let currentState = currentNode.state
        if goalTestFn(currentState) {
            return currentNode
        }
        
        for child in successorFn(currentState) {
            let newCost = currentNode.cost + 1
            if (explored[child] == nil || explored[child]! > newCost) {
                explored[child] = newCost
                frontier.push(Node(state: child, parent: currentNode, cost: newCost, heuristic: heuristicFunc(child)))
            }
        }
    }
    return nil
    
}

func euclideanDistance(ml: MazeLocation) -> Float {
    let xdist = ml.col - goal.col
    let ydist = ml.row - goal.row
    return sqrt(Float((xdist * xdist) + (ydist * ydist)))
}
func manhattanDistance(ml: MazeLocation) -> Float {
    let xdist = abs(ml.col - goal.col)
    let ydist = abs(ml.col - goal.col)
    return Float(xdist + ydist)
}

print("---------------------- A STAR ----------------------")
var maze3 = generateMaze(rows: 20, columns: 20, sparseness: 0.2)
if let solution = aStar(initialState: start, goalTestFn: goalTest, successorFn: successorsForMaze(maze3), heuristicFunc: manhattanDistance) {
    let path = nodeToPath(solution)
    markMaze(&maze3, path: path, start: start, goal: goal)
    printMaze(maze3)
}
print("---------------------- A STAR ----------------------")
