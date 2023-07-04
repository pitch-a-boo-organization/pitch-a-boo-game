//
//  ClientError.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

enum ClientError: LocalizedError, Equatable {
    case unableToEncode
    case unableToDecode
    case failWhenReceiveMessage
    case cantConnectToServer
    case failWhenSendingMessage
    
    var errorDescription: String? {
        switch self {
            case .unableToEncode:
                return "Não foi possível enviar a mensagem para o servidor com sucesso!"
            case .unableToDecode:
                    return "A mensagem recebida do servidor foi desconhecida!"
            case .failWhenReceiveMessage:
                return "O recebimento da mensagem falhou"
            case .cantConnectToServer:
                return "A solicitação de conexão foi enviada, porém, a conexão não foi estabelecida"
            case .failWhenSendingMessage:
                return "Ocorreu um erro ao enviar uma mensagem para o servidor"
        }
    }
}
