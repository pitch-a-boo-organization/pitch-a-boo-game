//
//  TvOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation
import PitchABooServer
import Network

struct DummyConnection: Connection {
    func send(content: Data?, contentContext: NWConnection.ContentContext, isComplete: Bool, completion: NWConnection.SendCompletion) {
        
    }
}

public final class TvOSViewModel: ObservableObject {
    @Published var server = try! PitchABooWebSocketServer(port: 8080)
    @Published var isMatchReady: Bool = false
    @Published var inningHasStarted: Bool = false
    @Published var players: [PitchABooServer.Player] = [] {
        didSet {
            if players.count >= 2 {
                isMatchReady = true
            }
        }
    }
    
    public func startGameFlow() {
        let transferMessage = PitchABooServer.TransferMessage(
            code: CommandCode.ClientMessage.startProcess.rawValue,
            device: .tvOS,
            message: try! JSONEncoder().encode(DTOStartProcess(stage: 31, start: true))
        )
        let dummyConnection = DummyConnection()
        server.router.redirectMessage(transferMessage, from: dummyConnection)
    }
}

extension TvOSViewModel: PitchABooServer.ServerOutputs {
    public func didDefineSellingPlayer(_ player: PitchABooServer.Player) {
        DispatchQueue.main.async { [weak self] in
            self?.inningHasStarted = true
        }
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
