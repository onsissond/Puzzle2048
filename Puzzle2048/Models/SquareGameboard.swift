//
//  SquareGameboard.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

struct SquareGameboard<T> {

    let dimension : Int
    var boardArray : [[T]]

    init(dimension d: Int, initialValue: T) {
        dimension = d
        boardArray = [[T]](repeating: [T](repeating: initialValue, count: d), count: d)
    }

    subscript(position: TilePosition) -> T {
        get {
            let row = position.row
            let column = position.column
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            return boardArray[row][column]
        }
        set {
            let row = position.row
            let column = position.column
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            boardArray[row][column] = newValue
        }
    }

    subscript(row: Int, column: Int) -> T {
        get {
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            return boardArray[column][row]
        }
        set {
            assert(row >= 0 && row < dimension)
            assert(column >= 0 && column < dimension)
            boardArray[column][row] = newValue
        }
    }

    mutating func setAll(to item: T) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                self[i, j] = item
            }
        }
    }
}
