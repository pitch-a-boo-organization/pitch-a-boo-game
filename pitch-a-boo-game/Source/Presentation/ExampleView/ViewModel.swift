//
//  ViewModel.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import Foundation

class ViewModel: ObservableObject {
    @Published private(set) var connectionStatus: String = "Offline"
    @Published private(set) var receiveFromServer: String = ""
}

extension ViewModel: PitchABooSocketDelegate {
    func updateCounter(_ value: String) {
        DispatchQueue.main.async {
            self.receiveFromServer = value
        }
    }
    
    func didConnectSuccessfully() {
        print("Connected")
        DispatchQueue.main.async {
            self.connectionStatus = "Connected"
        }
    }
    
    func errorWhileSubscribingInService(_ error: ClientError) {
        print("Error in subscribing: \(error.localizedDescription)")
    }
}
