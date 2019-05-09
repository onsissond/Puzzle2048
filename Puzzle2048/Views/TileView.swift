//
//  TileView.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 08/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

final class TileView: UIView {

    private var needUpdateConstraints = true

    private weak var delegate: AppearanceProvider!

    var value: Int = 0 {
        didSet {
            configureUI()
        }
    }

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.minimumScaleFactor = 0.2
        label.adjustsFontSizeToFitWidth = true
        label.baselineAdjustment = .alignCenters
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        setNeedsUpdateConstraints()
    }

    private func configureUI() {
        backgroundColor = delegate.tileColor(for: value)
        numberLabel.textColor = delegate.numberColor(for: value)
        numberLabel.text = "\(value)"
    }

    override func layoutSubviews() {
        numberLabel.sizeToFit()
    }

    override func updateConstraints() {
        if needUpdateConstraints {
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

            needUpdateConstraints = false
        }

        super.updateConstraints()
    }
}
