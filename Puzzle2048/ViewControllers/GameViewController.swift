//
//  GaveViewController.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 08/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

final class GameViewController: UIViewController {

    @IBOutlet weak var gameboardView: GameboardView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        var value = 2
        for row in 0..<gameboardView.dimension {
            for column in 0..<gameboardView.dimension {
                gameboardView.insertTile(row: row, column: column, value: value)
                value *= 2
            }
        }
    }
}
