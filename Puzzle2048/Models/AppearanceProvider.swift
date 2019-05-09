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

    let emptyTileColor: UIColor = #colorLiteral(red: 0.7882352941, green: 0.7529411765, blue: 0.6980392157, alpha: 1)

    let tileCornerRadius: CGFloat = 3

    var fontForNumber: UIFont {
        let fontSize: CGFloat = 35
        if let font = UIFont(name: "HelveticaNeue-Bold", size: fontSize) {
            return font
        }
        return .systemFont(ofSize: fontSize)
    }

    func tileColor(for value: Int) -> UIColor {
        switch value {
        case 2: return #colorLiteral(red: 0.9333333333, green: 0.8941176471, blue: 0.8549019608, alpha: 1)
        case 4: return #colorLiteral(red: 0.9294117647, green: 0.8784313725, blue: 0.7843137255, alpha: 1)
        case 8: return #colorLiteral(red: 0.9490196078, green: 0.6941176471, blue: 0.4745098039, alpha: 1)
        case 16: return #colorLiteral(red: 0.9607843137, green: 0.5843137255, blue: 0.3882352941, alpha: 1)
        case 32: return #colorLiteral(red: 0.9647058824, green: 0.4862745098, blue: 0.3725490196, alpha: 1)
        case 64: return #colorLiteral(red: 0.9647058824, green: 0.368627451, blue: 0.231372549, alpha: 1)
        case 128: return #colorLiteral(red: 0.9058823529, green: 0.8078431373, blue: 0.4901960784, alpha: 1)
        case 256: return #colorLiteral(red: 0.9058823529, green: 0.8039215686, blue: 0.4431372549, alpha: 1)
        case 512: return #colorLiteral(red: 0.9019607843, green: 0.7843137255, blue: 0.3882352941, alpha: 1)
        case 1024: return #colorLiteral(red: 0.9058823529, green: 0.7725490196, blue: 0.3568627451, alpha: 1)
        case 2048: return #colorLiteral(red: 0.9058823529, green: 0.7647058824, blue: 0.3058823529, alpha: 1)
        default: return #colorLiteral(red: 0.231372549, green: 0.2274509804, blue: 0.2, alpha: 1)
        }
    }

    func numberColor(for value: Int) -> UIColor {
        switch value {
        case 2, 4: return #colorLiteral(red: 0.4588235294, green: 0.431372549, blue: 0.4078431373, alpha: 1)
        default: return .white
        }
    }
}
