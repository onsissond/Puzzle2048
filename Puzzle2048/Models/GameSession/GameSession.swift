//
//  GameSession.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import Foundation

protocol GameSession {
    var gameboardModel: SquareGameboard { get }
    func startGame()
    func continueGame(gameboardModel: SquareGameboard)
    func finishGame()
    func addCommand(_ command: MoveCommand)
}

final class GameSessionImp: GameSession {

    private let dimension: Int
    private let threshold: Int
    private let maxCommands = 100
    private weak var delegate: GameSessionDelegate!
    private weak var gameboardView: GameboardView!
    private var stepChangesGameboardModel: SquareGameboard

    var gameboardModel: SquareGameboard

    init(dimension: Int,
         threshold: Int,
         gameSessionDelegate: GameSessionDelegate,
         gameboardView: GameboardView) {
        self.dimension = dimension
        self.threshold = threshold
        self.gameboardView = gameboardView
        delegate = gameSessionDelegate
        gameboardModel = SquareGameboard(dimension: dimension, initialValue: .empty)
        stepChangesGameboardModel = SquareGameboard(dimension: dimension, initialValue: .empty)
    }

    func startGame() {
        // TODO: Remove test data
//        insertTile(position: TilePosition(row: 0, column: 0), value: 8)
//        insertTile(position: TilePosition(row: 0, column: 1), value: 2)
//        insertTile(position: TilePosition(row: 0, column: 2), value: 2)
//        insertTile(position: TilePosition(row: 0, column: 3), value: 4)
        insertTileAtRandomLocation(withValue: 2)
        insertTileAtRandomLocation(withValue: 2)
    }

    func continueGame(gameboardModel: SquareGameboard) {
        self.gameboardModel = gameboardModel
        for position in gameboardModel.positions {
            switch gameboardModel[position] {
            case .tile(let value):
                gameboardView.insertTile(position: position, value: value)
            default: break
            }
        }
    }

    func finishGame() {
        gameboardView.reset()
    }

    func insertTile(position: TilePosition, value: Int) {
        gameboardModel[position] = .tile(value)
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
        for position in gameboardModel.positions {
            if case .empty = gameboardModel[position] {
                buffer += [position]
            }
        }
        return buffer
    }

    private func performMove(direction: MoveDirection) -> Bool {
        var changes = false
        let positions = direction == .up || direction == .left ? gameboardModel.positions : gameboardModel.positions.reversed()
        for currentPosition in positions {
            if case .tile(var value) = gameboardModel[currentPosition] {

                let currentValue = value
                let newPosition = newPositionForTile(currentPosition: currentPosition, direction: direction, value: &value)

                if currentPosition == newPosition { continue }
                gameboardModel[currentPosition] = .empty

                if currentValue != value {
                    stepChangesGameboardModel[newPosition] = .tile(value)
                }

                gameboardModel[newPosition] = .tile(value)
                gameboardView.moveOneTile(from: currentPosition, to: newPosition, value: value)
                changes = true
            }
        }
        stepChangesGameboardModel.setAll(to: .empty)
        return changes
    }

    private func newPositionForTile(currentPosition: TilePosition, direction: MoveDirection, value: inout Int) -> TilePosition {

        var rowCursor = currentPosition.row
        var columnCursor = currentPosition.column

        let needIncreaseValue = { [unowned self] (nextPosition: TilePosition, value: Int) -> Bool in
            return self.gameboardModel[nextPosition] == .tile(value) && self.stepChangesGameboardModel[nextPosition] != .tile(value)
        }

        switch direction {
        case .up:
            var nextPosition = TilePosition(row: rowCursor - 1, column: currentPosition.column)
            while canMove(value: value, nextPosition: nextPosition) {
                rowCursor -= 1
                if needIncreaseValue(nextPosition, value) {
                    value *= 2
                    break
                }
                nextPosition = TilePosition(row: rowCursor - 1, column: currentPosition.column)
            }
        case .down:
            var nextPosition = TilePosition(row: rowCursor + 1, column: currentPosition.column)
            while canMove(value: value, nextPosition: nextPosition) {
                rowCursor += 1
                if needIncreaseValue(nextPosition, value) {
                    value *= 2
                    break
                }
                nextPosition = TilePosition(row: rowCursor + 1, column: currentPosition.column)
            }
        case .left:
            var nextPosition = TilePosition(row: currentPosition.row, column: columnCursor - 1)
            while canMove(value: value, nextPosition: nextPosition) {
                columnCursor -= 1
                if needIncreaseValue(nextPosition, value) {
                    value *= 2
                    break
                }
                nextPosition = TilePosition(row: currentPosition.row, column: columnCursor - 1)
            }
        case .right:
            var nextPosition = TilePosition(row: currentPosition.row, column: columnCursor + 1)
            while canMove(value: value, nextPosition: nextPosition) {
                columnCursor += 1
                if needIncreaseValue(nextPosition, value) {
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
            (gameboardModel[nextPosition] == .empty || gameboardModel[nextPosition] == .tile(value) &&
                stepChangesGameboardModel[nextPosition] != .tile(value))
    }


    private func checkWin() -> Bool {
        for position in gameboardModel.positions {
            if gameboardModel[position] == .tile(threshold) {
                return true
            }
        }
        return false
    }

    private func checkLose() -> Bool {
        if gameboardEmptySpots().isEmpty {
            for position in gameboardModel.positions {
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
