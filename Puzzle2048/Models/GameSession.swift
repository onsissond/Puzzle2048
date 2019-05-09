//
//  GameSession.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import Foundation

protocol GameSession {
    func startGame()
    func finishGame()
    func addCommand(_ command: MoveCommand)
}

final class GameSessionImp: GameSession {

    private let dimension: Int
    private let threshold: Int
    private let maxCommands = 100
    private weak var delegate: GameSessionDelegate!
    private weak var gameboardView: GameboardView!
    private var gameboardModel: SquareGameboard<TileObject>
    private var queue: [MoveCommand] = []
    private var positions: [TilePosition] = []

    init(dimension: Int,
         threshold: Int,
         gameSessionDelegate: GameSessionDelegate,
         gameboardView: GameboardView) {
        self.dimension = dimension
        self.threshold = threshold
        self.gameboardView = gameboardView
        delegate = gameSessionDelegate
        gameboardModel = SquareGameboard(dimension: dimension, initialValue: .empty)
        positions = createPositions()
    }

    func startGame() {
        insertTileAtRandomLocation(withValue: 2)
        insertTileAtRandomLocation(withValue: 2)
    }

    func finishGame() {
        gameboardView.reset()
    }

    func insertTile(position: TilePosition, value: Int) {
        gameboardModel[position.column, position.row] = .tile(value)
        gameboardView.insertTile(position: position, value: value)
    }

    func addCommand(_ command: MoveCommand) {
        let changes = performMove(direction: command.direction)
        if checkWin() {
            delegate.win()
            return
        }
        if changes {
            insertTileAtRandomLocation(withValue: Int.random(in: 0..<10) == 1 ? 4 : 2)
            if checkLose() {
                delegate.lose()
            }
        }
    }
}

extension GameSessionImp {
    private func insertTileAtRandomLocation(withValue value: Int) {
        let openSpots = gameboardEmptySpots()
        if openSpots.isEmpty { return }

        let idx = Int.random(in: 0..<openSpots.count)
        let position = openSpots[idx]
        insertTile(position: position, value: value)
    }

    private func gameboardEmptySpots() -> [TilePosition] {
        var buffer: [TilePosition] = []
        for i in 0..<dimension {
            for j in 0..<dimension {
                if case .empty = gameboardModel[i, j] {
                    buffer += [TilePosition(row: j, column: i)]
                }
            }
        }
        return buffer
    }

    private func performMove(direction: MoveDirection) -> Bool {
        var changes = false
        let positions = direction == .up || direction == .left ? self.positions : self.positions.reversed()
        for currentPosition in positions {
            if case .tile(var value) = gameboardModel[currentPosition] {
                let newPosition = newPositionForTile(currentPosition: currentPosition, direction: direction, value: &value)

                if currentPosition == newPosition { continue }
                gameboardModel[currentPosition.column, currentPosition.row] = .empty
                gameboardModel[newPosition.column, newPosition.row] = .tile(value)
                gameboardView.moveOneTile(from: currentPosition, to: newPosition, value: value)
                changes = true
            }
        }

        return changes
    }

    private func newPositionForTile(currentPosition: TilePosition, direction: MoveDirection, value: inout Int) -> TilePosition {

        var rowCursor = currentPosition.row
        var columnCursor = currentPosition.column

        switch direction {
        case .up:
            var nextPosition = TilePosition(row: rowCursor - 1, column: currentPosition.column)
            while canMove(value: value, nextPosition: nextPosition) {
                rowCursor -= 1
                if gameboardModel[nextPosition] == .tile(value) {
                    value *= 2
                    break
                }
                nextPosition = TilePosition(row: rowCursor - 1, column: currentPosition.column)
            }
        case .down:
            var nextPosition = TilePosition(row: rowCursor + 1, column: currentPosition.column)
            while canMove(value: value, nextPosition: nextPosition) {
                rowCursor += 1
                if gameboardModel[nextPosition] == .tile(value) {
                    value *= 2
                    break
                }
                nextPosition = TilePosition(row: rowCursor + 1, column: currentPosition.column)
            }
        case .left:
            var nextPosition = TilePosition(row: currentPosition.row, column: columnCursor - 1)
            while canMove(value: value, nextPosition: nextPosition) {
                columnCursor -= 1
                if gameboardModel[nextPosition] == .tile(value) {
                    value *= 2
                    break
                }
                nextPosition = TilePosition(row: currentPosition.row, column: columnCursor - 1)
            }
        case .right:
            var nextPosition = TilePosition(row: currentPosition.row, column: columnCursor + 1)
            while canMove(value: value, nextPosition: nextPosition) {
                columnCursor += 1
                if gameboardModel[nextPosition] == .tile(value) {
                    value *= 2
                    break
                }
                nextPosition = TilePosition(row: currentPosition.row, column: columnCursor + 1)
            }
        }
        return TilePosition(row: rowCursor, column: columnCursor)
    }

    private func canMove(value: Int, nextPosition: TilePosition) -> Bool {
        return nextPosition.column < dimension && nextPosition.row < dimension &&
            nextPosition.column >= 0 && nextPosition.row >= 0 &&
            (gameboardModel[nextPosition] == .empty || gameboardModel[nextPosition] == .tile(value))
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

    private func checkWin() -> Bool {
        for position in positions {
            if gameboardModel[position] == .tile(threshold) {
                return true
            }
        }
        return false
    }

    private func checkLose() -> Bool {
        if gameboardEmptySpots().isEmpty {
            for position in positions {
                if case .tile(var value) = gameboardModel[position] {
                    for direction in MoveDirection.allCases {
                        if newPositionForTile(currentPosition: position, direction: direction, value: &value) != position {
                            return false
                        }
                    }
                }
            }
        }
        return gameboardEmptySpots().isEmpty
    }
}
