//
//  URLSessionProtocol.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation

protocol URLSessionProtocol {
    func webSocketTask(with url: URLRequest) -> WebSocketSession
}
