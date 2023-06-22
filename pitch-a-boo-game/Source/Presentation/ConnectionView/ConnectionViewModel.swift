//
//  ViewModel.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation
import PitchABooServer

class ConnectionViewModel: ObservableObject {
    @Published private(set) var connected: Bool = false
    @Published private(set) var receiveFromServer: String = ""
    @Published private(set) var scannedCode: String = "Scan the TV QR code to get started."
    @Published private(set) var localUser: Player = Player.createAnUndefinedPlayer()
    @Published private(set) var allConnectedPlayers: [Player] = []
    
    @Published private(set) var chosenPlayer: ChosenPlayer = ChosenPlayer.createAnUndefinedChosenPlayer()
    
    private(set) var server: PitchABooWebSocketServer = try! PitchABooWebSocketServer(port: 8080)
    
    public func setScannedCode(with code: String) {
        scannedCode = code
    }
    
    private func setLocalPlayer(_ player: Player) {
        DispatchQueue.main.async {
            self.localUser = player
        }
        
    }
    
    private func setAllConnectedPlayers(_ players: [Player]) {
        DispatchQueue.main.async {
            self.allConnectedPlayers = players
        }
        
    }
    
    internal func setChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        self.chosenPlayer = chosenPlayer
    }
}

extension ConnectionViewModel: PitchABooSocketDelegate {
    func updateCounter(_ value: String) {
        DispatchQueue.main.async {
            self.receiveFromServer = value
        }
    }
    
    func didConnectSuccessfully() {
        print("Connected")
        DispatchQueue.main.async {
            self.connected = true
        }
    }
    
    func errorWhileSubscribingInService(_ error: ClientError) {
        print("Error in subscribing: \(error.localizedDescription)")
    }
    
    func saveLocalPlayerIdentifier(_ player: Player) {
        setLocalPlayer(player)
    }
    
    func saveAllConnectedPlayers(_ players: [Player]) {
        setAllConnectedPlayers(players)
    }
    
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        setChosenPlayer(chosenPlayer)
    }
}
