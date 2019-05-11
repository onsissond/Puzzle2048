//
//  GameSessionStorage.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 11/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

import Foundation

protocol GameSessionStorage {
    func save(gameboard: SquareGameboard)
    func restore() -> SquareGameboard?
}

final class UserDefaultsGameSessionStorage: GameSessionStorage {

    private let storage = UserDefaults(suiteName: "sessionStorage")!

    private enum UserDefaultsKey: String {
        case gameboard
    }

    func save(gameboard: SquareGameboard) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(gameboard) {
            storage.set(encoded, forKey: UserDefaultsKey.gameboard.rawValue)
        }
    }

    func restore() -> SquareGameboard? {
        if let savedGameboard = storage.object(forKey: UserDefaultsKey.gameboard.rawValue) as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(SquareGameboard.self, from: savedGameboard)
        }
        return nil
    }
}
