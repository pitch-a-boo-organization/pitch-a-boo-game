//
//  TvOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation
import PitchABooServer
import Network
import Combine

struct DummyConnection: Connection {
    func send(content: Data?, contentContext: NWConnection.ContentContext, isComplete: Bool, completion: NWConnection.SendCompletion) {
        
    }
}

public final class TvOSViewModel: ObservableObject {
    @Published var server = try! PitchABooWebSocketServer(port: 8080)
    @Published var isMatchReady: Bool = false
    @Published var inningHasStarted: Bool = false
    @Published var sellingPlayer: PitchABooServer.Player?
    @Published var players: [PitchABooServer.Player] = [] {
        didSet {
            if players.count >= 2 {
                isMatchReady = true
            }
        }
    }
    
    @Published var bidPlayersSent: [BidPlayer] = []
    @Published var inningResult: PitchABooServer.SaleResult?
    @Published var gameEnded: Bool = false
    
    var cancellable: Set<AnyCancellable> = []
    
    func sendMessageToServer(_ message: PitchABooServer.TransferMessage) {
        let dummyConnection = DummyConnection()
        server.router.redirectMessage(message, from: dummyConnection)
    }
    
    func sendStartStage(_ stage: Int) {
        print("SENDING START STAGE: \(stage)")
        let transferMessage = PitchABooServer.TransferMessage(
            code: CommandCode.ClientMessage.startProcess.rawValue,
            device: .tvOS,
            message: try! JSONEncoder().encode(
                DTOStartProcess(
                    stage: stage, start: true
                )
            )
        )
        sendMessageToServer(transferMessage)
    }
    
    func updateScore(with saleResult: PitchABooServer.SaleResult) {
        guard let sellerPlayerIndex = players.firstIndex(where: { $0.id == saleResult.seller.id }) else {
            return
        }
        players[sellerPlayerIndex].bones -= saleResult.item.value
        players[sellerPlayerIndex].bones += saleResult.soldValue
        
        guard let buyerIndex = players.firstIndex(where: { $0.id == saleResult.buyer.id }) else { return }
        players[buyerIndex].bones -= saleResult.soldValue
        players[buyerIndex].bones += saleResult.item.value
    }
}

extension TvOSViewModel: PitchABooServer.ServerOutputs {
    public func didReceiveBid(bid: Int, from player: PitchABooServer.Player) {
        print("RECEIVE BID")
        let newBid = BidPlayer(id: player.id, namePlayer: player.name, bidSent: bid)
        DispatchQueue.main.async {
            self.bidPlayersSent.append(newBid)
        }
    }
    
    public func didDefineSellingPlayer(_ player: PitchABooServer.Player) {
        DispatchQueue.main.async { [weak self] in
            self?.inningHasStarted = true
            self?.sellingPlayer = player
        }
    }
    
    public func inningEnd(players: [PitchABooServer.Player], gameEnded: Bool, result: PitchABooServer.SaleResult) {
        DispatchQueue.main.async {
            self.gameEnded = gameEnded
            self.inningResult = result
            self.updateScore(with: result)
        }
        //Define inning end
    }
    
    public func didConectPlayer(players: [PitchABooServer.Player]) {
        DispatchQueue.main.async { [weak self] in
            self?.players = players
        }
    }
}
