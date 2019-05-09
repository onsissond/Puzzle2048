//
//  GaveViewController.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 08/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

final class GameViewController: UIViewController {

    private var needUpdateConstraints = true
    private let dimension = 4
    private let tilePadding: CGFloat = 8

    private lazy var gameboardView: GameboardView = {
        let gameboardView = GameboardView(dimension: dimension,
                                          tilePadding: tilePadding,
                                          tileSideLength: tileSideLength)
        gameboardView.translatesAutoresizingMaskIntoConstraints = false
        return gameboardView
    }()

    private var gameboardViewWidth: CGFloat {
        return view.frame.width - 32
    }

    private var tileSideLength: CGFloat {
        return (gameboardViewWidth - CGFloat(dimension + 1) * tilePadding) / CGFloat(dimension)
    }

    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Попробовать ещё раз", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.cornerRadius = 8
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.setShadow()
        return button
    }()


    override func loadView() {
        super.loadView()

        addSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setTestData()
    }

    private func setTestData() {
        var value = 2
        for row in 0..<dimension {
            for column in 0..<dimension {
                gameboardView.insertTile(row: row, column: column, value: value)
                value *= 2
            }
        }
    }

    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9607843137, alpha: 1)
    }

    private func addSubviews() {
        view.addSubview(gameboardView)
        view.addSubview(startButton)
        view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if needUpdateConstraints {
            gameboardView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            gameboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            gameboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16).isActive = true
            gameboardView.heightAnchor.constraint(equalTo: gameboardView.widthAnchor).isActive = true

            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

            needUpdateConstraints = false
        }

        super.updateViewConstraints()
    }
}
