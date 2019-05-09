//
//  AppearanceProvider.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 08/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

protocol AppearanceProvider: class {
    var fontForNumber: UIFont { get }
    var emptyTileColor: UIColor { get }
    var tileCornerRadius: CGFloat { get }
    func tileColor(for value: Int) -> UIColor
    func numberColor(for value: Int) -> UIColor
}

final class AppearanceProviderImp: AppearanceProvider {

    let emptyTileColor: UIColor = #colorLiteral(red: 0.719076395, green: 0.7572361827, blue: 0.8003209233, alpha: 1)

    let tileCornerRadius: CGFloat = 5

    var fontForNumber: UIFont {
        let fontSize: CGFloat = 35
        if let font = UIFont(name: "HelveticaNeue-Bold", size: fontSize) {
            return font
        }
        return .systemFont(ofSize: fontSize)
    }

    func tileColor(for value: Int) -> UIColor {
        switch value {
        case 2: return #colorLiteral(red: 1, green: 0.9960784314, blue: 1, alpha: 1)
        case 4: return #colorLiteral(red: 0.8823529412, green: 0.8862745098, blue: 0.9019607843, alpha: 1)
        case 8: return #colorLiteral(red: 0.60048908, green: 0.8670039177, blue: 0.9981275201, alpha: 1)
        case 16: return #colorLiteral(red: 0.360855341, green: 0.702457726, blue: 1, alpha: 1)
        case 32: return #colorLiteral(red: 0.1140697077, green: 0.5420951247, blue: 0.9218869805, alpha: 1)
        case 64: return #colorLiteral(red: 0, green: 0.3908238411, blue: 0.8406992555, alpha: 1)
        case 128: return #colorLiteral(red: 0.002454198431, green: 0.2862189114, blue: 0.7203387618, alpha: 1)
        case 256: return #colorLiteral(red: 0.1048474088, green: 0.2452811897, blue: 0.5199166536, alpha: 1)
        case 512: return #colorLiteral(red: 0.04072859138, green: 0.1679205298, blue: 0.5221081376, alpha: 1)
        case 1024: return #colorLiteral(red: 0.02905680798, green: 0.09291843325, blue: 0.7193281054, alpha: 1)
        case 2048: return #colorLiteral(red: 0.06574276835, green: 0.02078279667, blue: 0.4381928444, alpha: 1)
        default: return #colorLiteral(red: 0.06574276835, green: 0.02078279667, blue: 0.4381928444, alpha: 1)
        }
    }

    func numberColor(for value: Int) -> UIColor {
        return value <= 32 ? .black : .white
    }
}
