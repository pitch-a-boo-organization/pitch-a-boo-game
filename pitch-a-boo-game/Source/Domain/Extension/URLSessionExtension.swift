//
//  URLSessionExtension.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 03/07/23.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func webSocketTask(with url: URLRequest) -> WebSocketSession {
        return webSocketTask(with: url.url!, protocols: [])
    }
    
}
