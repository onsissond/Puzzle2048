//
//  TileView.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 08/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

final class TileView: UIView {

    private weak var delegate: AppearanceProvider!

    var value: Int = 0 {
        didSet {
            configureUI()
        }
    }

    private lazy var numberLabel: UILabel = {
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(position: CGPoint,
         tileSideLength: CGFloat,
         value: Int,
         appearanceProvider: AppearanceProvider) {
        super.init(frame: CGRect(x: position.x, y: position.y, width: tileSideLength, height: tileSideLength))

        self.value = value
        self.delegate = appearanceProvider
        layer.cornerRadius = delegate.tileCornerRadius
        numberLabel.font = delegate.fontForNumber

        addSubviews()
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(numberLabel)
    }

    private func configureUI() {
        backgroundColor = delegate.tileColor(for: value)
        numberLabel.textColor = delegate.numberColor(for: value)
        numberLabel.text = "\(value)"
    }

    override func updateConstraints() {

        numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        numberLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        super.updateConstraints()
    }
}
