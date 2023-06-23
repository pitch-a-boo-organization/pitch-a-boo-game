//
//  WebSocketClient.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation
import Network

protocol PitchABooSocketDelegate: AnyObject {
    func didConnectSuccessfully() // iOS
    func errorWhileSubscribingInService(_ error: ClientError) // iOS
    func updateCounter(_ value: String) // APAGAR
    func saveLocalPlayerIdentifier(_ player: Player) // iOS
    func saveAllConnectedPlayers(_ players: [Player]) // TV
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer) // TODOS
}

final class PitchABooSocketClient: NSObject {
    private var baseURL = ""
    private(set) var opened = false
    private(set) var webSocket: URLSessionWebSocketTask?
    
    weak var delegate: PitchABooSocketDelegate? //APAGAR
    
    weak var iOSDelegate: IOSDelegate?
    weak var tvOSDelegate: TvOSDelegate?
    weak var socketDelegate: SocketDelegate?
    
    static let shared = PitchABooSocketClient()
    
    func defineServerURL(hostname: String) {
        self.baseURL = "ws://\(hostname):8080"
    }
    
    func subscribeToService() {
        if !opened { openWebSocket() }
        guard let webSocket = webSocket else { return }
        
        webSocket.receive(completionHandler: { [weak self] result in
            print(result)
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                self?.delegate?.errorWhileSubscribingInService(.failWhenReceiveMessage)
            case .success(let message):
                self?.decodeServerMessage(message)
            }
            self?.subscribeToService()
        }
        )
    }
    
    private func subscribeToServer() {
        guard let webSocket = webSocket else { return }
        let transferMessage = TransferMessage(
            type: .connection,
            message: "subscribe"
        )
        sendMessageToServer(webSocket: webSocket, message: transferMessage)
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
                delegate?.errorWhileSubscribingInService(.unableToEncode)
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
    
    //Deprecated
    func sendMessageToServer(webSocket: URLSessionWebSocketTask?, message: TransferMessage) {
        guard let webSocket = webSocket else { return }
        
        do {
            let encondedData = try JSONEncoder().encode(message)
            webSocket.send(
                URLSessionWebSocketTask.Message.data(encondedData)
            ) { [weak self] error in
                if let _ = error {
                    self?.delegate?.errorWhileSubscribingInService(.cantConnectToServer)
                } else {
                    self?.delegate?.didConnectSuccessfully()
                }
            }
            
        } catch {
            print("PitchABooSocketClient - Cannot encode data \(error.localizedDescription)")
        }
    }
    
    
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
                    self?.delegate?.errorWhileSubscribingInService(.cantConnectToServer)
                } else {
                    self?.delegate?.didConnectSuccessfully()
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
                code: 4,
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
            
            //Primeiro turno
            sendStartProcess(stage: 32, shouldStart: true)
            
            
            //Segundo turno
            sendStartProcess(stage: 33, shouldStart: true)
            
            
            
            
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
            delegate?.saveLocalPlayerIdentifier(decodedLocalPlayer.player)
        } catch {
            print("PitchABooSocketClient - localPlayer cannot be decoded \(error.localizedDescription)")
        }
    }
    
    private func handlePlayersConnected(with message: DTOTransferMessage) {
        do {
            let decodedLocalPlayer = try decodeData(DTOPlayersConnected.self, from: message.message)
            delegate?.saveAllConnectedPlayers(decodedLocalPlayer.players)
        } catch {
            print("PitchABooSocketClient - connectedPlayers cannot be decoded \(error.localizedDescription)")
        }
    }
    
    private func handleChosenPlayer(with message: DTOTransferMessage) {
        do {
            let decodedChosenPlayer = try decodeData(DTOChosenPlayer.self, from: message.message)
            let chosenPlayer = ChosenPlayer(player: decodedChosenPlayer.player, sellingItem: decodedChosenPlayer.item)
            delegate?.saveChosenPlayer(chosenPlayer)
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
                print("caiu no 33")
                //Start Bid process
                //delegate.bid
            default:
                print("caiu default")
            }
        } catch {
            print("\(#function) \(Self.self) cannot be decoded \(error.localizedDescription)")
        }
    }
}
