//
//  PitchABooClientOutput.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation

protocol PitchABooClientOutput: AnyObject {
    func didConnectSuccessFully()
    func errorWhileSubscribingInService(_ error: ClientError)
    func saveLocalPlayerIdentifier(_ player: Player)
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer)
    func didUpdateStage(_ stage: Int)
    func didFinishInning(with result: SaleResult)
    func errorWhileSendindMessageToServer(_ error: ClientError)
    func errorWhileReceivingMessageFromServer(_ error: ClientError)
}
