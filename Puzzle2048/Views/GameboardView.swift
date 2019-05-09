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

    private var appearanceProvider: AppearanceProvider = AppearanceProviderImp()

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

    func insertTile(row: Int, column: Int, value: Int) {
        let x = tilePadding + CGFloat(column) * (tileSideLength + tilePadding)
        let y = tilePadding + CGFloat(row) * (tileSideLength + tilePadding)

        let tile = TileView(position: CGPoint(x: x, y: y),
                            tileSideLength: tileSideLength,
                            value: value,
                            appearanceProvider: appearanceProvider)
        addSubview(tile)
        bringSubviewToFront(tile)
    }
}
