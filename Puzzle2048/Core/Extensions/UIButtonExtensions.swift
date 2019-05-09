//
//  UIButtonExtensions.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

extension UIButton {
    func setShadow() {
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowColor = UIColor(red: 157 / 255, green: 157 / 255, blue: 157 / 255, alpha: 1).cgColor
        layer.masksToBounds = false
    }
}
