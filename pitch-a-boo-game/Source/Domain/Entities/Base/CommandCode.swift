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
        case pauseSession = 10
        case resumeSession = 11
    }
    
    enum ServerMessage: Int, Codable {
        case statusAvailability = 1
        case connectStatus = 3
        case playersConnected = 6
        case startProcess = 4
        case chosenPlayer = 7
        case saleResult = 8
        case playerIdentifier = 9
    }
}
