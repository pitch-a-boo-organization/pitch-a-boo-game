//
//  DTOUpdatePlayers.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 29/06/23.
//

import Foundation
import PitchABooServer

struct DTOUpdatePlayers: Codable {
    let stage: Int
    let players: [PitchABooServer.Player]
}
