//
//  AnimationEngine.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

final class AnimationEngine {

    private let tilePopStartScale: CGFloat = 0.1
    private let tilePopMaxScale: CGFloat = 1.1
    private let tilePopDelay: TimeInterval = 0.05
    private let tileExpandTime: TimeInterval = 0.18
    private let tileContractTime: TimeInterval = 0.08

    private let tileMergeStartScale: CGFloat = 1.0
    private let tileMergeExpandTime: TimeInterval = 0.08
    private let tileMergeContractTime: TimeInterval = 0.08

    private let perSquareSlideDuration: TimeInterval = 0.08

    func addTileToBoard(tile: UIView) {
        tile.layer.setAffineTransform(CGAffineTransform(scaleX: tilePopStartScale, y: tilePopStartScale))

        UIView.animate(withDuration: tileExpandTime, delay: tilePopDelay, options: [], animations: {
            // Make the tile 'pop'
            tile.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopMaxScale, y: self.tilePopMaxScale))
        }, completion: { _ in
            // Shrink the tile after it 'pops'
            UIView.animate(withDuration: self.tileContractTime, animations: { () -> Void in
                tile.layer.setAffineTransform(CGAffineTransform.identity)
            })
        })
    }

    func move(startTile: TileView, endTile: TileView?, finalFrame: CGRect, value: Int) {
        let shouldPop = endTile != nil
        UIView.animate(withDuration: perSquareSlideDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.beginFromCurrentState,
                       animations: {
                        // Slide tile
                        startTile.frame = finalFrame
        }, completion: { finished in
            startTile.value = value
            endTile?.removeFromSuperview()

            if !shouldPop { return }

            startTile.layer.setAffineTransform(CGAffineTransform(scaleX: self.tileMergeStartScale, y: self.tileMergeStartScale))
            // Pop tile
            UIView.animate(withDuration: self.tileMergeExpandTime,
                           animations: {
                            startTile.layer.setAffineTransform(CGAffineTransform(scaleX: self.tilePopMaxScale, y: self.tilePopMaxScale))
            }, completion: { _ in
                // Contract tile to original size
                UIView.animate(withDuration: self.tileMergeContractTime, animations: {
                    startTile.layer.setAffineTransform(CGAffineTransform.identity)
                })
            })
        })
    }
}
