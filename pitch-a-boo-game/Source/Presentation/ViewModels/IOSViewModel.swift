//
//  IOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation
import PitchABooServer

class IOSViewModel: ObservableObject {
    @Published private(set) var connected: Bool = false
    @Published private(set) var receiveFromServer: String = ""
    @Published private(set) var scannedCode: String = "Scan the TV QR code to get started."
    @Published private(set) var localUser: Player = Player.createAnUndefinedPlayer()
    @Published public var matchIsReady: Bool = false
    @Published private(set) var amIChosen: Bool = false
    @Published private(set) var chosenPlayer: ChosenPlayer = ChosenPlayer.createAnUndefinedChosenPlayer() {
        didSet {
            if chosenPlayer.player.name != "Unselected" {
                matchIsReady = true
                if chosenPlayer.player.id == localUser.id {
                    amIChosen = true
                }
            }
        }
    }

    let client = PitchABooSocketClient.shared
    
    public func setScannedCode(with code: String) {
        scannedCode = code
    }
    
    private func setLocalPlayer(_ player: Player) {
        DispatchQueue.main.async {
            self.localUser = player
        }
    }
    
    internal func setChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        self.chosenPlayer = chosenPlayer
    }
    
    public func subscribeToService() {
        client.defineServerURL(hostname: scannedCode)
        client.subscribeToService()
    }
}

extension IOSViewModel: IOSDelegate {
    func didConnectSuccessFully() {
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
    
    
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        setChosenPlayer(chosenPlayer)
    }
}
