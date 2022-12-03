import Foundation

struct Day1Solver: PuzzleSolver {
    func solve(_ inputData: String, part: PuzzlePart) -> String? {
        switch part {
        case .one:
            return solvePart1(inputData)
        case .two:
            return solvePart2(inputData)
        }
    }

    private func solvePart1(_ inputData: String) -> String? {
        var maxCalories = 0

        var currentElfCarry = 0
        for rawCalories in inputData.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline) {
            if rawCalories.isEmpty {
                maxCalories = max(maxCalories, currentElfCarry)
                currentElfCarry = 0
                continue
            }

            currentElfCarry += Int(rawCalories) ?? 0
        }

        return String(maxCalories)
    }

    private func solvePart2(_ inputData: String) -> String? {
        var elfCarryValues: [Int] = []

        var currentElfCarry = 0
        for rawCalories in inputData.split(omittingEmptySubsequences: false, whereSeparator: \.isNewline) {
            if rawCalories.isEmpty {
                elfCarryValues.append(currentElfCarry)
                currentElfCarry = 0
                continue
            }

            currentElfCarry += Int(rawCalories) ?? 0
        }

        let topThreeValuesSum = elfCarryValues.sorted().suffix(3).reduce(0, +)

        return String(topThreeValuesSum)
    }
}