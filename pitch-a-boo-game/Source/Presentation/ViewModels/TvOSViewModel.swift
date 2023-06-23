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
    func didConectPlayer(players: [PitchABooServer.Player]) {
        DispatchQueue.main.async { [weak self] in
            self?.players = players
        }
    }
}
