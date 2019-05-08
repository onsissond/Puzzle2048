//
//  AppearanceProvider.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 08/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import UIKit

protocol AppearanceProvider {
    var fontForNumber: UIFont { get }
    func tileColor(for value: Int) -> UIColor
    func numberColor(for value: Int) -> UIColor
}

final class AppearanceProviderImp: AppearanceProvider {

    var fontForNumber: UIFont {
        if let font = UIFont(name: "HelveticaNeue-Bold", size: 20) {
            return font
        }
        return .systemFont(ofSize: 20)
    }

    func tileColor(for value: Int) -> UIColor {
        switch value {
        case 2: return Asset.tile2Color.color
        case 4: return Asset.tile4Color.color
        case 8: return Asset.tile8Color.color
        case 16: return Asset.tile16Color.color
        case 32: return Asset.tile32Color.color
        case 64: return Asset.tile64Color.color
        case 128: return Asset.tile128Color.color
        case 256: return Asset.tile256Color.color
        case 512: return Asset.tile512Color.color
        case 1024: return Asset.tile1024Color.color
        case 2048: return Asset.tile2048Color.color
        default: return Asset.tileLargeColor.color
        }
    }

    func numberColor(for value: Int) -> UIColor {
        switch value {
        case 2, 4: return Asset.tileNumberDarkColor.color
        default: return .white
        }
    }
}
