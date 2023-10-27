import Foundation

public class Node<T>: Comparable, Hashable {
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
    
    public var hashValue: Int {
        return Int(cost + heuristic)
    }

}

public func <<T>(lhs: Node<T>, rhs: Node<T>) -> Bool {
    return (lhs.cost + lhs.heuristic) < (rhs.cost + rhs.heuristic)
}

public func ==<T>(lhs: Node<T>, rhs: Node<T>) -> Bool {
    return lhs === rhs
}

// Breadth-first Search (BFS)
public class Queue<T> {
    private var container: [T] = [T]()
    public var isEmpty: Bool { return container.isEmpty }
    public func push(item: T) { container.append(item) }
    public func pop() -> T { return container.removeFirst() }
}

public func bfs<StateType: Hashable>(initialState: StateType, goalTestFn: (StateType) -> Bool, successorFn: (StateType) -> [StateType]) -> Node<StateType>? {
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

public func nodeToPath<StateType>(_ node: Node<StateType>) -> [StateType] {
    var path: [StateType] = [node.state]
    var node = node // local modifible copy of reference
    // work backwards from end to front
    while let currentNode = node.parent {
        path.insert(currentNode.state, at: 0)
        node = currentNode
    }
    return path
}
