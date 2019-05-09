//
//  GameSessionDelegate.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import Foundation

protocol GameSessionDelegate: class {
    func win()
    func lose()
}
