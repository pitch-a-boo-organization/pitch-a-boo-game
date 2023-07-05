//
//  ChosenPlayer.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 21/06/23.
//

import Foundation

struct ChosenPlayer: Codable, Equatable {
    var player: Player
    var sellingItem: Item
}

extension ChosenPlayer {
    static func createAnUndefinedChosenPlayer() -> ChosenPlayer {
        return ChosenPlayer(
            player: Player(
                id: 0,
                name: "Unselected",
                bones: 0,
                sellingItem: Item(
                    id: 0,
                    name: "none",
                    value: 0,
                    characteristic: .athletic
                ),
                persona: Persona(
                    id: 0,
                    name: "unknown",
                    characteristics: []
                )
            ),
            sellingItem: Item(id: 0, name: "unselected", value: 0, characteristic: .athletic)
        )
    }
}
