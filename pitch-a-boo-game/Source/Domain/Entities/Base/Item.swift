//
//  Item.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct Item: Codable, Hashable {
    public let id: Int
    public let name: String
    public let value: Int
    public let characteristic: Characteristic
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(value)
        hasher.combine(characteristic)
    }
}

extension Item {
    static let availableItems: [Item] = [
        Item(id: 1, name: "Mad Scientist Brain", value: 6, characteristic: .collectionner),
        Item(id: 2, name: "Pen", value: 3, characteristic: .collectionner),
        Item(id: 3, name: "Chainsaw Hand", value: 4, characteristic: .extroverted),
        Item(id: 4, name: "Pumpkin", value: 3, characteristic: .playful),
        Item(id: 5, name: "Comfy Socks", value: 5, characteristic: .playful),
        Item(id: 6, name: "Witch Hat", value: 6, characteristic: .extroverted),
    ].shuffled()
}
