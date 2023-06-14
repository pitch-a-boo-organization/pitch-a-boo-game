//
//  ServerMessageHandler.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

class ServerMessageHandler {
    let type: MessageType
    
    init(type: MessageType) { self.type = type }
    
    func handle() {
        switch type {
            case .connection:
                break
        }
    }
}
