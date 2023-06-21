//
//  Player.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct Player: Codable {
    let id: Int
    let name: String
    let bones: Int
    let sellingItem: Item
    let persona: Persona
}
