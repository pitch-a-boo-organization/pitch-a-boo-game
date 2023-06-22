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

extension Player {
    static func createAnUndefinedPlayer() -> Player {
        Player(id: 0, name: "Undefined", bones: 0, sellingItem: Item(id: 0, name: "None", value: 0), persona: Persona(id: 0, name: "None", characteristics: ["Unknown"]))
    }
}
