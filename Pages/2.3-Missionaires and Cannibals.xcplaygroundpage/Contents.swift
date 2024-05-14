import Foundation

let maxNum = 3

struct MCState: Hashable, CustomStringConvertible {
    let missionaries: Int
    let cannibals: Int
    let boat: Bool
    var hashValue: Int {
        return missionaries * 10 + cannibals + (boat ? 1000 : 2000)
    }
    var description: String {
        let nM = missionaries
        let nC = cannibals
        let sM = maxNum - nM
        let sC = maxNum - nC
        
        var description = "On the north bank there are \(nM) missionaries and \(nC) cannibals.\n"
        description += "On the south bank there are \(sM) missionaries and \(sC) cannibals.\n"
        description += "The boat is on the \(boat ? "north" : "south") bank.\n"
        return description
    }
}

func ==(lhs: MCState, rhs: MCState) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func goalTestMC(state: MCState) -> Bool {
    return state == MCState(missionaries: 0, cannibals: 0, boat: false)
}

func isLegalMc(state: MCState) -> Bool {
    let nM = state.missionaries
    let nC = state.cannibals
    let sM = maxNum - nM
    let sC = maxNum - nC
    
    if nM < nC && nM > 0 { return false }
    if sM < sC && sM > 0 { return false }
    return true
}

func successorFn(state: MCState) -> [MCState] {
    let nM = state.missionaries
    let nC = state.cannibals
    let sM = maxNum - nM
    let sC = maxNum - nC
    
    var success: [MCState] = [MCState]()
    
    if state.boat { // Boat is on the north bank
        if nM > 1 {
            success.append(MCState(missionaries: nM - 2, cannibals: nC, boat: !state.boat))
        }
        if nM > 0 {
            success.append(MCState(missionaries: nM - 1, cannibals: nC, boat: !state.boat))
        }
        if nC > 1 {
            success.append(MCState(missionaries: nM, cannibals: nC - 2, boat: !state.boat))
        }
        if nC > 0 {
            success.append(MCState(missionaries: nM, cannibals: nC - 1, boat: !state.boat))
        }
        if (nC > 0) && (nM > 0) {
            success.append(MCState(missionaries: nM - 1, cannibals: nC - 1, boat: !state.boat))
        }
    } else { // Boat is on the south bank
        if sM > 1 {
            success.append(MCState(missionaries: nM + 2, cannibals: nC, boat: !state.boat))
        }
        if sM > 0 {
            success.append(MCState(missionaries: nM + 1, cannibals: nC, boat: !state.boat))
        }
        if sC > 1 {
            success.append(MCState(missionaries: nM, cannibals: nC + 2, boat: !state.boat))
        }
        if sC > 0 {
            success.append(MCState(missionaries: nM, cannibals: nC + 1, boat: !state.boat))
        }
        if (sC > 0) && (sM > 0) {
            success.append(MCState(missionaries: nM + 1, cannibals: nC + 1, boat: !state.boat))
        }
    }
    return success.filter{ isLegalMc(state: $0) }
}

func printMCSolution(path: [MCState]) {
    var oldState = path.first!
    print(oldState)
    for currentState in path[1..<path.count] {
        let nM = currentState.missionaries
        let nC = currentState.cannibals
        let sM = maxNum - nM
        let sC = maxNum - nC
        if !currentState.boat {
            print("\(oldState.missionaries - nM) missionaries and \(oldState.cannibals - nC) cannibals moved from the north bank to the east bank")
        } else {
            print("\(maxNum - oldState.missionaries - sM) missionaires and \(maxNum - oldState.cannibals - sC) cannibals moved from the south bank to the north bank.")
        }
        print(currentState)
        oldState = currentState
    }
}

let startMC = MCState(missionaries: 3, cannibals: 3, boat: true)
if let solution = bfs(initialState: startMC, goalTestFn: goalTestMC, successorFn: successorFn) {
    let path = nodeToPath(solution)
    printMCSolution(path: path)
}
