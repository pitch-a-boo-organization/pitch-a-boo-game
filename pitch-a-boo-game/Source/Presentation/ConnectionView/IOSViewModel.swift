//
//  IOSViewModel.swift
//  pitch-a-boo-game
//
//  Created by Joan Wilson Oliveira on 23/06/23.
//

import Foundation

class IOSViewModel: ObservableObject {
    
}

extension IOSViewModel: IOSDelegate {
    func didConnectSuccessFully() {
        
    }
    
    func errorWhileSubscribingInService(_ error: ClientError) {
        
    }
    
    func saveLocalPlayerIdentifier(_ player: Player) {
        
    }
    
    
}

extension IOSViewModel: SocketDelegate {
    func saveChosenPlayer(_ chosenPlayer: ChosenPlayer) {
        
    }
    
    func sentSuccesfully() {
        
    }
    
    func failedToSend(error: ClientError) {
        
    }
    
    
}
