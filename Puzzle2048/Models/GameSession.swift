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
}

final class GameSessionImp: GameSession {

    private weak var delegate: GameSessionDelegate!
    private weak var gameboardView: GameboardView!
    private let dimension: Int
    private let threshold: Int
    private var gameboardModel: SquareGameboard<TileObject>

    init(dimension: Int,
         threshold: Int,
         gameSessionDelegate: GameSessionDelegate,
         gameboardView: GameboardView) {
        self.dimension = dimension
        self.threshold = threshold
        self.gameboardView = gameboardView
        delegate = gameSessionDelegate
        gameboardModel = SquareGameboard(dimension: dimension, initialValue: .empty)
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

    func removeTile(position: TilePosition) {

    }
}

extension GameSessionImp {
    private func insertTileAtRandomLocation(withValue value: Int) {
        let openSpots = gameboardEmptySpots()
        if openSpots.isEmpty {
            // No more open spots; don't even bother
            return
        }
        // Randomly select an open spot, and put a new tile there
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
}
