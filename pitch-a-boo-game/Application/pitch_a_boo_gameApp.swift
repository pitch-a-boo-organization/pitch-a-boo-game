//
//  pitch_a_boo_gameApp.swift
//  pitch-a-boo-game
//
//  Created by Thiago Henrique on 14/06/23.
//

import SwiftUI

@main
struct pitch_a_boo_gameApp: App {
    #if os(tvOS)
    @ObservedObject var tvOSViewModel = TvOSViewModel()
    
    init() {
        tvOSViewModel.server.startServer { _ in }
        tvOSViewModel.server.defineOutput(tvOSViewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            TvOSEntryScreenView()
                .environmentObject(tvOSViewModel)
        }
    }
    #else
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
    #endif
}
