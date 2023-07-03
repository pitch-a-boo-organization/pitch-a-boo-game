//
//  PitchABooClient.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation

protocol PitchABooClient {
    var output: PitchABooClientOutput? { get set }
    func defineServerURL(hostname: String)
    func subscribeToService()
    func closeSocket()
    func pauseSessionMessage(with player: Player)
    func resumeSession(to player: Player)
    func sendBid(_ dtoBid: DTOBid)
}
