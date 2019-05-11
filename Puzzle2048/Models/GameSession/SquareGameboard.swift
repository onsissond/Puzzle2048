//
//  SquareGameboard.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

struct SquareGameboard: Codable {

    let dimension: Int
    var boardArray: [TilePosition: TileObject] = [:]
    var positions: [TilePosition] = []

    init(dimension d: Int, initialValue: TileObject) {
        dimension = d
        positions = createPositions()
        setAll(to: initialValue)
    }

    private func createPositions() -> [TilePosition] {
        var positions: [TilePosition] = []
        for i in 0..<dimension {
            for j in 0..<dimension {
                positions.append(TilePosition(row: i, column: j))
            }
        }
        return positions
    }

    subscript(position: TilePosition) -> TileObject {
        get {
            let row = position.row
            let column = position.column
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            return boardArray[position]!
        }
        set {
            let row = position.row
            let column = position.column
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            boardArray[position] = newValue
        }
    }

    mutating func setAll(to item: TileObject) {
        createPositions().forEach { boardArray[$0] = item }
    }
}
