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
    
    init() {
        iOSViewModel.client.iOSDelegate = iOSViewModel
    }
    
    var body: some View {
        Group {
            IOSEntryScreenView()
        }
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


