//
//  CommandCode.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 20/06/23.
//

import Foundation

enum CommandCode: Codable {
    case client(ClientMessage)
    case server(ServerMessage)
    
    enum ClientMessage: Int, Codable {
        case verifyAvailability = 0
        case connectToSession = 2
        case bid = 5
        case startProcess = 4
    }
    
    enum ServerMessage: Int, Codable {
        case availabilityStatus = 1
        case connectionStatus = 3
        case startProcess = 4
        case connectedPlayers = 6
        case choosenPlayer = 7
        case saleResult = 8
    }
}
