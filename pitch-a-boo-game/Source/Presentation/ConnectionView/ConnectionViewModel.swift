//
//  ViewModel.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

class ConnectionViewModel: ObservableObject {
    @Published private(set) var connected: Bool = false
    @Published private(set) var receiveFromServer: String = ""
    private(set) var server: PitchABooWebSocketServer = try! PitchABooWebSocketServer(port: 8080)
}

extension ConnectionViewModel: PitchABooSocketDelegate {
    func updateCounter(_ value: String) {
        DispatchQueue.main.async {
            self.receiveFromServer = value
        }
    }
    
    func didConnectSuccessfully() {
        print("Connected")
        DispatchQueue.main.async {
            self.connected = true
        }
    }
    
    func errorWhileSubscribingInService(_ error: ClientError) {
        print("Error in subscribing: \(error.localizedDescription)")
    }
}
