//
//  WebSocketClient.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation
import Network

final class PitchABooSocketClient: NSObject {
    private var baseURL = ""
    private(set) var opened = false
    private(set) var webSocket: URLSessionWebSocketTask?
    static let shared = PitchABooSocketClient()
    
    weak var iOSDelegate: IOSDelegate?
    
    func defineServerURL(hostname: String) {
        self.baseURL = "ws://\(hostname):8080"
    }
    
    private override init() { }
    
    func subscribeToService() {
        if !opened { openWebSocket() }
        guard let webSocket = webSocket else { return }
        
        webSocket.receive(completionHandler: { [weak self] result in
            print(result)
            switch result {
            case .failure(_):
                self?.iOSDelegate?.errorWhileSubscribingInService(.failWhenReceiveMessage)
            case .success(let message):
                self?.decodeServerMessage(message)
            }
            self?.subscribeToService()
        }
        )
    }
    
    private func openWebSocket() {
        if let url = URL(string: baseURL) {
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            let webSocket = session.webSocketTask(with: request)
            self.webSocket = webSocket
            self.opened = true
            self.webSocket?.resume()
        } else {
            webSocket = nil
        }
    }
    
    private func decodeServerMessage(_ serverMessage: URLSessionWebSocketTask.Message) {
        switch serverMessage {
            
        case .string:
            break
        case .data(let data):
//            print("Message: \(try! JSONSerialization.jsonObject(with: data))" )
            do {
                let message = try JSONDecoder().decode(DTOTransferMessage.self, from: data)
                print(message.device)
                handleMessageFromServer(message)
            } catch {
                iOSDelegate?.errorWhileSubscribingInService(.unableToEncode)
            }
        default:
            break
        }
    }
    
    func closeSocket() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        opened = false
        webSocket = nil
    }
}

//URL Methods
extension PitchABooSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        opened = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.webSocket = nil
        self.opened = false
    }
}

// Connection Cycle Methods
extension PitchABooSocketClient {
    // MARK: - Refactor
    func sendMessageToServer(webSocket: URLSessionWebSocketTask?, message: DTOTransferMessage) {
        guard let webSocket = webSocket else { return }
        
        dump(message)
        
        do {
            let encondedData = try JSONEncoder().encode(message)
            dump(encondedData)
            print("Enviado")
            webSocket.send(
                URLSessionWebSocketTask.Message.data(encondedData)
                
            ) { [weak self] error in
                if let _ = error {
//                    self?.socketDelegate?.failedToSend(error: .failWhenReceiveMessage)
                } else {
//                    self?.socketDelegate?.sentSuccesfully()
                }
            }
            
        } catch {
            print("PitchABooSocketClient - Cannot encode data \(error.localizedDescription)")
        }
    }
    
    func sendVerifyAvailability(stage: Int, isAvailable availability: Bool) {
        let dto = DTOVerifyAvailability(stage: stage, available: availability)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(code: CommandCode.ClientMessage.verifyAvailability.rawValue, device: .iOS, message: data)
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            print("PitchABooSocketClient - Cannot encode data \(error.localizedDescription)")
        }
    }
    
    func sendConnectSession(stage: Int, shouldSubscribe: Bool) {
        let dto = DTOConnectSession(stage: stage, subscribe: shouldSubscribe)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(code: CommandCode.ClientMessage.connectToSession.rawValue, device: .iOS, message: data)
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            print("PitchABooSocketClient - Cannot encode data \(error.localizedDescription)")
        }
    }
    
    func sendStartProcess(stage: Int, shouldStart: Bool) {
        let dto = DTOStartProcess(stage: stage, start: shouldStart)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(code: CommandCode.ClientMessage.startProcess.rawValue, device: .iOS, message: data)
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            print("PitchABooSocketClient - Cannot encode data \(error.localizedDescription)")
        }
    }
}

// MARK: - GameFlow Methods
extension PitchABooSocketClient {
    func sendStartGameFlowToServer() {
        let dto = DTOStartProcess(stage: 31, start: true)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(
                code: CommandCode.ClientMessage.startProcess.rawValue,
                device: .tvOS,
                message: data
            )
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            print("PitchABooSocketClient - StartGameFlow DTOStartProcess.data cannot be encoded \(error.localizedDescription)")
        }
    }
    
    func sendABidToServer(_ dtoBid: DTOBid) {
        let dto = DTOBid(
            stage: dtoBid.stage,
            bid: dtoBid.bid,
            player: dtoBid.player
        )
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(
                code: 5,
                device: .iOS,
                message: data
            )
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            print("PitchABooSocketClient - \(#function) DTOBid cannot be encoded \(error.localizedDescription)")
        }
    }
    
    
}

// Receiver Handlers
extension PitchABooSocketClient {
    private func decodeData<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    internal func handleMessageFromServer(_ message: DTOTransferMessage) {
        print("PitchABooSocketClient - handleMessageFromServer(); message parameter receive was \(message)")
        // Convert CommandCode that was sent as a Integer to CommandCode enum type
        guard let code = CommandCode.ServerMessage(rawValue: message.code) else { return }
        switch code {
        case .statusAvailability:
            sendConnectSession(stage: 10, shouldSubscribe: true)
        case .playerIdentifier:
            handlePlayerIdentifier(with: message)
        case .playersConnected:
            handlePlayersConnected(with: message)
            
        // GameFlowReceivers
        case .chosenPlayer:
            handleChosenPlayer(with: message)
        case .startProcess:
            handleStartProcess(with: message)
            
            
        case .saleResult:
            //Recomeca ou acaba
            break
        default:
            break
        }
    }
    
    private func handlePlayerIdentifier(with message: DTOTransferMessage) {
        do {
            let decodedLocalPlayer = try decodeData(DTOPlayerIdentifier.self, from: message.message)
            iOSDelegate?.saveLocalPlayerIdentifier(decodedLocalPlayer.player)
        } catch {
            print("PitchABooSocketClient - localPlayer cannot be decoded \(error.localizedDescription)")
        }
    }
    
    // apagar
    private func handlePlayersConnected(with message: DTOTransferMessage) {
        do {
            let decodedLocalPlayer = try decodeData(DTOPlayersConnected.self, from: message.message)
//            tvOSDelegate?.saveAllConnectedPlayers(decodedLocalPlayer.players)
        } catch {
            print("PitchABooSocketClient - connectedPlayers cannot be decoded \(error.localizedDescription)")
        }
    }
    
    // apagar
    private func handleChosenPlayer(with message: DTOTransferMessage) {
        do {
            let decodedChosenPlayer = try decodeData(DTOChosenPlayer.self, from: message.message)
            let chosenPlayer = ChosenPlayer(player: decodedChosenPlayer.player, sellingItem: decodedChosenPlayer.item)
            iOSDelegate?.saveChosenPlayer(chosenPlayer)
        } catch {
            print(print("PitchABooSocketClient - chosenPlayer cannot be decoded \(error.localizedDescription)"))
        }
    }
    
    private func handleStartProcess(with message: DTOTransferMessage) {
        do {
            let decodedStartProcess = try decodeData(DTOStartProcess.self, from: message.message)
            //Avisar ViewModel
            switch decodedStartProcess.stage {
            case 33:
                iOSDelegate?.didUpdateStage(33)
            default:
                print("caiu default")
            }
        } catch {
            print("\(#function) \(Self.self) cannot be decoded \(error.localizedDescription)")
        }
    }
}
