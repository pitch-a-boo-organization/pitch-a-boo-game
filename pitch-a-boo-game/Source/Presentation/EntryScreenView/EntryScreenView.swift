//
//  EntryScreenView.swift
//  pitch-a-boo-game
//
//  Created by Cicero Nascimento on 20/06/23.
//

import SwiftUI
import PitchABooServer

struct EntryScreenView: View {
    let server = try! PitchABooWebSocketServer(port: 8080)
    @ObservedObject var iOSViewModel = IOSViewModel()
    @ObservedObject var tvOSViewModel = TvOSViewModel()
    
    #if os(iOS)
    init() {
        iOSViewModel.client.iOSDelegate = iOSViewModel
        iOSViewModel.client.tvOSDelegate = tvOSViewModel
    }
    
    var body: some View {
        Group {
            IOSEntryScreenView()
        }
        .environmentObject(iOSViewModel)
    }
    
    #else
    init() {
        server.startServer(completion: { _ in } )
        tvOSViewModel.server = server
        tvOSViewModel.client.tvOSDelegate = tvOSViewModel
    }
    
    var body: some View {
        Group {
            TvOSEntryScreenView()
        }
        .environmentObject(tvOSViewModel)
    }
    #endif
    
    
    

}


