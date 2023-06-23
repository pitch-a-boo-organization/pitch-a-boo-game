//
//  TvOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation
import PitchABooServer

class TvOSViewModel: ObservableObject {
    @Published private(set) var receiveFromServer: String = ""
    @Published private(set) var allConnectedPlayers: [Player] = []
    @Published private(set) var chosenPlayer: ChosenPlayer = ChosenPlayer.createAnUndefinedChosenPlayer()
    var server: PitchABooWebSocketServer!
    let client = PitchABooSocketClient.shared
    
    private func setAllConnectedPlayers(_ players: [Player]) {
        DispatchQueue.main.async {
            self.allConnectedPlayers = players
        }
    }
    
    internal func setChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        self.chosenPlayer = chosenPlayer
    }
}

extension TvOSViewModel: TvOSDelegate {
    func saveAllConnectedPlayers(_ players: [Player]) {
        setAllConnectedPlayers(players)
    }
}

extension TvOSViewModel: SocketDelegate {
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        setChosenPlayer(chosenPlayer)
    }
    
    func sentSuccesfully() {
        
    }
    
    func failedToSend(error: ClientError) {
        
    }
}
