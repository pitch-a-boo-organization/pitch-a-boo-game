//
//  IOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation
import Combine
import PitchABooServer

class IOSViewModel: ObservableObject {
    
    // MARK: - Connection Properties
    @Published private(set) var connected: Bool = false
    @Published private(set) var receiveFromServer: String = ""
    @Published private(set) var scannedCode: String = "Scan the TV QR code to get started."
    
    // MARK: - Gameflow Properties
    @Published private(set) var localUser: Player = Player.createAnUndefinedPlayer()
    @Published public var matchIsReady: Bool = false
    @Published private(set) var amIChosen: Bool = false
    @Published private(set) var currentStage: Int = 0
    @Published private(set) var chosenPlayer: ChosenPlayer = ChosenPlayer.createAnUndefinedChosenPlayer()
    
    // MARK: - BidView Properties
    @Published private(set) var playerBidValue: Int = 0
    
    // MARK: -General Properties
    var cancellable: Set<AnyCancellable> = []
    
    func resetToNewRound() {
        amIChosen = false
        chosenPlayer = ChosenPlayer.createAnUndefinedChosenPlayer()
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
        print("NEW CHOOSEN PLAYER: \(chosenPlayer)")
        DispatchQueue.main.async {
            self.chosenPlayer = chosenPlayer
            self.matchIsReady = true
            if chosenPlayer.player.id == self.localUser.id {
                print("AM I CHOOSEN!")
                self.amIChosen = true
            }
        }
    }
    
    public func subscribeToService() {
        client.defineServerURL(hostname: scannedCode)
        client.subscribeToService()
    }
}

extension IOSViewModel: IOSDelegate {
    func didFinishInning(with result: SaleResult) {
        
    }
    
    func didUpdateStage(_ stage: Int) {
        print("Did update stage: \(stage)")
        DispatchQueue.main.async {
            self.currentStage = stage
        }
    }
    
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
        print("Receiving a new choosen player")
        setChosenPlayer(chosenPlayer)
    }
}

// MARK: - BidView Methods
extension IOSViewModel {
    public func sendBid() {
        let dto = DTOBid(stage: 33, bid: playerBidValue, player: localUser)
        client.sendABidToServer(dto)
    }
    
    internal func plusBidValue() {
        if verifyBidValueLimit() {
            playerBidValue += 1
        }
    }
    
    internal func minusBidValue() {
        if verifyBidValueLimit() {
            if playerBidValue > 0 {
                playerBidValue -= 1
                return
            }
            playerBidValue = 0
        }
    }
    
    private func verifyBidValueLimit() -> Bool {
        if playerBidValue < localUser.bones {
            return true
        }
        return false
    }
    
    
}
