//
//  WebSocketError.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

enum WebSocketError: LocalizedError {
    case unableToStartInPort(UInt16)
    case unableToInitializeListener
    case serverInitializationFail(String?)
    case cantHandleClientConnection
    
    var errorDescription: String? {
        switch self {
            case .unableToStartInPort(let port):
                return "Não foi possível iniciar o servidor na porta: \(port)"
            case .unableToInitializeListener:
                return "Não foi possível iniciar a comunicação com o servidor"
            case .serverInitializationFail(let error):
                return "A inicialização do servidor falhou \(error ?? "")"
            case .cantHandleClientConnection:
                return "Não foi possível iniciar a comunicação com o client"
        }
    }
}
