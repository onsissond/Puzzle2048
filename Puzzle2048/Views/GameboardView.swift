//
//  GameboardView.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

@IBDesignable
final class GameboardView: UIView {

    private let dimension: Int
    private let tilePadding: CGFloat
    private let tileSideLength: CGFloat

    private let appearanceProvider: AppearanceProvider = AppearanceProviderImp()
    private let animationEngine = AnimationEngine()
    private var tilesViewStorage = TilesViewStorage()

    init(dimension: Int,
         tilePadding: CGFloat,
         tileSideLength: CGFloat) {
        self.dimension = dimension
        self.tilePadding = tilePadding
        self.tileSideLength = tileSideLength

        super.init(frame: .zero)

        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        var xCursor = tilePadding
        var yCursor: CGFloat
        for _ in 0..<dimension {
            yCursor = tilePadding
            for _ in 0..<dimension {
                drawEmptyTail(frame: CGRect(x: xCursor,
                                            y: yCursor,
                                            width: tileSideLength,
                                            height: tileSideLength))
                yCursor += tilePadding + tileSideLength
            }
            xCursor += tilePadding + tileSideLength
        }
    }

    private func drawEmptyTail(frame: CGRect) {
        let background = UIView(frame: frame)
        background.layer.cornerRadius = appearanceProvider.tileCornerRadius
        background.backgroundColor = appearanceProvider.emptyTileColor
        addSubview(background)
    }

    func insertTile(position: TilePosition, value: Int) {
        let x = tilePadding + CGFloat(position.column) * (tileSideLength + tilePadding)
        let y = tilePadding + CGFloat(position.row) * (tileSideLength + tilePadding)

        let tile = TileView(position: CGPoint(x: x, y: y),
                            tileSideLength: tileSideLength,
                            value: value,
                            appearanceProvider: appearanceProvider)
        addSubview(tile)
        bringSubviewToFront(tile)
        tilesViewStorage.insertTile(tile: tile, position: position)
        animationEngine.addTileToBoard(tile: tile)
    }

    func moveOneTile(from: TilePosition, to: TilePosition, value: Int) {
        guard let startTile = tilesViewStorage.getTile(position: from) else {
            assert(false, "placeholder error")
            return
        }

        let endTile = tilesViewStorage.getTile(position: to)

        // Make the frame
        let x = tilePadding + CGFloat(to.column) * (tileSideLength + tilePadding)
        let y = tilePadding + CGFloat(to.row) * (tileSideLength + tilePadding)
        let finalFrame = CGRect(x: x, y: y, width: tileSideLength, height: tileSideLength)
        if finalFrame.width != 75.75 {
            print(finalFrame.width)
        }

        // Update board state
        tilesViewStorage.removeTile(position: from)
        tilesViewStorage.insertTile(tile: startTile, position: to)

        animationEngine.move(startTile: startTile, endTile: endTile, finalFrame: finalFrame, value: value)
    }

    func reset() {
        tilesViewStorage.reset()
    }
}

final class TilesViewStorage {
    private var tiles: Dictionary<TilePosition, TileView> = [:]

    func insertTile(tile: TileView, position: TilePosition) {
        tiles[position] = tile
    }

    func getTile(position: TilePosition) -> TileView? {
        return tiles[position]
    }

    func removeTile(position: TilePosition) {
        tiles.removeValue(forKey: position)
    }

    func reset() {
        tiles.forEach { $0.value.removeFromSuperview() }
        tiles.removeAll()
    }
}
