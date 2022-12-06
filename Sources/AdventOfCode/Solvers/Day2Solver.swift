import Foundation

struct Day2Solver: PuzzleSolver {
    func solve(_ inputData: String, part: PuzzlePart) -> String? {
        switch part {
        case .one:
            return solvePart1(inputData)
        case .two:
            return solvePart2(inputData)
        }
    }

    enum Shape: Int {
        case rock = 1
        case paper
        case scissors

        init?<Symbol: StringProtocol & Equatable>(_ symbol: Symbol) {
            switch symbol {
            case "A", "X":
                self = .rock
            case "B", "Y":
                self = .paper
            case "C", "Z":
                self = .scissors
            default:
                return nil
            }
        }

        func beats() -> Shape {
            switch self {
            case .rock:
                return .scissors
            case .paper:
                return .rock
            case .scissors:
                return .paper
            }
        }

        func play(_ otherShape: Shape) -> RoundResult {
            if self == otherShape {
                return .draw
            }

            if beats() == otherShape {
                return .win
            } else {
                return .loose
            }
        }

        func shapeToGet(_ result: RoundResult) -> Shape {
            switch result {
            case .draw:
                return self
            case .win:
                return beats().beats()
            case .loose:
                return beats()
            }
        }
    }

    enum RoundResult {
        case win
        case loose
        case draw

        init?<Symbol: StringProtocol & Equatable>(_ symbol: Symbol) {
            switch symbol {
            case "X":
                self = .loose
            case "Y":
                self = .draw
            case "Z":
                self = .win
            default:
                return nil
            }
        }
    }

    private func score(for round: RoundResult, with shape: Shape) -> Int {
        let resultScore: Int
        switch round {
        case .win:
            resultScore = 6
        case .loose:
            resultScore = 0
        case .draw:
            resultScore = 3
        }

        return resultScore + shape.rawValue
    }

    private func solvePart1(_ inputData: String) -> String? {
        let gameTotal = inputData.split(whereSeparator: \.isNewline)
            .compactMap { line -> Int? in
                let roundData = line.split(separator: " ")
                guard let opponentMove = Shape(roundData[0]), let yourMove = Shape(roundData[1]) else { return nil }

                let result = yourMove.play(opponentMove)

                return score(for: result, with: yourMove)
            }
            .reduce(0, +)
        return String(gameTotal)
    }

    private func solvePart2(_ inputData: String) -> String? {
        let gameTotal = inputData.split(whereSeparator: \.isNewline)
            .compactMap { line in
                let roundData = line.split(separator: " ")
                guard let opponentMove = Shape(roundData[0]), let result = RoundResult(roundData[1]) else { return nil }

                let yourMove = opponentMove.shapeToGet(result)

                return score(for: result, with: yourMove)
            }
            .reduce(0, +)
        return String(gameTotal)
    }
}