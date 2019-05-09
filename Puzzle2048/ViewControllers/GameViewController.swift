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
    private let threshold = 2048
    private let tilePadding: CGFloat = 8
    private var currentGameSession: GameSession?

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
        subscribeOnEvents()
        startButtonClicked()
        setupSwipeControls()
    }

    private func subscribeOnEvents() {
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }

    private func configureUI() {
        view.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.9607843137, alpha: 1)
    }

    private func addSubviews() {
        view.addSubview(gameboardView)
        view.addSubview(startButton)
        view.setNeedsUpdateConstraints()
    }

    private func showWinAlert() {
        let alert = UIAlertController(title: "Victory", message: "You won!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true)
    }

    private func showFailAlert() {
        let alert = UIAlertController(title: "Defeat", message: "You lost...", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true)
    }

    @objc
    func startButtonClicked() {
        currentGameSession?.finishGame()
        let gameSession: GameSession = GameSessionImp(dimension: dimension,
                                                      threshold: threshold,
                                                      gameSessionDelegate: self,
                                                      gameboardView: gameboardView)
        gameSession.startGame()
        currentGameSession = gameSession
    }

    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(upCommand))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)

        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(downCommand))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftCommand))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightCommand))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
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

extension GameViewController {
    @objc
    private func upCommand() {
        currentGameSession?.addCommand(MoveCommand(direction: .up))
    }

    @objc
    private func downCommand() {
        currentGameSession?.addCommand(MoveCommand(direction: .down))
    }

    @objc
    private func leftCommand() {
        currentGameSession?.addCommand(MoveCommand(direction: .left))
    }

    @objc
    private func rightCommand() {
        currentGameSession?.addCommand(MoveCommand(direction: .right))
    }
}

extension GameViewController: GameSessionDelegate {
    func win() {
        showWinAlert()
    }

    func lose() {
        showFailAlert()
    }
}
