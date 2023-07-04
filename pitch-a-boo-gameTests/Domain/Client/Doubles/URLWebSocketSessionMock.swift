//
//  URLWebSocketSessionMock.swift
//  pitch-a-boo-gameTests
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation
@testable import pitch_a_boo_game

class URLSessionWebSocketTaskMock: WebSocketSession {
    private(set) var receiveCalled: Int = 0
    private(set) var sendCalled: Int = 0
    private(set) var resumeCalled: Int = 0
    
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        receiveCalled += 1
    }
    
    func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping ((Error)?) -> Void) {
        sendCalled += 1
    }
    
    func resume() {
        resumeCalled += 1
    }
}
