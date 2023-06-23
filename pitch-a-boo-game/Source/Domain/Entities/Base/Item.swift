//
//  Item.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct Item: Codable, Hashable {
    let id: Int
    let name: String
    let value: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(value)
    }
}
