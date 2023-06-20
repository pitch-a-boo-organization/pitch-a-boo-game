//
//  CommandCode.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

enum CommandCode: Int, Codable {
    case connectionAvailability = 0
    case availabilityStatus = 1
    case connectToSession = 2
    case connectionStatus = 3
    case startGame = 4
    case bid = 5
    case connectedPlayers = 6
    case selectedPlayer = 7
    case saleResult = 8
}
