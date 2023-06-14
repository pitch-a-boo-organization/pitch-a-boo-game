//
//  ClientError.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

enum ClientError: LocalizedError {
    case unableToEncode
    case failWhenReceiveMessage
    
    var errorDescription: String? {
        switch self {
            case .unableToEncode:
                return "A mensagem recebida do servidor foi desconhecida"
            case .failWhenReceiveMessage:
                return "O recebimento da mensagem falhou"
        }
    }
}
