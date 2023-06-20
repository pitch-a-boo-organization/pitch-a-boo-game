//
//  Item.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct Item: Codable {
    let id: Int
    let name: String
    let bonusScore: Int
    let persona: Persona
    let value: Int
}
