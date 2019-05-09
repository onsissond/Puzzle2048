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

    @IBInspectable var dimension: Int = 4
    @IBInspectable var tilePadding: CGFloat = 8

    private var appearanceProvider: AppearanceProvider = AppearanceProviderImp()

    private var tileSideLength: CGFloat {
        return (frame.width - CGFloat(dimension + 1) * tilePadding) / CGFloat(dimension)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureUI()
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

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        configureUI()
    }
}
