//
//  EntryScreenView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import SwiftUI
import PitchABooServer

struct EntryScreenView: View {
    #if os(iOS)
    @ObservedObject var iOSViewModel = IOSViewModel()
    @Environment(\.scenePhase) var scenePhase
    private var sceneHandler = ApplicationSceneHandler()
    
    init() {
        iOSViewModel.client.iOSDelegate = iOSViewModel
        sceneHandler.viewModel = iOSViewModel
    }
    
    var body: some View {
        Group {
            IOSEntryScreenView()
        }
        .onChange(of: scenePhase, perform: sceneHandler.handle)
        .environmentObject(iOSViewModel)
    }
    
    #else
    @ObservedObject var tvOSViewModel = TvOSViewModel()
    
    init() {
        tvOSViewModel.server.startServer { _ in }
        tvOSViewModel.server.defineOutput(tvOSViewModel)
    }
    
    var body: some View {
        Group {
            TvOSEntryScreenView()
        }
        .environmentObject(tvOSViewModel)
    }
    #endif
    
    
    

}


