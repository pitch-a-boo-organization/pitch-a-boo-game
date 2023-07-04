//
//  WebSocketClient.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation
import Network

final class PitchABooSocketClient: NSObject, PitchABooClient {
    private(set) var baseURL = ""
    private(set) var opened = false
    private(set) var pause = false
    private(set) var webSocket: WebSocketSession?
    static let shared = PitchABooSocketClient()
    weak var output: PitchABooClientOutput?
    lazy var session: URLSessionProtocol = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: nil
    )
    
    func defineServerURL(hostname: String) {
        self.baseURL = "ws://\(hostname):8080"
    }

    func subscribeToService() {
        if !opened { openWebSocket() }
        guard let webSocket = webSocket else { return }
        
        webSocket.receive(completionHandler: { [weak self] result in
            switch result {
                case .failure(_):
                    self?.output?.errorWhileReceivingMessageFromServer(.failWhenReceiveMessage)
                    self?.opened = false
                    return
                case .success(let message):
                    self?.decodeServerMessage(message)
                }
            self?.subscribeToService()
        })
    }
    
    private func openWebSocket() {
        if let url = URL(string: baseURL) {
            let request = URLRequest(url: url)
            let webSocket = session.webSocketTask(with: request)
            self.webSocket = webSocket
            self.opened = true
            self.webSocket?.resume()
        }
    }
    
    private func decodeServerMessage(_ serverMessage: URLSessionWebSocketTask.Message) {
        switch serverMessage {
            case .string:
                break
            case .data(let data):
                do {
                    let message = try JSONDecoder().decode(DTOTransferMessage.self, from: data)
                    handleMessageFromServer(message)
                } catch {
                    output?.errorWhileReceivingMessageFromServer(.unableToDecode)
                }
            default:
                break
        }
    }
    
    func closeSocket() {
        opened = false
        webSocket = nil
    }
    
    func resumeSession(to player: Player) {
        if pause {
            subscribeToService()
            let resumeMessage = DTOTransferMessage(
                code: CommandCode.ClientMessage.resumeSession.rawValue,
                device: .iOS,
                message: try! JSONEncoder().encode(
                    DTOPauseSession(
                        stage: 11,
                        player: player
                    )
                )
            )
            sendMessageToServer(webSocket: webSocket, message: resumeMessage)
        }
    }
    
    func pauseSessionMessage(with player: Player) {
        if !pause {
            pause = true
            let pauseMessage = DTOTransferMessage(
                code: CommandCode.ClientMessage.pauseSession.rawValue,
                device: .iOS,
                message: try! JSONEncoder().encode(
                    DTOPauseSession(
                        stage: CommandCode.ClientMessage.pauseSession.rawValue,
                        player: player
                    )
                )
            )
            sendMessageToServer(webSocket: webSocket, message: pauseMessage)
        }
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
    func sendMessageToServer(webSocket: WebSocketSession?, message: DTOTransferMessage) {
        guard let webSocket = webSocket else { return }
        do {
            let encondedData = try JSONEncoder().encode(message)
            webSocket.send(URLSessionWebSocketTask.Message.data(encondedData)) { [weak self] error in
                if let _ = error {
                    self?.output?.errorWhileSendindMessageToServer(.failWhenSendingMessage)
                }
            }
        } catch {
            self.output?.errorWhileSendindMessageToServer(.unableToEncode)
        }
    }
    
    func sendVerifyAvailability(stage: Int, isAvailable availability: Bool) {
        let dto = DTOVerifyAvailability(stage: stage, available: availability)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(code: CommandCode.ClientMessage.verifyAvailability.rawValue, device: .iOS, message: data)
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            self.output?.errorWhileSendindMessageToServer(.unableToEncode)
        }
    }
    
    func sendConnectSession(stage: Int, shouldSubscribe: Bool) {
        let dto = DTOConnectSession(stage: stage, subscribe: shouldSubscribe)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(code: CommandCode.ClientMessage.connectToSession.rawValue, device: .iOS, message: data)
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            self.output?.errorWhileSendindMessageToServer(.unableToEncode)
        }
    }
    
    func sendStartProcess(stage: Int, shouldStart: Bool) {
        let dto = DTOStartProcess(stage: stage, start: shouldStart)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(code: CommandCode.ClientMessage.startProcess.rawValue, device: .iOS, message: data)
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            self.output?.errorWhileSendindMessageToServer(.unableToEncode)
        }
    }
}

// MARK: - GameFlow Methods
extension PitchABooSocketClient {
    func sendBid(_ dtoBid: DTOBid) {
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
            self.output?.errorWhileSendindMessageToServer(.unableToEncode)
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
        /// Convert CommandCode that was sent as a Integer to CommandCode enum type
        guard let code = CommandCode.ServerMessage(rawValue: message.code) else { return }
            switch code {
                case .statusAvailability:
                    if !pause {
                        sendConnectSession(stage: 10, shouldSubscribe: true)
                    }
                    pause = false
                case .playerIdentifier:
                    handlePlayerIdentifier(with: message)
                    
                case .playersConnected:
                    break
                    
                case .chosenPlayer:
                    handleChosenPlayer(with: message)
                    
                case .startProcess:
                    handleStartProcess(with: message)
                    
                case .saleResult:
                    handleSaleResult(with: message)
                
                default:
                    break
            }
    }
    
    private func handlePlayerIdentifier(with message: DTOTransferMessage) {
        do {
            let decodedLocalPlayer = try decodeData(DTOPlayerIdentifier.self, from: message.message)
            output?.saveLocalPlayerIdentifier(decodedLocalPlayer.player)
        } catch {
            output?.errorWhileReceivingMessageFromServer(.unableToDecode)
        }
    }
    
    private func handleChosenPlayer(with message: DTOTransferMessage) {
        do {
            let decodedChosenPlayer = try decodeData(DTOChosenPlayer.self, from: message.message)
            let chosenPlayer = ChosenPlayer(player: decodedChosenPlayer.player, sellingItem: decodedChosenPlayer.item)
            output?.saveChosenPlayer(chosenPlayer)
        } catch {
            output?.errorWhileReceivingMessageFromServer(.unableToDecode)
        }
    }
    
    private func handleStartProcess(with message: DTOTransferMessage) {
        do {    
            let decodedStartProcess = try decodeData(DTOStartProcess.self, from: message.message)
            output?.didUpdateStage(decodedStartProcess.stage)
        } catch {
            output?.errorWhileReceivingMessageFromServer(.unableToDecode)
        }
    }
    
    private func handleSaleResult(with message: DTOTransferMessage) {
        do {
            let decodedSaleResult = try decodeData(DTOSaleResult.self, from: message.message)
            output?.didFinishInning(with: decodedSaleResult.result)
        } catch {
            output?.errorWhileReceivingMessageFromServer(.unableToDecode)
        }
    }
}
