//
//  TvOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation
import PitchABooServer

class TvOSViewModel: ObservableObject {
    @Published var server = try! PitchABooWebSocketServer(port: 8080)
    @Published var players: [PitchABooServer.Player] = []
    
    let client = PitchABooSocketClient.shared
}

extension TvOSViewModel: PitchABooServer.ServerOutputs {
    func didDefineSellingPlayer(_ player: PitchABooServer.Player) {
        //Define server player
    }
    
    func inningEnd(players: [PitchABooServer.Player], gameEnded: Bool, result: PitchABooServer.SaleResult) {
        //Define inning end
    }
    
    func didConectPlayer(players: [PitchABooServer.Player]) {
        DispatchQueue.main.async { [weak self] in
            self?.players = players
        }
    }
}
