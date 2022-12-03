import ArgumentParser
import Foundation

extension PuzzleSolverCommand {
    static let solvers: [any PuzzleSolver] = [
       Day1Solver(),
       // Your solvers for other days here...
    ]
}

protocol PuzzleSolver {
    func solve(_ inputData: String, part: PuzzlePart) -> String?
}

/// Each Puzzle has two parts
enum PuzzlePart: String, Codable, CaseIterable {
    case one
    case two
}

// MARK: - Solver Command

@main
struct PuzzleSolverCommand: ParsableCommand {
    @Option(name: .long, help: "Day number for a puzzle.")
    var day: Int = 1

    @Option(help: "Part one or two", completion: .list(PuzzlePart.allCases.map(\.rawValue)), transform: Self.transformPartArgument)
    var part: PuzzlePart = .one

    @Argument(help: "File path for puzzle input.", completion: .file(), transform: URL.init(fileURLWithPath:))
    var input: URL

    static func transformPartArgument(_ value: String) throws -> PuzzlePart {
        guard let part = PuzzlePart(rawValue: value) else { throw ValidationError("Invalid puzzle part") }
        return part
    }

    mutating func run() throws {
        guard let inputData = try? String(contentsOf: input, encoding: .utf8) else {
            print("Failed to read input file")
            return
        }

        print("Loaded input! ")
        print("Input lines count: \(inputData.count)")

        guard Self.solvers.count >= day, day > 0 else {
            print("No puzzle solver for day #\(day)")
            return
        }

        print()
        let solver = Self.solvers[day - 1]

        if let solution = solver.solve(inputData, part: part) {
            print("The answer is...")
            print(solution)
        } else {
            print("No solution for part \'\(part.rawValue)\'")
        }
    }
}
