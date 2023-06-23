//
//  Persona.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

struct Persona: Codable, Hashable {
    let id: Int
    let name: String
    let characteristics: [String]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(characteristics)
    }
}
