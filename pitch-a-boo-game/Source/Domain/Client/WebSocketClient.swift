//
//  WebSocketClient.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

final class PitchABooSocketClient: NSObject {
    static let shared = PitchABooSocketClient()
    var webSocket: URLSessionWebSocketTask?
    var opened = false
    private var urlString = "ws://localhost:8080"
    
    func subscribeToService(with completion: @escaping (String?) -> Void) {
        if !opened { openWebSocket() }
        
        guard let webSocket = webSocket else {
            completion(nil)
            return
        }
        
        webSocket.receive(completionHandler: { [weak self] result in
            switch result {
                case .failure(_):
                    completion(nil)
                case .success(let webSocketTaskMessage):
                    switch webSocketTaskMessage {
                        case .string:
                            completion(nil)
                        case .data(let data):
                            do {
                                let message = try JSONDecoder().decode(TransferMessage.self, from: data)
                                if message.message == "connected" { self?.subscribeToServer() }
                            } catch {
                                print("Error: \(error.localizedDescription)")
                            }
                        default:
                            //fatalError("Failed. Received unknown data format. Expected String")
                        break
                    }
            }
        })
    }
    
    func subscriptionPayload(for productID: String) -> String? {
        let payload = ["subscribeTo": "trading.product.\(productID)"]
        if let jsonData = try? JSONSerialization.data(withJSONObject: payload, options: []) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
    private func subscribeToServer() {
        guard let webSocket = webSocket else {
            return
        }
        
        print("Send subscription request")
        webSocket.send(
            URLSessionWebSocketTask.Message.data(
                    try! JSONEncoder().encode(
                        TransferMessage(
                        type: .connection,
                        message: "subscribe"
                    )
                )
            )
        ) { error in
            if let error = error {
                print("Failed with Error \(error.localizedDescription)")
            }
        }
        
    }
    
    private func openWebSocket() {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            let webSocket = session.webSocketTask(with: request)
            self.webSocket = webSocket
            self.opened = true
            self.webSocket?.resume()
            print("WebSocket is Open")
        } else {
            webSocket = nil
        }
    }
    
    func closeSocket() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        opened = false
        webSocket = nil
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
