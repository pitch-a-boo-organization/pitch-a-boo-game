//
//  TvOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation
import PitchABooServer

public final class TvOSViewModel: ObservableObject {
    @Published var server = try! PitchABooWebSocketServer(port: 8080)
    @Published var isMatchReady: Bool = false
    @Published var players: [PitchABooServer.Player] = [] {
        didSet {
            if players.count >= 2 {
                isMatchReady = true
            }
        }
    }
    
    internal let client = PitchABooSocketClient.shared
}

extension TvOSViewModel: PitchABooServer.ServerOutputs {
    public func didDefineSellingPlayer(_ player: PitchABooServer.Player) {
        //Define server player
    }
    
    public func inningEnd(players: [PitchABooServer.Player], gameEnded: Bool, result: PitchABooServer.SaleResult) {
        //Define inning end
    }
    
    public func didConectPlayer(players: [PitchABooServer.Player]) {
        DispatchQueue.main.async { [weak self] in
            self?.players = players
        }
    }
}
