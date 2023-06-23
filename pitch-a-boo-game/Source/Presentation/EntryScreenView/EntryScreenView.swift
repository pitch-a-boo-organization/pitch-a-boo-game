//
//  EntryScreenView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import SwiftUI
import PitchABooServer

struct EntryScreenView: View {
    @ObservedObject var tvOSViewModel = TvOSViewModel()
    @ObservedObject var iOSViewModel = IOSViewModel()
    
    init() {
        let server = try! PitchABooWebSocketServer(port: 8080)
        
        tvOSViewModel.server = server
        tvOSViewModel.client.tvOSDelegate = tvOSViewModel
        iOSViewModel.server = server
        iOSViewModel.client.iOSDelegate = iOSViewModel
    }
    
    var body: some View {
        Group {
            #if os(tvOS)
            TvOSEntryScreenView()
            #else
            IOSEntryScreenView()
            #endif
        }
        .environmentObject(tvOSViewModel)
        .environmentObject(iOSViewModel)
    }
}


