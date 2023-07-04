//
//  URLSessionMock.swift
//  pitch-a-boo-gameTests
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation
@testable import pitch_a_boo_game

class URLSessionMock: URLSessionProtocol {
    let socketMock: WebSocketSession
    
    init(socketMock: WebSocketSession) { self.socketMock = socketMock }
    
    func webSocketTask(with url: URLRequest) -> WebSocketSession {
        return socketMock 
    }
}
