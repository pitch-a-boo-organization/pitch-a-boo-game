//
//  ClientOutputSpy.swift
//  pitch-a-boo-gameTests
//
//  Created by Thiago Henrique on 04/07/23.
//

import Foundation
@testable import pitch_a_boo_game

class ClientOutputSpy {
    private(set) var receivedMessages: [Message] = [Message]()
    
    enum Message: Equatable {
        case didConnectSuccessFully
        case errorWhileSubscribingInService(ClientError)
        case saveLocalPlayerIdentifier(Player)
        case saveChosenPlayer(ChosenPlayer)
        case didUpdateStage(Int)
        case didFinishInning(result: SaleResult)
        case errorWhileSendindMessageToServer(ClientError)
        case errorWhileReceivingMessageFromServer(ClientError)
        
        var description: String {
            switch self {
                case .didConnectSuccessFully:
                    return "didConnectSuccessFully was called"
                case .errorWhileSubscribingInService(let error):
                return "errorWhileSubscribingInService was called with error: \(error.localizedDescription)"
                case .saveLocalPlayerIdentifier(let player):
                return "saveLocalPlayerIdentifier was called with player: \(player.name)"
                case .saveChosenPlayer(let choosenPlayer):
                return "saveChosenPlayer was called with choosen player: \(choosenPlayer.player.name)"
                case .didUpdateStage(let stage):
                    return "didUpdateStage was called with stage: \(stage)"
                case .didFinishInning(let result):
                    return "didFinishInning was called with result: \(result.soldValue)"
                case .errorWhileSendindMessageToServer(let error):
                return "errorWhileSendindMessageToServer was called with error: \(error.localizedDescription)"
                case .errorWhileReceivingMessageFromServer(let error):
                return "errorWhileReceivingMessageFromServer was called with error: \(error.localizedDescription)"
            }
        }
    }
    
}

extension ClientOutputSpy: PitchABooClientOutput {
    func didConnectSuccessFully() {
        receivedMessages.append(.didConnectSuccessFully)
    }
    
    func errorWhileSubscribingInService(_ error: ClientError) {
        receivedMessages.append(.errorWhileSubscribingInService(error))
    }
    
    func saveLocalPlayerIdentifier(_ player: Player) {
        receivedMessages.append(.saveLocalPlayerIdentifier(player))
    }
    
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        receivedMessages.append(.saveChosenPlayer(chosenPlayer))
    }
    
    func didUpdateStage(_ stage: Int) {
        receivedMessages.append(.didUpdateStage(stage))
    }
    
    func didFinishInning(with result: SaleResult) {
        receivedMessages.append(.didFinishInning(result: result))
    }
    
    func errorWhileSendindMessageToServer(_ error: ClientError) {
        receivedMessages.append(.errorWhileSendindMessageToServer(error))
    }
    
    func errorWhileReceivingMessageFromServer(_ error: ClientError) {
        receivedMessages.append(.errorWhileReceivingMessageFromServer(error))
    }
}
