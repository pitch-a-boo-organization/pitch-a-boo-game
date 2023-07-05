//
//  WebSocketSession.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation

protocol WebSocketSession {
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void)
    func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping ((Error)?) -> Void)
    func resume()
}
