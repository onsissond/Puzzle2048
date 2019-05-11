//
//  TileObject.swift
//  Puzzle2048
//
//  Created by Евгений Суханов on 09/05/2019.
//  Copyright © 2019 Евгений Суханов. All rights reserved.
//

enum TileObject: Equatable {
    case empty, tile(Int)
}

extension TileObject: Codable {

    enum CodingKeys: CodingKey {
        case value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(Int.self, forKey: .value)
        if rawValue > 0 {
            self = .tile(rawValue)
        } else {
            self = .empty
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .empty: try container.encode(-1, forKey: .value)
        case .tile(let value): try container.encode(value, forKey: .value)
        }
    }
}
