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
    
    func sendMessageToClient(data: Data, client: NWConnection) throws {
        print("SENDING MESSAGE TO CLIENT")
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "context", metadata: [metadata])
        
        client.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed({ error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                // no-op
            }
        }))
    }
}

// MARK: - Server Connection Handler
extension PitchABooWebSocketServer {
    func startServer(completion: @escaping (WebSocketError?) -> Void ) {
        let serverQueue = DispatchQueue(label: "ServerQueue")

        listener.newConnectionHandler = { newConnection in
            print("RECEIVING NEW CONNECTION")
            self.didReceiveAConnection(newConnection, completion: completion)
            self.didUpdateConnectionState(newConnection)
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
        print("UPDATING CONNECTION STATE")
        connection.stateUpdateHandler = { state in
            switch state {
                case .ready:
                    try! self.sendMessageToClient(
                            data: JSONEncoder().encode(
                                TransferMessage(
                                    type: .connection,
                                    message: "connected"
                                )
                            ),
                            client: connection
                    )
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
        if let message = try? JSONDecoder().decode(TransferMessage.self, from: data)  {
            switch message.type {
                case .connection:
                    if message.message == "subscribe" {
                        self.connectedClients.append(connection)
                    }
            }
//            if let _ = message["subscribeTo"] {
//                self.connectedClients.append(connection)
//            }
//            if let id = message["unsubscribeFrom"] as? Int {
//                let connection = self.connectedClients.remove(at: id)
//                connection.cancel()
//                connection.stateUpdateHandler = nil
//            }
        }
    }
}
