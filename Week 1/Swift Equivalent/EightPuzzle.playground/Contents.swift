import Foundation

protocol State: CustomStringConvertible, Hashable {
    func isGoal() -> Bool
    func successors() -> [(state: Self, stepCost: Int)]
}

// Struct to represent the 8-puzzle
struct EightPuzzleState: State {
    let board: [[Int]]              // 3x3 puzzle board
    let blankTile: (row: Int, col: Int)  // Position of 0 (the blank)
    
    private let goalState = [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 0]
    ]
    
    // Check if current board is goal
    func isGoal() -> Bool {
        return board == goalState
    }
    
    // Description for printing
    var description: String {
        board.map { row in
            row.map { String($0) }.joined(separator: " ")
        }.joined(separator: "\n")
    }
    
    // Valid board position
    private func isValid(row: Int, col: Int) -> Bool {
        return row >= 0 && row < 3 && col >= 0 && col < 3
    }

    // Generate all valid successor states
    func successors() -> [(state: EightPuzzleState, stepCost: Int)] {
        var results: [(EightPuzzleState, Int)] = []
        let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]  // up, down, left, right
        
        for (dr, dc) in directions {
            let newRow = blankTile.row + dr
            let newCol = blankTile.col + dc
            
            if isValid(row: newRow, col: newCol) {
                var newBoard = board
                // Swap blank with target tile
                newBoard[blankTile.row][blankTile.col] = newBoard[newRow][newCol]
                newBoard[newRow][newCol] = 0
                let newState = EightPuzzleState(board: newBoard, blankTile: (newRow, newCol))
                results.append((newState, 1))  // Cost is 1
            }
        }
        
        return results
    }

    // Hashable by flattening the board
    func hash(into hasher: inout Hasher) {
        for row in board {
            for tile in row {
                hasher.combine(tile)
            }
        }
    }

    static func == (lhs: EightPuzzleState, rhs: EightPuzzleState) -> Bool {
        return lhs.board == rhs.board
    }
}


let initialBoard = [
    [7, 2, 4],
    [5, 0, 6],
    [8, 3, 1]
]

let blank = (row: 1, col: 1)
let initialState = EightPuzzleState(board: initialBoard, blankTile: blank)

print("Initial State:")
print(initialState)
print()

print("Successors:")
for (state, cost) in initialState.successors() {
    print("State:\n\(state), Step Cost: \(cost)\n")
}
