import Foundation

struct Day3Solver: PuzzleSolver {
    func solve(_ inputData: String, part: PuzzlePart) -> String? {
        switch part {
        case .one:
            return solvePart1(inputData)
        case .two:
            return solvePart2(inputData)
        }
    }

    private func solvePart1(_ inputData: String) -> String? {
        let prioritiesSum = inputData.split(whereSeparator: \.isNewline)
            .lazy
            .compactMap { rucksackContents -> Character? in
                guard !rucksackContents.isEmpty else { return nil }
                let middleIndex = rucksackContents.index(rucksackContents.startIndex, offsetBy: rucksackContents.count / 2)
                let firstCompartment = rucksackContents[rucksackContents.startIndex..<middleIndex]
                let secondCompartment = rucksackContents[middleIndex..<rucksackContents.endIndex]

                return firstCompartment.first { item in
                    secondCompartment.contains(item)
                }
            }
            .map {
                priority(of: String($0))
            }
            .reduce(0, +)

        return String(prioritiesSum)
    }

    private func solvePart2(_ inputData: String) -> String? {
        let rucksacks = inputData.split(whereSeparator: \.isNewline)

        var prioritiesSum = 0
        for groupStart in stride(from: rucksacks.startIndex, to: rucksacks.endIndex, by: 3) {
            let group = rucksacks[groupStart..<rucksacks.index(groupStart, offsetBy: 3)]

            guard let item = commonItem(in: group) else { continue }

            prioritiesSum += priority(of: String(item))
        }

        return String(prioritiesSum)
    }

    private func commonItem(in group: some Sequence<some StringProtocol>) -> Character? {
        var iterator = group.makeIterator()
        guard var result = iterator.next().map({ Array($0) }) else { return nil }

        while let item = iterator.next() {
            result = commonItems(result, item)
        }

        return result.first
    }

    private func commonItems(_ first: some Sequence<Character>, _ second: some Sequence<Character>) -> [Character] {
        first.compactMap { item in
            return second.contains(item) ? item : nil
        }
    }

    private func priority(of item: String) -> Int {
        let itemCode = UnicodeScalar(item)?.value ?? 0
        if let lowercaseIndex = unicodeScalarValues(from: "a", to: "z").firstIndex(of: itemCode) {
            // from 1 to 26
            return Int(lowercaseIndex) + 1
        }

        if let uppercaseIndex = unicodeScalarValues(from: "A", to: "Z").firstIndex(of: itemCode) {
            // from 27 to 52
            return Int(uppercaseIndex) + 27
        }

        return 0
    }

    private func unicodeScalarValues(from fromString: String, to toString: String) -> Array<UInt32> {
        guard let fromValue = UnicodeScalar(fromString)?.value, let toValue = UnicodeScalar(toString)?.value else {
            return []
        }

        return Array((fromValue...toValue))
    }
}
