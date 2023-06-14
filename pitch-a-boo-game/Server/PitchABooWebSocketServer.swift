//
//  PitchABooWebSocketServer.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation
import Network

class PitchABooWebSocketServer {
    var listener: NWListener
    var connectedClients: [NWConnection] = []
        
    init(port: UInt16) throws {
        let parameters = NWParameters(tls: nil)
        parameters.allowLocalEndpointReuse = true
        parameters.includePeerToPeer = true

        let wsOptions = NWProtocolWebSocket.Options()
        wsOptions.autoReplyPing = true

        parameters.defaultProtocolStack.applicationProtocols.insert(wsOptions, at: 0)

        do {
            if let port = NWEndpoint.Port(rawValue: port) {
                listener = try NWListener(using: parameters, on: port)
            } else {
                throw WebSocketError.unableToStartInPort(port)
            }
        } catch {
            throw WebSocketError.unableToInitializeListener
        }
    }
}

// MARK: - Server Connection Handler
extension PitchABooWebSocketServer {
    func startServer(completion: @escaping (WebSocketError?) -> Void ) {
        let serverQueue = DispatchQueue(label: "ServerQueue")

        listener.newConnectionHandler = { [weak self] newConnection in
            self?.didReceiveAConnection(newConnection, completion: completion)
            self?.didUpdateConnectionState(newConnection)
            newConnection.start(queue: serverQueue)
        }

        listener.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    completion(nil)
                case .failed(let error):
                    completion(.serverInitializationFail(error.localizedDescription))
                default:
                    break
            }
        }

        listener.start(queue: serverQueue)
    }
}

// MARK: - Client Connection Handler
extension PitchABooWebSocketServer {
    private func didReceiveAConnection(
        _ connection: NWConnection,
        completion: @escaping (WebSocketError?) -> Void
    ) {
        connection.receiveMessage { [weak self] (data, context, isComplete, error) in
            if let data = data, let context = context {
                do {
                    try self?.handleMessageFromClient(
                        data: data,
                        context: context,
                        stringVal: "",
                        connection: connection
                    )
                } catch {
                    completion(.cantHandleClientConnection)
                }
                self?.didReceiveAConnection(connection, completion: completion)
            }
        }
    }

    private func didUpdateConnectionState(_ connection: NWConnection) {
        connection.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    print("Client ready")
                case .failed(let error):
                    print("Client connection failed \(error.localizedDescription)")
                case .waiting(let error):
                    print("Waiting for long time \(error.localizedDescription)")
                default:
                    break
            }
        }
    }
    
    func handleMessageFromClient(data: Data, context: NWConnection.ContentContext, stringVal: String, connection: NWConnection) throws {
        if let message = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let _ = message["subscribeTo"] {
                self.connectedClients.append(connection)
            }
            if let id = message["unsubscribeFrom"] as? Int {
                let connection = self.connectedClients.remove(at: id)
                connection.cancel()
                connection.stateUpdateHandler = nil
            }
        }
    }
}
