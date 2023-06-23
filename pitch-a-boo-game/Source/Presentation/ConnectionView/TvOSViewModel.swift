//
//  TvOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation

class TvOSViewModel: ObservableObject {
    
}

extension TvOSViewModel: TvOSDelegate {
    func saveAllConnectedPlayers(_ players: [Player]) {
        
    }
}

extension TvOSViewModel: SocketDelegate {
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        
    }
    
    func sentSuccesfully() {
        
    }
    
    func failedToSend(error: ClientError) {
        
    }
}
