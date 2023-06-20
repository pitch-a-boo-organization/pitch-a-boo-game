//
//  WebSocketClient.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation
import Network

protocol PitchABooSocketDelegate: AnyObject {
    func didConnectSuccessfully()
    func errorWhileSubscribingInService(_ error: ClientError)
    func updateCounter(_ value: String)
}

final class PitchABooSocketClient: NSObject {
    private var baseURL = ""
    private(set) var opened = false
    private(set) var webSocket: URLSessionWebSocketTask?
    weak var delegate: PitchABooSocketDelegate?
    static let shared = PitchABooSocketClient()
    
    func defineServerURL(hostname: String) {
        self.baseURL = "ws://\(hostname):8080"
    }
    
    func subscribeToService() {
        if !opened { openWebSocket() }
        guard let webSocket = webSocket else { return }
        
        webSocket.receive(completionHandler: { [weak self] result in
            switch result {
            case .failure(_):
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
            do {
                let message = try JSONDecoder().decode(DTOTransferMessage.self, from: data)
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

extension PitchABooSocketClient {
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

    
    func sendVerifyAvailability(stage: Int, isAvailable availability: Bool) {
        let dto = DTOVerifyAvailability(stage: stage, available: availability)
        do {
            let data = try JSONEncoder().encode(dto)
            let transferMessage = DTOTransferMessage(code: .connectionAvailability, device: .iOS, message: data)
            sendMessageToServer(webSocket: webSocket, message: transferMessage)
        } catch {
            print("PitchABooSocketClient - Cannot encode data \(error.localizedDescription)")
        }
    }
}

extension PitchABooSocketClient: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        opened = true
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        self.webSocket = nil
        self.opened = false
    }
}

extension PitchABooSocketClient {
    func handleMessageFromServer(_ message: DTOTransferMessage) {
        print(message)
//        switch message.type {
//        case .connection:
//            if message.message == "connected" {
//                subscribeToServer()
//            }
//        case .count:
//            delegate?.updateCounter(message.message)
//        }
    }
}
