//
//  URLWebSocketSessionMock.swift
//  pitch-a-boo-gameTests
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation
@testable import pitch_a_boo_game

class URLSessionWebSocketTaskMock: WebSocketSession {
    // MARK: - Test variables
    private(set) var receiveCalled: Int = 0
    private(set) var sendCalled: Int = 0
    private(set) var resumeCalled: Int = 0
    
    // MARK: - Completion Handlers
    var receiveCompletionHandler: ((Result<URLSessionWebSocketTask.Message, Error>) -> Void)?
    
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        receiveCalled += 1
        receiveCompletionHandler = completionHandler
    }
    
    func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping ((Error)?) -> Void) {
        sendCalled += 1
    }
    
    func resume() {
        resumeCalled += 1
    }
}
