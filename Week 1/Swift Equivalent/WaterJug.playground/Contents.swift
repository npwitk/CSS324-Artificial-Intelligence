import Foundation

protocol State: CustomStringConvertible, Hashable {
    func isGoal() -> Bool
    func successors() -> [(state: Self, stepCost: Int)]
}

struct WaterJugState: State {
    let small: Int  // 3-liter jug
    let large: Int  // 5-liter jug

    // Goal is 4 liters in the large jug
    func isGoal() -> Bool {
        return large == 4
    }

    // Description for printing
    var description: String {
        return "(\(small), \(large))"
    }

    // Generate successor states
    func successors() -> [(state: WaterJugState, stepCost: Int)] {
        var successors: [(WaterJugState, Int)] = []

        // Fill small jug
        if small < 3 {
            successors.append((WaterJugState(small: 3, large: large), 3 - small))
        }

        // Fill large jug
        if large < 5 {
            successors.append((WaterJugState(small: small, large: 5), 5 - large))
        }

        // Empty small jug
        if small > 0 {
            successors.append((WaterJugState(small: 0, large: large), small))
        }

        // Empty large jug
        if large > 0 {
            successors.append((WaterJugState(small: small, large: 0), large))
        }

        // Pour small to large
        let pourToLarge = min(small, 5 - large)
        if pourToLarge > 0 {
            successors.append((
                WaterJugState(small: small - pourToLarge, large: large + pourToLarge),
                pourToLarge
            ))
        }

        // Pour large to small
        let pourToSmall = min(large, 3 - small)
        if pourToSmall > 0 {
            successors.append((
                WaterJugState(small: small + pourToSmall, large: large - pourToSmall),
                pourToSmall
            ))
        }

        return successors
    }
}

// Initial state (0, 0)
print("Successors of initial state (0, 0):")
let initialState = WaterJugState(small: 0, large: 0)
for (state, stepCost) in initialState.successors() {
    print("State: \(state), Step Cost: \(stepCost)")
}

print("\nSuccessors of given state (0, 4):")
let givenState = WaterJugState(small: 0, large: 4)
for (state, stepCost) in givenState.successors() {
    print("State: \(state), Step Cost: \(stepCost)")
}

