//
//  ApplicationSceneHandler.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 26/06/23.
//

import Foundation
import SwiftUI

class ApplicationSceneHandler {
    var viewModel: IOSViewModel?
    
    func handle(_ scene: ScenePhase) {
        let client = PitchABooSocketClient.shared
        if let vm = viewModel {
            switch scene {
            case .background:
                print("BACKGROUND")
                client.pauseSessionMessage(with: vm.localUser)
                client.closeSocket()
            case .inactive:
                print("INACTIVE")
            case .active:
                print("ACTIVE")
                client.resumeSession(to: vm.localUser)
            @unknown default:
                break
            }
        }
    }
}
